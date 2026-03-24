# Claude Code Skills CI/CD 集成指南

本文档介绍如何将 Claude Code 的 skills 集成到 CI/CD 流程中。

## 目录

- [方案一：GitHub Actions 集成](#方案一github-actions-集成)
- [方案二：独立脚本集成](#方案二独立脚本集成)
- [方案三：使用 Claude API](#方案三使用-claude-api)
- [最佳实践](#最佳实践)

---

## 方案一：GitHub Actions 集成

### 1.1 直接调用 Claude Code CLI

在 GitHub Actions 中安装并运行 Claude Code：

```yaml
name: Auto Cleanup Branches

on:
  schedule:
    - cron: '0 2 * * 1' # 每周一凌晨2点
  workflow_dispatch: # 支持手动触发

jobs:
  cleanup:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0 # 获取完整历史

      - name: Install Claude Code
        run: |
          npm install -g @anthropic-ai/claude-code

      - name: Run cleanup-branches skill
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          claude --non-interactive "/cleanup-branches --auto-confirm"
```

### 1.2 使用预构建的 Action

创建可复用的 GitHub Action：

**`.github/actions/claude-skill/action.yml`**

```yaml
name: 'Run Claude Code Skill'
description: 'Execute a Claude Code skill in CI/CD'
inputs:
  skill:
    description: 'Skill command to run'
    required: true
  anthropic-api-key:
    description: 'Anthropic API Key'
    required: true
  working-directory:
    description: 'Working directory'
    default: '.'

runs:
  using: 'composite'
  steps:
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '20'

    - name: Install Claude Code
      shell: bash
      run: npm install -g @anthropic-ai/claude-code

    - name: Run Claude Skill
      shell: bash
      working-directory: ${{ inputs.working-directory }}
      env:
        ANTHROPIC_API_KEY: ${{ inputs.anthropic-api-key }}
      run: claude --non-interactive "${{ inputs.skill }}"
```

使用示例：

```yaml
name: Weekly Maintenance

on:
  schedule:
    - cron: '0 2 * * 1'

jobs:
  cleanup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Cleanup branches
        uses: ./.github/actions/claude-skill
        with:
          skill: '/cleanup-branches'
          anthropic-api-key: ${{ secrets.ANTHROPIC_API_KEY }}
```

---

## 方案二：独立脚本集成

将 skill 逻辑提取为独立的 shell 脚本，适用于任何 CI/CD 平台。

### 2.1 创建独立脚本

**`scripts/cleanup-branches.sh`**

```bash
#!/bin/bash
set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🧹 开始清理分支...${NC}"

# 1. 确认在main分支
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo -e "${YELLOW}切换到main分支...${NC}"
    git checkout main
fi

# 2. 更新main分支
echo -e "${YELLOW}更新main分支...${NC}"
git pull origin main

# 3. 列出要删除的分支
LOCAL_BRANCHES=$(git branch | grep -v "main" | grep -v "\*" | sed 's/^[ \t]*//' || true)
REMOTE_BRANCHES=$(git branch -r | grep -v "main" | grep -v "HEAD" | sed 's/origin\///' | sed 's/^[ \t]*//' || true)

echo -e "\n${YELLOW}将要删除的本地分支:${NC}"
if [ -n "$LOCAL_BRANCHES" ]; then
    echo "$LOCAL_BRANCHES" | while read -r branch; do
        echo "  - $branch"
    done
else
    echo "  (无)"
fi

echo -e "\n${YELLOW}将要删除的远程分支:${NC}"
if [ -n "$REMOTE_BRANCHES" ]; then
    echo "$REMOTE_BRANCHES" | while read -r branch; do
        echo "  - $branch"
    done
else
    echo "  (无)"
fi

# 4. 删除本地分支
if [ -n "$LOCAL_BRANCHES" ]; then
    echo -e "\n${YELLOW}删除本地分支...${NC}"
    echo "$LOCAL_BRANCHES" | while read -r branch; do
        if [ -n "$branch" ]; then
            git branch -D "$branch" && echo -e "${GREEN}✅ 删除本地分支: $branch${NC}"
        fi
    done
fi

# 5. 删除远程分支
if [ -n "$REMOTE_BRANCHES" ]; then
    echo -e "\n${YELLOW}删除远程分支...${NC}"
    echo "$REMOTE_BRANCHES" | while read -r branch; do
        if [ -n "$branch" ]; then
            git push origin --delete "$branch" && echo -e "${GREEN}✅ 删除远程分支: $branch${NC}" || true
        fi
    done
fi

# 6. 清理引用
echo -e "\n${YELLOW}清理远程引用...${NC}"
git remote prune origin

# 7. 显示结果
echo -e "\n${GREEN}🎉 分支清理完成！${NC}"
echo -e "\n当前分支状态:"
git branch -a
```

### 2.2 GitHub Actions 中使用脚本

```yaml
name: Cleanup Branches

on:
  schedule:
    - cron: '0 2 * * 1'
  workflow_dispatch:

jobs:
  cleanup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Configure Git
        run: |
          git config user.name "GitHub Actions Bot"
          git config user.email "actions@github.com"

      - name: Run cleanup script
        run: |
          chmod +x scripts/cleanup-branches.sh
          ./scripts/cleanup-branches.sh
```

### 2.3 GitLab CI 集成

**`.gitlab-ci.yml`**

```yaml
cleanup-branches:
  stage: maintenance
  script:
    - git config user.name "GitLab CI"
    - git config user.email "ci@gitlab.com"
    - chmod +x scripts/cleanup-branches.sh
    - ./scripts/cleanup-branches.sh
  only:
    - schedules
  tags:
    - docker
```

### 2.4 Jenkins 集成

**`Jenkinsfile`**

```groovy
pipeline {
    agent any

    triggers {
        cron('0 2 * * 1') // 每周一凌晨2点
    }

    stages {
        stage('Cleanup Branches') {
            steps {
                script {
                    sh '''
                        git config user.name "Jenkins"
                        git config user.email "jenkins@example.com"
                        chmod +x scripts/cleanup-branches.sh
                        ./scripts/cleanup-branches.sh
                    '''
                }
            }
        }
    }
}
```

---

## 方案三：使用 Claude API

通过 Claude API 在 CI/CD 中执行智能任务。

### 3.1 使用 Anthropic SDK

**`scripts/ai-cleanup.js`**

```javascript
import Anthropic from '@anthropic-ai/sdk';
import { execSync } from 'child_process';

const client = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
});

async function analyzeAndCleanup() {
  // 获取分支信息
  const branches = execSync('git branch -a').toString();

  // 让 Claude 分析哪些分支可以安全删除
  const message = await client.messages.create({
    model: 'claude-sonnet-4-6',
    max_tokens: 2000,
    messages: [{
      role: 'user',
      content: `分析以下 Git 分支列表，识别可以安全删除的分支（已合并或长期未更新的分支）：

${branches}

请返回JSON格式的建议：
{
  "safe_to_delete": ["branch1", "branch2"],
  "keep": ["branch3"],
  "reason": "解释原因"
}`,
    }],
  });

  console.log('Claude 分析结果：');
  console.log(message.content[0].text);

  // 解析并执行清理
  const analysis = JSON.parse(message.content[0].text);

  for (const branch of analysis.safe_to_delete) {
    try {
      execSync(`git branch -D ${branch}`);
      console.log(`✅ 删除分支: ${branch}`);
    } catch (error) {
      console.error(`❌ 无法删除: ${branch}`);
    }
  }
}

analyzeAndCleanup().catch(console.error);
```

**GitHub Actions 配置：**

```yaml
name: AI-Powered Cleanup

on:
  schedule:
    - cron: '0 2 * * 1'

jobs:
  ai-cleanup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm install @anthropic-ai/sdk

      - name: Run AI cleanup
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: node scripts/ai-cleanup.js
```

---

## 最佳实践

### 1. 安全性

```yaml
# ✅ 使用 Secrets 存储敏感信息
env:
  ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}

# ✅ 限制权限
permissions:
  contents: write
  pull-requests: write

# ✅ 使用保护分支
# 在仓库设置中配置 branch protection rules
```

### 2. 错误处理

```yaml
- name: Cleanup with error handling
  continue-on-error: true
  run: |
    ./scripts/cleanup-branches.sh || {
      echo "Cleanup failed, sending notification..."
      # 发送通知逻辑
    }
```

### 3. 通知集成

```yaml
- name: Notify on Slack
  if: failure()
  uses: slackapi/slack-github-action@v1
  with:
    payload: |
      {
        "text": "Branch cleanup failed in ${{ github.repository }}"
      }
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
```

### 4. 日志和审计

```yaml
- name: Upload logs
  if: always()
  uses: actions/upload-artifact@v4
  with:
    name: cleanup-logs
    path: logs/
    retention-days: 30
```

### 5. 测试模式

```yaml
- name: Dry run mode
  if: github.event_name == 'pull_request'
  run: |
    # 只显示将要删除的分支，不实际执行
    git branch -a | grep -v "main"
```

---

## 完整示例：生产级配置

```yaml
name: Weekly Branch Maintenance

on:
  schedule:
    - cron: '0 2 * * 1' # 每周一凌晨2点
  workflow_dispatch:
    inputs:
      dry_run:
        description: 'Dry run mode (no actual deletion)'
        required: false
        default: 'false'

permissions:
  contents: write

jobs:
  cleanup:
    runs-on: ubuntu-latest
    timeout-minutes: 15

    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Configure Git
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"

      - name: Analyze branches
        id: analyze
        run: |
          LOCAL_COUNT=$(git branch | grep -v "main" | wc -l)
          REMOTE_COUNT=$(git branch -r | grep -v "main" | grep -v "HEAD" | wc -l)
          echo "local_count=$LOCAL_COUNT" >> $GITHUB_OUTPUT
          echo "remote_count=$REMOTE_COUNT" >> $GITHUB_OUTPUT

      - name: Run cleanup script
        if: steps.analyze.outputs.local_count > 0 || steps.analyze.outputs.remote_count > 0
        run: |
          chmod +x scripts/cleanup-branches.sh
          if [ "${{ github.event.inputs.dry_run }}" == "true" ]; then
            echo "🔍 Dry run mode - no branches will be deleted"
            git branch | grep -v "main"
          else
            ./scripts/cleanup-branches.sh
          fi

      - name: Create summary
        if: always()
        run: |
          echo "### 🧹 Branch Cleanup Summary" >> $GITHUB_STEP_SUMMARY
          echo "" >> $GITHUB_STEP_SUMMARY
          echo "- Local branches cleaned: ${{ steps.analyze.outputs.local_count }}" >> $GITHUB_STEP_SUMMARY
          echo "- Remote branches cleaned: ${{ steps.analyze.outputs.remote_count }}" >> $GITHUB_STEP_SUMMARY
          echo "- Status: ${{ job.status }}" >> $GITHUB_STEP_SUMMARY

      - name: Notify on failure
        if: failure()
        uses: actions/github-script@v7
        with:
          script: |
            github.rest.issues.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              title: '⚠️ Branch cleanup failed',
              body: 'The weekly branch cleanup job failed. Please check the workflow logs.',
              labels: ['maintenance', 'ci']
            })
```

---

## 相关资源

- [Claude Code 官方文档](https://docs.anthropic.com/claude-code)
- [GitHub Actions 文档](https://docs.github.com/actions)
- [Anthropic API 文档](https://docs.anthropic.com/api)

## 问题排查

### 问题：Permission denied

**解决方案：**
```yaml
- name: Fix permissions
  run: chmod +x scripts/*.sh
```

### 问题：Git authentication failed

**解决方案：**
```yaml
- uses: actions/checkout@v4
  with:
    token: ${{ secrets.PAT_TOKEN }} # 使用 Personal Access Token
```

### 问题：API rate limiting

**解决方案：**
```yaml
- name: Rate limiting handling
  run: |
    sleep 5 # 在操作间添加延迟
```
