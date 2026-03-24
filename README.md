# Claude Code Learning

这是一个 Claude Code 学习和实践项目，包含自定义 Skills、CI/CD 集成示例和最佳实践。

## 📁 项目结构

```
claude_code_learning/
├── .claude/
│   ├── skills/              # 自定义 Skills
│   │   ├── cleanup-branches/  # 分支清理 skill
│   │   ├── merge/            # PR 合并 skill
│   │   ├── push-test-merge/  # 自动化流程 skill
│   │   └── test/             # 测试运行 skill
│   ├── plugins/             # Claude Code 插件
│   └── agents/              # 自定义 agents
├── .github/
│   ├── workflows/           # GitHub Actions 工作流
│   │   └── branch-cleanup.yml  # 定时分支清理
│   └── actions/             # 可复用的 Actions
│       └── claude-skill/    # Claude Skill 执行器
├── scripts/                 # 自动化脚本
│   ├── cleanup-branches.sh  # 分支清理脚本
│   └── ai-cleanup.ts        # AI 智能清理脚本
├── docs/                    # 文档中心
│   ├── cicd/                # CI/CD 集成文档
│   │   ├── INTEGRATION.md   # 完整集成指南
│   │   └── QUICK_START.md   # 快速开始
│   ├── mcp/                 # MCP 学习文档
│   │   ├── README.md        # MCP 概述
│   │   └── ...              # 其他学习资料
│   └── README.md            # 文档索引
├── .gitlab-ci.yml          # GitLab CI 配置
├── Jenkinsfile             # Jenkins 流水线配置
└── package.json            # Node.js 依赖配置
```

## 🚀 快速开始

### 1. 使用自定义 Skills

```bash
# 运行分支清理
/cleanup-branches

# 运行测试
/test

# 合并 PR
/merge 123

# 完整流程：推送、测试、PR、合并
/push-test-merge
```

### 2. CI/CD 集成

#### GitHub Actions
项目已配置自动化工作流，每周一凌晨 2 点自动清理分支：

```bash
# 手动触发清理（预览模式）
gh workflow run branch-cleanup.yml -f dry_run=true

# 手动触发清理（实际执行）
gh workflow run branch-cleanup.yml -f dry_run=false
```

#### 使用独立脚本
```bash
# 预览将要删除的分支
npm run cleanup:preview

# 执行清理
npm run cleanup:execute

# AI 智能清理（预览）
npm run ai-cleanup

# AI 智能清理（自动执行）
npm run ai-cleanup:auto
```

## 📚 文档

详细文档请查看 [docs/README.md](docs/README.md)

**快速导航**:
- [CI/CD 快速开始](docs/cicd/QUICK_START.md) - 5分钟配置自动化
- [CI/CD 完整指南](docs/cicd/INTEGRATION.md) - 详细集成文档，包含：
  - GitHub Actions 集成
  - GitLab CI 集成
  - Jenkins 集成
  - 使用 Claude API 的智能自动化
  - 最佳实践和安全建议

## 🛠️ 技术栈

- **Claude Code CLI** - Anthropic 官方 CLI 工具
- **GitHub Actions** - CI/CD 自动化
- **TypeScript** - 智能脚本编写
- **Anthropic API** - AI 驱动的自动化

## 🔑 配置要求

### GitHub Actions
在仓库 Settings → Secrets 中配置：
- `ANTHROPIC_API_KEY` - Anthropic API 密钥（用于 AI 功能）

### 本地开发
```bash
# 安装依赖
npm install

# 配置环境变量
export ANTHROPIC_API_KEY="your-api-key"
```

## 📖 学习资源

- [MCP 学习文档](docs/mcp/) - MCP 协议和 GitHub 集成
- [Skills 开发指南](docs/mcp/skills_guide.md) - 自定义 Skills
- [学习会话总结](docs/mcp/session_summary.md) - 学习笔记

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📝 许可证

MIT License