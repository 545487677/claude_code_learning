# 📚 文档中心

本目录包含 Claude Code Learning 项目的所有文档。

## 📁 目录结构

```
docs/
├── cicd/           # CI/CD 集成文档
│   ├── INTEGRATION.md    # 完整集成指南
│   └── QUICK_START.md    # 快速开始
└── mcp/            # MCP (Model Context Protocol) 学习文档
    ├── README.md               # MCP 概述
    ├── github_mcp.md           # GitHub MCP 使用
    ├── claude_integration_guide.md  # Claude 集成指南
    ├── pr_issue_management.md  # PR/Issue 管理
    ├── skills_guide.md         # Skills 开发指南
    └── session_summary.md      # 学习会话总结
```

## 🚀 快速导航

### CI/CD 集成
- **新手入门**: [快速开始指南](cicd/QUICK_START.md)
- **完整文档**: [CI/CD 集成指南](cicd/INTEGRATION.md)

### MCP 学习
- **开始学习**: [MCP 学习概述](mcp/README.md)
- **GitHub 集成**: [GitHub MCP 使用指南](mcp/github_mcp.md)
- **Skills 开发**: [自定义 Skills 指南](mcp/skills_guide.md)

## 📖 推荐阅读顺序

### 初学者路径
1. [MCP 学习概述](mcp/README.md) - 了解 MCP 基础概念
2. [快速开始 CI/CD](cicd/QUICK_START.md) - 5分钟配置自动化
3. [Skills 开发指南](mcp/skills_guide.md) - 创建自己的技能

### 进阶路径
1. [完整 CI/CD 集成](cicd/INTEGRATION.md) - 所有平台的集成方案
2. [GitHub MCP 深度使用](mcp/github_mcp.md) - PR/Issue 自动化
3. [Claude 集成最佳实践](mcp/claude_integration_guide.md)

## 🛠️ 实践资源

- **Skills 库**: `../.claude/skills/` - 查看已实现的 skills
- **脚本库**: `../scripts/` - 独立的自动化脚本
- **CI/CD 配置**: `../.github/workflows/` - 实际的工作流配置

## 💡 贡献文档

欢迎改进文档！文档组织原则：

1. **cicd/** - CI/CD、自动化、DevOps 相关
2. **mcp/** - MCP、Claude Code、AI 集成相关
3. 保持文档简洁、实用、有代码示例

## 📝 文档规范

- 使用 Markdown 格式
- 包含代码示例和实际用例
- 提供目录和导航链接
- 中英文混合时注意格式

---

**最后更新**: 2026-03-24
**维护者**: Claude Code Learning Project
