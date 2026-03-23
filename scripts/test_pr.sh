#!/bin/bash

# GitHub PR 测试脚本
# 用途：测试通过SSH推送代码并创建PR

set -e  # 遇到错误立即退出

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 配置
REPO_OWNER="545487677"
REPO_NAME="claude_code_learning"
GITHUB_TOKEN="${GITHUB_PERSONAL_ACCESS_TOKEN:-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}"
BASE_BRANCH="main"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FEATURE_BRANCH="test/pr-script-${TIMESTAMP}"

echo -e "${GREEN}=== GitHub PR 测试脚本 ===${NC}"
echo "仓库: ${REPO_OWNER}/${REPO_NAME}"
echo "分支: ${FEATURE_BRANCH}"
echo ""

# 1. 检查当前git状态
echo -e "${YELLOW}[1/7] 检查当前状态...${NC}"
git status
echo ""

# 2. 确保使用SSH协议
echo -e "${YELLOW}[2/7] 设置远程仓库为SSH协议...${NC}"
git remote set-url origin git@github.com:${REPO_OWNER}/${REPO_NAME}.git
git remote -v
echo ""

# 3. 确保在main分支并更新
echo -e "${YELLOW}[3/7] 切换到main分支并更新...${NC}"
git checkout ${BASE_BRANCH}
git pull origin ${BASE_BRANCH} || echo "拉取失败，继续执行..."
echo ""

# 4. 创建新的测试分支
echo -e "${YELLOW}[4/7] 创建测试分支 ${FEATURE_BRANCH}...${NC}"
git checkout -b ${FEATURE_BRANCH}
echo ""

# 5. 创建测试文件
echo -e "${YELLOW}[5/7] 创建测试文件...${NC}"
TEST_FILE="test_pr_${TIMESTAMP}.md"
cat > ${TEST_FILE} << EOF
# PR 测试文件

## 测试信息
- 创建时间: $(date '+%Y-%m-%d %H:%M:%S')
- 分支名称: ${FEATURE_BRANCH}
- 测试目的: 验证SSH推送和PR创建流程

## 测试内容
1. ✅ 使用SSH协议推送代码
2. ✅ 自动创建Pull Request
3. ✅ 验证完整的Git工作流

## 技术栈
- Git SSH协议
- GitHub REST API
- Bash脚本自动化

---
🤖 由测试脚本自动生成
EOF

echo "创建文件: ${TEST_FILE}"
cat ${TEST_FILE}
echo ""

# 6. 提交更改
echo -e "${YELLOW}[6/7] 提交更改...${NC}"
git add ${TEST_FILE}
git commit -m "$(cat <<'COMMIT_MSG'
测试: 添加PR测试文件

- 使用SSH协议推送
- 验证自动化PR创建流程
- 测试时间戳分支管理

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
COMMIT_MSG
)"
echo ""

# 7. 推送到远程（使用SSH）
echo -e "${YELLOW}[7/7] 推送分支到远程...${NC}"
echo "执行: git push -u origin ${FEATURE_BRANCH}"
git push -u origin ${FEATURE_BRANCH}

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ 推送成功！${NC}"
else
    echo -e "${RED}❌ 推送失败${NC}"
    exit 1
fi
echo ""

# 8. 创建Pull Request（使用GitHub API）
echo -e "${YELLOW}[8/8] 创建Pull Request...${NC}"

PR_TITLE="🧪 测试PR: ${TIMESTAMP}"
PR_BODY="## 📝 自动化测试PR

### 测试信息
- **分支**: \`${FEATURE_BRANCH}\`
- **创建时间**: $(date '+%Y-%m-%d %H:%M:%S')
- **测试文件**: \`${TEST_FILE}\`

### ✅ 测试项目
- [x] SSH协议配置
- [x] Git分支创建
- [x] 代码提交
- [x] 远程推送
- [x] PR自动创建

### 🔍 验证点
1. SSH推送是否成功
2. 分支是否正确创建
3. PR是否自动生成
4. 描述信息是否完整

### 📊 技术细节
\`\`\`bash
# 远程仓库协议
git remote -v
# origin  git@github.com:${REPO_OWNER}/${REPO_NAME}.git (fetch)
# origin  git@github.com:${REPO_OWNER}/${REPO_NAME}.git (push)

# 推送命令
git push -u origin ${FEATURE_BRANCH}
\`\`\`

---
🤖 由测试脚本自动生成 | Generated with [Claude Code](https://claude.com/claude-code)"

# 调用GitHub API创建PR
response=$(curl -s -X POST \
  -H "Authorization: token ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/pulls \
  -d @- << EOF_JSON
{
  "title": "${PR_TITLE}",
  "head": "${FEATURE_BRANCH}",
  "base": "${BASE_BRANCH}",
  "body": $(echo "${PR_BODY}" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')
}
EOF_JSON
)

# 解析响应
pr_url=$(echo ${response} | python3 -c 'import json,sys; data=json.load(sys.stdin); print(data.get("html_url", ""))')
pr_number=$(echo ${response} | python3 -c 'import json,sys; data=json.load(sys.stdin); print(data.get("number", ""))')

if [ ! -z "$pr_url" ]; then
    echo -e "${GREEN}✅ PR创建成功！${NC}"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${GREEN}📋 PR信息${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  编号: #${pr_number}"
    echo "  标题: ${PR_TITLE}"
    echo "  分支: ${FEATURE_BRANCH} -> ${BASE_BRANCH}"
    echo "  链接: ${pr_url}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo -e "${GREEN}🎉 测试完成！所有步骤执行成功！${NC}"
    echo ""
    echo "下一步操作："
    echo "  1. 访问 ${pr_url} 查看PR"
    echo "  2. 审查变更内容"
    echo "  3. 合并或关闭PR"
    echo "  4. 删除测试分支: git branch -d ${FEATURE_BRANCH}"
else
    echo -e "${RED}❌ PR创建失败${NC}"
    echo "响应内容："
    echo ${response} | python3 -m json.tool
    exit 1
fi
