# CI/CD 集成快速开始

本指南帮助你快速开始使用 Claude Code 的 CI/CD 集成功能。

## 🎯 选择适合你的方案

根据你的需求选择合适的集成方案：

| 场景 | 推荐方案 | 文件位置 |
|------|---------|----------|
| 使用 GitHub 且想要最简单的集成 | GitHub Actions | `.github/workflows/branch-cleanup.yml` |
| 想要独立于 CI/CD 平台的脚本 | Shell 脚本 | `scripts/cleanup-branches.sh` |
| 需要 AI 智能决策 | Claude API 脚本 | `scripts/ai-cleanup.ts` |
| 使用 GitLab | GitLab CI | `.gitlab-ci.yml` |
| 使用 Jenkins | Jenkins Pipeline | `Jenkinsfile` |
| 需要可复用的 GitHub Action | 自定义 Action | `.github/actions/claude-skill/` |

## ⚡ 5 分钟快速开始

### 方案 A: GitHub Actions（推荐）

**步骤 1: 配置 Secrets（可选）**

如果要使用 AI 功能，在仓库设置中添加：
- Settings → Secrets and variables → Actions → New repository secret
- 名称：`ANTHROPIC_API_KEY`
- 值：你的 Anthropic API 密钥

**步骤 2: 启用工作流**

工作流已经配置好了！会在每周一凌晨 2 点自动运行。

**步骤 3: 手动测试（可选）**

```bash
# 安装 GitHub CLI（如果还没有）
# macOS: brew install gh
# Linux: 参考 https://cli.github.com/

# 登录
gh auth login

# 手动触发工作流（预览模式）
gh workflow run branch-cleanup.yml -f dry_run=true

# 查看运行结果
gh run list --workflow=branch-cleanup.yml
```

### 方案 B: 独立脚本（适用于所有平台）

**步骤 1: 确保脚本可执行**

```bash
chmod +x scripts/cleanup-branches.sh
```

**步骤 2: 预览将要删除的分支**

```bash
# 运行预览（不实际删除）
./scripts/cleanup-branches.sh --dry-run
```

**步骤 3: 执行清理**

```bash
# 实际执行删除
./scripts/cleanup-branches.sh
```

### 方案 C: AI 智能清理

**步骤 1: 安装依赖**

```bash
npm install
```

**步骤 2: 配置 API 密钥**

```bash
export ANTHROPIC_API_KEY="your-api-key-here"
```

**步骤 3: 运行 AI 分析**

```bash
# 预览模式（只分析，不删除）
npm run ai-cleanup

# 自动执行模式
npm run ai-cleanup:auto
```

## 🎨 自定义配置

### 修改清理时间表

编辑 `.github/workflows/branch-cleanup.yml`:

```yaml
on:
  schedule:
    - cron: '0 2 * * 1'  # 修改这一行
    # '分 时 日 月 周'
    # 例如：
    # '0 2 * * *'   - 每天凌晨2点
    # '0 2 * * 1-5' - 工作日凌晨2点
    # '0 */6 * * *' - 每6小时一次
```

### 修改保护规则

编辑 `scripts/cleanup-branches.sh`，修改第 18-19 行的过滤规则：

```bash
# 当前配置：只保留 main 分支
LOCAL_BRANCHES=$(git branch | grep -v "main" | grep -v "\*" | sed 's/^[ \t]*//' || true)

# 保留多个分支的示例：
LOCAL_BRANCHES=$(git branch | grep -Ev "main|develop|staging" | grep -v "\*" | sed 's/^[ \t]*//' || true)
```

### 添加通知

在 `.github/workflows/branch-cleanup.yml` 中添加 Slack 通知：

```yaml
- name: Notify on Slack
  if: always()
  uses: slackapi/slack-github-action@v1
  with:
    payload: |
      {
        "text": "分支清理完成: ${{ job.status }}",
        "blocks": [
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": "📊 *分支清理报告*\n状态: ${{ job.status }}\n本地分支: ${{ steps.analyze.outputs.local_count }}\n远程分支: ${{ steps.analyze.outputs.remote_count }}"
            }
          }
        ]
      }
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
```

## 🔍 验证和测试

### 测试 GitHub Actions 工作流

```bash
# 检查语法
gh workflow view branch-cleanup.yml

# 手动触发（dry-run 模式）
gh workflow run branch-cleanup.yml -f dry_run=true

# 等待几秒后查看结果
gh run watch

# 查看最新运行的日志
gh run view --log
```

### 测试独立脚本

```bash
# 使用 shellcheck 检查脚本（如果已安装）
shellcheck scripts/cleanup-branches.sh

# 在测试仓库中运行
cd /path/to/test/repo
/path/to/scripts/cleanup-branches.sh --dry-run
```

### 测试 AI 脚本

```bash
# TypeScript 类型检查
npx tsc --noEmit scripts/ai-cleanup.ts

# 运行预览
npm run ai-cleanup
```

## 📊 监控和日志

### GitHub Actions 日志

```bash
# 查看所有运行
gh run list --workflow=branch-cleanup.yml

# 查看特定运行的详细信息
gh run view <run-id> --log

# 下载工作流产物
gh run download <run-id>
```

### 本地脚本日志

```bash
# 将输出保存到文件
./scripts/cleanup-branches.sh 2>&1 | tee cleanup-$(date +%Y%m%d).log

# 查看历史日志
ls -lt cleanup-*.log
```

## ❓ 常见问题

### Q: 如何暂时禁用自动清理？

**A: GitHub Actions**
```bash
# 在 .github/workflows/branch-cleanup.yml 中注释掉 schedule:
# on:
#   schedule:
#     - cron: '0 2 * * 1'
```

### Q: 删除的分支可以恢复吗？

**A:** 本地分支删除后，如果有远程分支，可以重新检出：
```bash
git checkout -b <branch-name> origin/<branch-name>
```

远程分支删除后，如果有本地备份或知道 commit SHA，可以恢复：
```bash
git checkout -b <branch-name> <commit-sha>
git push origin <branch-name>
```

### Q: 如何只清理本地分支？

**A:** 修改脚本，注释掉远程分支清理部分（第 53-61 行）。

### Q: AI 清理如何决定删除哪些分支？

**A:** Claude 会分析：
- 分支最后更新时间
- 分支命名规律（test, tmp 等）
- 分支是否已合并
- 分支的活跃度

你可以在 `scripts/ai-cleanup.ts` 中自定义分析规则。

## 🚀 进阶功能

### 集成到现有工作流

在你的主工作流中调用清理 Action：

```yaml
# .github/workflows/deploy.yml
jobs:
  deploy:
    # ... 部署步骤 ...

  cleanup:
    needs: deploy
    if: success()
    uses: ./.github/workflows/branch-cleanup.yml
    with:
      dry_run: false
```

### 创建可复用的 Action

```yaml
# 在其他仓库中使用
- name: Cleanup branches
  uses: your-username/your-repo/.github/actions/claude-skill@main
  with:
    skill: '/cleanup-branches'
    anthropic-api-key: ${{ secrets.ANTHROPIC_API_KEY }}
```

### 组合多个 Skills

```yaml
- name: Run multiple maintenance tasks
  run: |
    claude --non-interactive "/cleanup-branches"
    claude --non-interactive "/test"
    # 添加更多 skills...
```

## 📚 下一步

- 阅读完整的 [CI/CD 集成文档](CICD_INTEGRATION.md)
- 探索更多 [自定义 Skills](../.claude/skills/)
- 了解 [Claude Code 最佳实践](https://docs.anthropic.com/claude-code)

## 💡 最佳实践

1. **总是先用 dry-run 模式测试**
2. **定期检查工作流日志**
3. **使用 Secrets 管理敏感信息**
4. **配置分支保护规则**
5. **设置失败通知**
6. **保留审计日志**

## 🆘 获取帮助

- 查看 [详细文档](CICD_INTEGRATION.md)
- 检查 [Issues](https://github.com/your-repo/issues)
- 阅读 [Claude Code 文档](https://docs.anthropic.com/claude-code)
