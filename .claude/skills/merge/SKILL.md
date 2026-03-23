---
name: merge
description: 合并指定的Pull Request
trigger: /merge
model: sonnet
---

# PR 合并自动化

使用GitHub API合并Pull Request。

## 执行步骤

### 1. 获取PR信息

```bash
# 列出所有open的PR
curl -H "Authorization: token ${GITHUB_PERSONAL_ACCESS_TOKEN}" \
  "https://api.github.com/repos/OWNER/REPO/pulls?state=open"
```

向用户展示PR列表，让用户选择要合并的PR。

### 2. 检查PR状态

验证PR是否可以合并：
- ✅ 没有冲突
- ✅ CI/CD检查通过（如果有）
- ✅ 有必要的审批（如果需要）

### 3. 合并PR

使用GitHub API合并：

```bash
# Squash合并（推荐）
curl -X PUT \
  -H "Authorization: token ${GITHUB_PERSONAL_ACCESS_TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/OWNER/REPO/pulls/${PR_NUMBER}/merge \
  -d '{
    "merge_method": "squash",
    "commit_title": "标题",
    "commit_message": "描述"
  }'
```

**合并方式选项**:
- `merge` - 标准合并（保留所有commit）
- `squash` - 压缩合并（合并为一个commit）
- `rebase` - 变基合并（线性历史）

### 4. 更新本地仓库

```bash
# 切换到main分支
git checkout main

# 拉取最新代码
git pull origin main
```

### 5. 清理分支（可选）

询问是否删除源分支：

```bash
# 删除远程分支
git push origin --delete branch-name

# 删除本地分支
git branch -d branch-name
```

### 6. 报告结果

```
╔═══════════════════════════════════════╗
║  PR 合并报告                          ║
╚═══════════════════════════════════════╝

PR #123: Add new feature
  源分支: feature/new-feature
  目标分支: main
  合并方式: squash

✅ 合并成功
✅ 分支已删除
✅ 本地已更新

合并后commit: abc1234
```

## 使用示例

```
用户: /merge

Claude:
📋 找到以下open的PR:

1. PR #123 - Add new feature (feature/new-feature → main)
2. PR #124 - Fix bug (bugfix/auth → main)

请选择要合并的PR编号: 

用户: 1

Claude:
🔍 检查PR #123...
✅ 无冲突
✅ 所有检查通过

使用什么合并方式？
1. Squash (推荐) - 压缩为一个commit
2. Merge - 保留所有commit
3. Rebase - 线性历史

用户: 1

Claude:
⏳ 正在合并...
✅ PR #123 已成功合并！

是否删除源分支 feature/new-feature? (yes/no)
```

## 参数选项

```
/merge 123              # 直接指定PR编号
/merge --squash         # 使用squash方式
/merge --no-delete      # 不删除分支
/merge --auto           # 自动选择第一个PR
```

## 安全检查

合并前会检查：
- PR状态必须是open
- 必须没有冲突
- 必须有合并权限
- CI/CD必须通过（如果配置）
