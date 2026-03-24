# GitHub PR & Issue 管理指南

## 📊 当前仓库状态分析

### Pull Requests 状态

#### PR #1: "添加新功能" 
- **状态**: ⚠️ Open (未合并)
- **链接**: https://github.com/545487677/claude_code_learning/pull/1
- **分支**: `feature/test-mcp` → `main`
- **创建时间**: 2026-03-23 13:10:24
- **内容**: 添加 test_feature.md 文件
- **建议**: 可以合并或关闭

#### PR #3: "🧪 测试PR: 20260323_131752"
- **状态**: ✅ Closed (已合并)
- **链接**: https://github.com/545487677/claude_code_learning/pull/3
- **分支**: `test/pr-script-20260323_131752` → `main`
- **合并时间**: 2026-03-23 13:19:24
- **内容**: 添加 test_pr_20260323_131752.md 测试文件
- **状态**: ✅ 已完成

### Issues 状态

#### Issue #2: "测试MCP"
- **状态**: ⚠️ Open (待关闭)
- **链接**: https://github.com/545487677/claude_code_learning/issues/2
- **创建时间**: 2026-03-23 13:10:44
- **目的**: 验证GitHub MCP集成功能
- **测试项目**:
  - [x] GitHub token配置
  - [x] 代码推送
  - [x] PR创建
  - [x] Issue创建 (本身就是这个Issue)
- **建议**: 可以关闭，测试已完成

## 🎯 操作建议

### 1. 合并或关闭 PR #1

PR #1 添加了 test_feature.md，是测试MCP功能的文件。

**选项A：合并PR**（推荐，保留测试内容）

```bash
# 方式1: 使用 GitHub API 合并
curl -X PUT \
  -H "Authorization: token YOUR_GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/545487677/claude_code_learning/pulls/1/merge \
  -d '{
    "commit_title": "Merge PR #1: 添加新功能",
    "commit_message": "合并测试功能文件\n\n- 添加test_feature.md\n- 验证GitHub MCP集成",
    "merge_method": "squash"
  }'

# 方式2: 使用 git 命令行
git checkout main
git pull origin main
git merge feature/test-mcp
git push origin main

# 合并后删除分支
git branch -d feature/test-mcp
git push origin --delete feature/test-mcp
```

**选项B：关闭PR**（如果不需要这些测试文件）

```bash
# 使用 GitHub API 关闭PR
curl -X PATCH \
  -H "Authorization: token YOUR_GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/545487677/claude_code_learning/pulls/1 \
  -d '{"state": "closed"}'

# 删除分支
git branch -d feature/test-mcp
git push origin --delete feature/test-mcp
```

### 2. 关闭 Issue #2

Issue #2 是测试Issue，所有测试项目已完成。

```bash
# 添加完成评论并关闭
curl -X POST \
  -H "Authorization: token YOUR_GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/545487677/claude_code_learning/issues/2/comments \
  -d '{
    "body": "## ✅ 测试完成\n\n所有测试项目已完成验证：\n\n- [x] GitHub token配置 - 成功\n- [x] 代码推送 - 成功\n- [x] PR创建 - 成功 (PR #1, #3)\n- [x] Issue创建 - 成功 (本Issue)\n\n测试结论：GitHub MCP集成功能正常工作！"
  }'

# 关闭Issue
curl -X PATCH \
  -H "Authorization: token YOUR_GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/545487677/claude_code_learning/issues/2 \
  -d '{"state": "closed"}'
```

### 3. 清理已合并的分支

```bash
# 查看所有远程分支
git branch -r

# 删除已合并的远程分支（PR #3的分支已自动删除或可手动删除）
git push origin --delete test/pr-script-20260323_131752

# 清理本地的远程跟踪分支
git fetch --prune
```

## 📋 完整操作流程

### 推荐的清理流程

```bash
# ========================================
# 步骤1: 查看当前状态
# ========================================
echo "=== 当前分支状态 ==="
git branch -a

echo -e "\n=== 当前工作目录状态 ==="
git status

# ========================================
# 步骤2: 确保在main分支并更新
# ========================================
git checkout main
git pull origin main

# ========================================
# 步骤3: 合并 PR #1 (feature/test-mcp)
# ========================================
git merge feature/test-mcp -m "Merge branch 'feature/test-mcp' - 添加MCP测试功能

- 添加test_feature.md测试文件
- 验证GitHub MCP集成功能

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"

# 推送合并结果
git push origin main

# ========================================
# 步骤4: 删除已合并的本地分支
# ========================================
git branch -d feature/test-mcp
git branch -d test/pr-script-20260323_131752 2>/dev/null || echo "分支不存在或已删除"

# ========================================
# 步骤5: 删除远程分支
# ========================================
git push origin --delete feature/test-mcp
git push origin --delete test/pr-script-20260323_131752 2>/dev/null || echo "远程分支不存在"

# ========================================
# 步骤6: 清理远程跟踪分支
# ========================================
git fetch --prune

# ========================================
# 步骤7: 验证清理结果
# ========================================
echo -e "\n=== 剩余分支 ==="
git branch -a

echo -e "\n=== 本地状态 ==="
git status
```

## 🔧 使用脚本自动化

我们提供了一个自动化脚本来完成这些操作：`scripts/cleanup_pr_issue.sh`

```bash
# 运行清理脚本
./scripts/cleanup_pr_issue.sh

# 脚本会自动：
# 1. 合并未合并的PR
# 2. 关闭完成的Issue
# 3. 删除已合并的分支
# 4. 清理远程跟踪引用
```

## 📚 Git 命令详解

### 分支管理

```bash
# 查看所有分支（包括远程）
git branch -a

# 查看已合并到main的分支
git branch --merged main

# 查看未合并到main的分支
git branch --no-merged main

# 删除本地分支
git branch -d <branch-name>     # 安全删除（需已合并）
git branch -D <branch-name>     # 强制删除

# 删除远程分支
git push origin --delete <branch-name>

# 清理过期的远程跟踪分支
git fetch --prune
git remote prune origin
```

### PR 操作

```bash
# 查看PR信息（需要安装 gh CLI）
gh pr list
gh pr view 1
gh pr merge 1

# 或使用curl + GitHub API
# 查看PR
curl -H "Authorization: token TOKEN" \
  https://api.github.com/repos/OWNER/REPO/pulls/1

# 合并PR
curl -X PUT \
  -H "Authorization: token TOKEN" \
  https://api.github.com/repos/OWNER/REPO/pulls/1/merge \
  -d '{"merge_method": "squash"}'

# 关闭PR
curl -X PATCH \
  -H "Authorization: token TOKEN" \
  https://api.github.com/repos/OWNER/REPO/pulls/1 \
  -d '{"state": "closed"}'
```

### Issue 操作

```bash
# 查看Issue（需要 gh CLI）
gh issue list
gh issue view 2
gh issue close 2

# 或使用curl + GitHub API
# 添加评论
curl -X POST \
  -H "Authorization: token TOKEN" \
  https://api.github.com/repos/OWNER/REPO/issues/2/comments \
  -d '{"body": "评论内容"}'

# 关闭Issue
curl -X PATCH \
  -H "Authorization: token TOKEN" \
  https://api.github.com/repos/OWNER/REPO/issues/2 \
  -d '{"state": "closed"}'
```

## 🚀 推送当前所有更改

### 一次性推送所有文档和脚本

```bash
# ========================================
# 完整的推送流程
# ========================================

# 1. 查看当前状态
git status

# 2. 添加所有新文件
git add doc/
git add scripts/

# 3. 查看将要提交的内容
git diff --cached --stat

# 4. 提交更改
git commit -m "docs: 添加PR/Issue管理文档和清理脚本

新增内容：
- doc/mcp_learn/pr_issue_management.md: PR和Issue管理指南
- doc/mcp_learn/github_mcp.md: GitHub MCP集成学习笔记
- scripts/test_pr.sh: PR自动化测试脚本
- scripts/cleanup_pr_issue.sh: PR/Issue清理脚本
- scripts/README.md: 脚本使用说明

更新内容：
- 完善Git操作命令文档
- 添加故障排查指南
- 提供自动化脚本

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"

# 5. 推送到远程仓库
git push origin main

# 6. 验证推送结果
git log --oneline -3
```

### 分步推送（更谨慎）

```bash
# 步骤1: 添加文档
git add doc/mcp_learn/*.md
git status

# 步骤2: 提交文档
git commit -m "docs: 添加GitHub MCP和PR管理文档"

# 步骤3: 添加脚本
git add scripts/
git status

# 步骤4: 提交脚本
git commit -m "feat: 添加PR测试和清理自动化脚本"

# 步骤5: 推送所有提交
git push origin main
```

## ⚠️ 注意事项

### 推送前检查

- [ ] 确保在正确的分支（通常是main）
- [ ] 检查没有未暂存的重要修改
- [ ] 验证提交信息准确描述了变更
- [ ] 确认没有包含敏感信息（token、密码等）

### 合并PR前检查

- [ ] 代码审查已完成
- [ ] 测试已通过
- [ ] 没有冲突
- [ ] CI/CD检查通过（如果配置了）

### 删除分支前确认

- [ ] 分支已完全合并或不再需要
- [ ] 没有未推送的重要提交
- [ ] 团队成员不再需要该分支

## 🎓 学习要点

### 1. Git 工作流

```
工作区 → 暂存区 → 本地仓库 → 远程仓库
  ↓        ↓          ↓           ↓
修改    git add   git commit  git push
```

### 2. 分支管理策略

```
main (生产分支，受保护)
  ↑
  ├── feature/* (功能分支)
  ├── bugfix/* (修复分支)
  └── test/* (测试分支)
```

### 3. PR 生命周期

```
创建分支 → 开发 → 提交 → 推送 → 创建PR → 审查 → 合并 → 删除分支
```

### 4. Issue 管理

```
创建Issue → 分配 → 开发 → 关联PR → PR合并 → 关闭Issue
```

## 📖 相关资源

- [Git分支管理](https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell)
- [GitHub PR最佳实践](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests)
- [GitHub Issue管理](https://docs.github.com/en/issues/tracking-your-work-with-issues)
- [Git命令参考](https://git-scm.com/docs)

## 🔍 故障排查

### 问题1: 推送被拒绝

```bash
# 错误: Updates were rejected because the tip of your current branch is behind
git pull --rebase origin main
git push origin main
```

### 问题2: 合并冲突

```bash
# 查看冲突文件
git status

# 编辑冲突文件，解决冲突
# 标记为已解决
git add <conflicted-file>

# 完成合并
git commit
```

### 问题3: 误删分支

```bash
# 查看最近删除的分支的提交
git reflog

# 恢复分支
git branch <branch-name> <commit-hash>
```

## ✅ 执行清单

按照以下顺序执行操作：

- [ ] 1. 查看当前PR和Issue状态
- [ ] 2. 决定PR #1是合并还是关闭
- [ ] 3. 关闭已完成的Issue #2
- [ ] 4. 清理已合并的分支
- [ ] 5. 添加新的文档和脚本
- [ ] 6. 提交并推送更改
- [ ] 7. 验证远程仓库状态

---

📝 **文档创建时间**: 2026-03-23
🔄 **最后更新**: 2026-03-23
✍️ **作者**: Claude Code Automation
