# CI/CD 测试指南

## 🎯 快速测试 GitHub Actions

### 方式 1: Web 界面（最简单）✅

1. 打开浏览器访问:
   ```
   https://github.com/545487677/claude_code_learning/actions
   ```

2. 点击左侧 `Weekly Branch Maintenance`

3. 点击右侧 `Run workflow` 下拉按钮

4. 选择选项:
   - Branch: `main`
   - Dry run mode: `true` （预览模式，不实际删除）

5. 点击绿色的 `Run workflow` 按钮

6. 刷新页面查看运行状态

7. 点击运行记录查看详细日志和报告

### 方式 2: 使用 API 脚本

```bash
# 1. 设置 GitHub Token（在 GitHub Settings → Developer settings → Personal access tokens 创建）
export GITHUB_TOKEN="your_token_here"

# 2. 运行测试脚本
./scripts/test-github-actions.sh trigger

# 3. 查看运行记录
./scripts/test-github-actions.sh list
```

### 方式 3: 安装 GitHub CLI

```bash
# macOS
brew install gh

# Ubuntu/Debian
sudo apt install gh

# 登录
gh auth login

# 触发工作流
gh workflow run "Weekly Branch Maintenance" -f dry_run=true

# 监控运行
gh run watch

# 查看日志
gh run view --log
```

## 📊 预期结果

工作流运行后会：

1. **分析分支** - 扫描本地和远程分支
2. **生成报告** - 在 Summary 中显示：
   - 待清理的本地分支数量
   - 待清理的远程分支数量
   - 分支列表
3. **Dry Run 模式** - 只显示，不实际删除
4. **完成状态** - 显示绿色 ✅ 表示成功

## 🔍 查看运行日志

在 Actions 页面点击运行记录后，可以看到：

- **Analyze branches** - 分支分析结果
- **Run cleanup script** - 清理过程（dry-run不会实际删除）
- **Create summary** - 最终报告
- **Summary** 标签页 - 查看格式化的报告

## 🚀 实际运行（谨慎！）

测试成功后，如果要实际删除分支：

```bash
# Web 界面: 选择 dry_run: false
# CLI: gh workflow run "Weekly Branch Maintenance" -f dry_run=false
```

⚠️ **警告**: 删除操作不可逆，建议先在测试仓库验证！

## 📅 自动运行

工作流会在每周一凌晨 2:00 (UTC) 自动运行，可以在 `.github/workflows/branch-cleanup.yml` 中修改时间：

```yaml
on:
  schedule:
    - cron: '0 2 * * 1'  # 每周一凌晨2点
```

## 🔧 故障排查

### 问题: 工作流不可见

**解决**: 确保 `.github/workflows/branch-cleanup.yml` 已推送到 main 分支

### 问题: 权限错误

**解决**: 检查仓库 Settings → Actions → General → Workflow permissions 是否允许 Read and write permissions

### 问题: API Token 无效

**解决**: 在 GitHub Settings → Developer settings → Personal access tokens 创建新 token，权限选择 `workflow`

## 📚 相关文档

- [完整集成指南](../docs/cicd/INTEGRATION.md)
- [快速开始](../docs/cicd/QUICK_START.md)
- [GitHub Actions 文档](https://docs.github.com/actions)

---

**最后更新**: 2026-03-24
