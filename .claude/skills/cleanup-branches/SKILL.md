---
name: cleanup-branches
description: 清理所有分支，只保留main分支
trigger: /cleanup-branches
model: sonnet
---

# 分支清理自动化

清理本地和远程的所有分支，只保留 main 分支。

## 执行步骤

### 1. 确认当前状态

```bash
# 显示所有分支
git branch -a

# 确认当前在main分支
git branch --show-current
```

向用户显示将要删除的分支列表，并询问确认。

### 2. 切换到main分支

```bash
# 如果不在main分支，先切换
git checkout main

# 拉取最新代码
git pull origin main
```

### 3. 删除本地分支

```bash
# 列出除main外的所有本地分支
BRANCHES=$(git branch | grep -v "main" | grep -v "\*" | xargs)

# 逐个删除
for branch in $BRANCHES; do
  git branch -D "$branch" && echo "✅ 删除本地分支: $branch"
done
```

### 4. 删除远程分支

```bash
# 列出远程分支（除main外）
REMOTE_BRANCHES=$(git branch -r | grep -v "main" | grep -v "HEAD" | sed 's/origin\///' | xargs)

# 逐个删除远程分支
for branch in $REMOTE_BRANCHES; do
  git push origin --delete "$branch" && echo "✅ 删除远程分支: $branch"
done
```

### 5. 清理引用

```bash
# 清理远程分支的本地引用
git remote prune origin

# 验证清理结果
git branch -a
```

### 6. 生成报告

显示清理结果：

```
╔═══════════════════════════════════════╗
║  分支清理报告                         ║
╚═══════════════════════════════════════╝

清理前:
  本地分支: 5个
  远程分支: 4个

已删除:
  ✅ feature/test-mcp
  ✅ test/pr-script-20260323_131752
  ✅ origin/feature/test-mcp
  ✅ origin/test/pr-script-20260323_131752

保留:
  ✅ main
  ✅ origin/main

清理后:
  本地分支: 1个 (main)
  远程分支: 1个 (origin/main)

🎉 分支清理完成！
```

## 安全检查

执行前会：
- ✅ 确认当前在main分支或可以切换到main
- ✅ 显示将要删除的分支列表
- ✅ 要求用户明确确认
- ✅ 保护main分支不被删除

## 使用示例

```
用户: /cleanup-branches

Claude:
🔍 检测到以下分支将被删除:

本地分支:
  - feature/test-mcp
  - test/pr-script-20260323_131752

远程分支:
  - origin/feature/test-mcp
  - origin/test/pr-script-20260323_131752

⚠️  警告: 此操作不可撤销！

是否确认删除以上分支？(yes/no)

用户: yes

Claude:
🧹 开始清理分支...
✅ 删除本地分支: feature/test-mcp
✅ 删除本地分支: test/pr-script-20260323_131752
✅ 删除远程分支: feature/test-mcp
✅ 删除远程分支: test/pr-script-20260323_131752
✅ 清理远程引用

🎉 清理完成！现在只保留 main 分支。
```

## 参数选项

```
/cleanup-branches --local-only    # 只清理本地分支
/cleanup-branches --remote-only   # 只清理远程分支
/cleanup-branches --dry-run       # 模拟运行，不实际删除
```

## 注意事项

- 会强制删除分支 (git branch -D)
- 未合并的分支也会被删除
- 请确保重要的工作已经合并到main
- 执行前会要求明确确认
