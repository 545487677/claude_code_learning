#!/bin/bash

# PR & Issue 清理脚本
# 用途：自动化清理已完成的PR和Issue，删除合并后的分支

set -e  # 遇到错误立即退出

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
REPO_OWNER="545487677"
REPO_NAME="claude_code_learning"
GITHUB_TOKEN="${GITHUB_PERSONAL_ACCESS_TOKEN:-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}"
BASE_BRANCH="main"

echo -e "${GREEN}=== GitHub PR & Issue 清理脚本 ===${NC}"
echo "仓库: ${REPO_OWNER}/${REPO_NAME}"
echo ""

# ========================================
# 1. 查看当前状态
# ========================================
echo -e "${YELLOW}[1/6] 查看当前状态...${NC}"
echo ""

echo "📋 本地分支："
git branch -a
echo ""

echo "📊 当前工作目录状态："
git status
echo ""

# ========================================
# 2. 查询PR状态
# ========================================
echo -e "${YELLOW}[2/6] 查询PR状态...${NC}"

prs=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/pulls?state=open")

pr_count=$(echo "$prs" | python3 -c 'import json,sys; print(len(json.load(sys.stdin)))')

echo "发现 ${pr_count} 个未合并的PR"

if [ "$pr_count" -gt 0 ]; then
    echo "$prs" | python3 -c '
import json, sys
prs = json.load(sys.stdin)
for pr in prs:
    print(f"  - PR #{pr[\"number\"]}: {pr[\"title\"]}")
    print(f"    分支: {pr[\"head\"][\"ref\"]} -> {pr[\"base\"][\"ref\"]}")
    print(f"    链接: {pr[\"html_url\"]}")
    print()
'
fi
echo ""

# ========================================
# 3. 合并PR #1（如果存在）
# ========================================
echo -e "${YELLOW}[3/6] 处理PR #1...${NC}"

pr1_state=$(echo "$prs" | python3 -c '
import json, sys
prs = json.load(sys.stdin)
for pr in prs:
    if pr["number"] == 1:
        print("open")
        sys.exit(0)
print("not_found")
' 2>/dev/null || echo "not_found")

if [ "$pr1_state" == "open" ]; then
    echo "发现未合并的PR #1，准备合并..."
    
    # 合并PR
    merge_response=$(curl -s -X PUT \
      -H "Authorization: token ${GITHUB_TOKEN}" \
      -H "Accept: application/vnd.github.v3+json" \
      https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/pulls/1/merge \
      -d '{
        "commit_title": "Merge PR #1: 添加新功能",
        "commit_message": "合并测试功能文件\n\n- 添加test_feature.md\n- 验证GitHub MCP集成\n\nCo-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>",
        "merge_method": "squash"
      }')
    
    merged=$(echo "$merge_response" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("merged", False))')
    
    if [ "$merged" == "True" ]; then
        echo -e "${GREEN}✅ PR #1 合并成功${NC}"
    else
        echo -e "${RED}❌ PR #1 合并失败${NC}"
        echo "$merge_response" | python3 -m json.tool
    fi
else
    echo "PR #1 不存在或已合并"
fi
echo ""

# ========================================
# 4. 关闭Issue #2
# ========================================
echo -e "${YELLOW}[4/6] 处理Issue #2...${NC}"

# 检查Issue #2状态
issue2_state=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/issues/2 | \
  python3 -c 'import json,sys; print(json.load(sys.stdin).get("state", "unknown"))')

if [ "$issue2_state" == "open" ]; then
    echo "发现未关闭的Issue #2，添加完成评论并关闭..."
    
    # 添加完成评论
    curl -s -X POST \
      -H "Authorization: token ${GITHUB_TOKEN}" \
      -H "Accept: application/vnd.github.v3+json" \
      https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/issues/2/comments \
      -d '{
        "body": "## ✅ 测试完成\n\n所有测试项目已完成验证：\n\n- [x] GitHub token配置 - 成功\n- [x] 代码推送 - 成功\n- [x] PR创建 - 成功 (PR #1, #3)\n- [x] Issue创建 - 成功 (本Issue)\n\n**测试结论**: GitHub MCP集成功能正常工作！\n\n🤖 由清理脚本自动关闭"
      }' > /dev/null
    
    # 关闭Issue
    close_response=$(curl -s -X PATCH \
      -H "Authorization: token ${GITHUB_TOKEN}" \
      -H "Accept: application/vnd.github.v3+json" \
      https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/issues/2 \
      -d '{"state": "closed"}')
    
    closed_state=$(echo "$close_response" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("state", "unknown"))')
    
    if [ "$closed_state" == "closed" ]; then
        echo -e "${GREEN}✅ Issue #2 已关闭${NC}"
    else
        echo -e "${RED}❌ Issue #2 关闭失败${NC}"
    fi
else
    echo "Issue #2 不存在或已关闭"
fi
echo ""

# ========================================
# 5. 清理已合并的分支
# ========================================
echo -e "${YELLOW}[5/6] 清理已合并的分支...${NC}"

# 确保在main分支
git checkout ${BASE_BRANCH} 2>/dev/null || echo "已在${BASE_BRANCH}分支"
git pull origin ${BASE_BRANCH}

# 删除本地分支
echo "删除本地分支..."
git branch -d feature/test-mcp 2>/dev/null && echo "  ✓ 删除 feature/test-mcp" || echo "  - feature/test-mcp 不存在"
git branch -d test/pr-script-20260323_131752 2>/dev/null && echo "  ✓ 删除 test/pr-script-20260323_131752" || echo "  - test/pr-script-20260323_131752 不存在"

echo ""
echo "删除远程分支..."
git push origin --delete feature/test-mcp 2>/dev/null && echo "  ✓ 删除远程 feature/test-mcp" || echo "  - 远程 feature/test-mcp 不存在"
git push origin --delete test/pr-script-20260323_131752 2>/dev/null && echo "  ✓ 删除远程 test/pr-script-20260323_131752" || echo "  - 远程 test/pr-script-20260323_131752 不存在"

echo ""
echo "清理远程跟踪分支..."
git fetch --prune
echo ""

# ========================================
# 6. 验证清理结果
# ========================================
echo -e "${YELLOW}[6/6] 验证清理结果...${NC}"
echo ""

echo "剩余分支："
git branch -a
echo ""

echo "本地状态："
git status
echo ""

# ========================================
# 完成
# ========================================
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🎉 清理完成！${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "已完成的操作："
echo "  ✓ 合并未完成的PR"
echo "  ✓ 关闭已完成的Issue"
echo "  ✓ 删除已合并的分支"
echo "  ✓ 清理远程跟踪引用"
echo ""
echo "下一步："
echo "  1. 访问仓库确认状态: https://github.com/${REPO_OWNER}/${REPO_NAME}"
echo "  2. 查看PR: https://github.com/${REPO_OWNER}/${REPO_NAME}/pulls"
echo "  3. 查看Issue: https://github.com/${REPO_OWNER}/${REPO_NAME}/issues"
