# Claude Code 学习与实践项目

<div align="center">

**完整的 Claude Code 组件库 + 详细的学习文档**

**A Complete Claude Code Component Library with Detailed Learning Documentation**

[![Skills](https://img.shields.io/badge/Skills-23-blue)](./skills/)
[![Agents](https://img.shields.io/badge/Agents-119-green)](./agents/)
[![Hooks](https://img.shields.io/badge/Hooks-2-orange)](./hooks/)

[简体中文](#简体中文) | [English](#english)

</div>

---

## 简体中文

### 📚 项目简介

这是一个用于学习和实践 Claude Code 的完整项目，整合了来自 5 个优质开源仓库的最佳组件，包含详细的中英文文档和使用指南。

### 🎯 项目特点

- **🔧 实用组件**: 23 个 Skills + 119 个 Agents + 2 个 Hooks
- **📖 双语文档**: 每个组件都有中英文讲解
- **⭐ 精选内容**: 从 5 个优质仓库中挑选的最佳实践
- **🎓 学习导向**: 详细的用途说明、工作原理和使用示例

### 📂 项目结构

```
.claude/
├── README.md                       # 本文件
├── INTEGRATION_COMPLETE.md         # 整合完成报告
├── INTEGRATION_PLAN.md             # 整合计划
│
├── skills/                         # 23 个 Skills
│   ├── [你的工具] (5个)
│   │   ├── cleanup-branches/        # 分支清理
│   │   ├── cleanup-files/           # 文件清理
│   │   ├── merge/                   # PR 合并
│   │   ├── push-test-merge/         # CI/CD 自动化
│   │   └── test/                    # 自动化测试
│   │
│   ├── [Superpowers] (9个)          # TDD 核心工作流
│   │   ├── brainstorming/           # 设计优先
│   │   ├── test-driven-development/ # TDD 纪律
│   │   ├── systematic-debugging/    # 系统调试
│   │   ├── subagent-driven-development/
│   │   ├── verification-before-completion/
│   │   ├── writing-plans/
│   │   ├── using-git-worktrees/
│   │   ├── receiving-code-review/
│   │   └── writing-skills/
│   │
│   └── [Claude-Code-Settings] (8个) # 企业级工具
│       ├── kiro-skill/              # 功能开发
│       ├── spec-kit-skill/          # 规格驱动
│       ├── autonomous-skill/        # 长时任务
│       ├── deep-research/           # 深度调研
│       ├── github-review-pr/        # PR 审查
│       ├── codex-skill/             # Codex 集成
│       ├── skill-creator/           # 技能创建
│       └── reflection/              # 会话反思
│
├── agents/                         # 119 个 Agents
│   ├── [原有Agents] (~92个)         # 已有的专家
│   │
│   ├── [新增精选] (27个)
│   │   ├── 语言专家 (4个)
│   │   │   ├── python-pro.md
│   │   │   ├── typescript-pro.md
│   │   │   ├── rust-engineer.md
│   │   │   └── golang-pro.md
│   │   │
│   │   ├── 框架专家 (1个)
│   │   │   └── react-specialist.md
│   │   │
│   │   ├── 基础设施 (4个)
│   │   │   ├── kubernetes-specialist.md
│   │   │   ├── devops-engineer.md
│   │   │   ├── docker-expert.md
│   │   │   └── terraform-engineer.md
│   │   │
│   │   ├── AI/数据 (3个)
│   │   │   ├── llm-architect.md
│   │   │   ├── prompt-engineer.md
│   │   │   └── data-scientist.md
│   │   │
│   │   ├── 质量/安全 (2个)
│   │   │   ├── security-auditor.md
│   │   │   └── code-reviewer.md
│   │   │
│   │   ├── 开发体验 (3个)
│   │   │   ├── api-designer.md
│   │   │   ├── refactoring-specialist.md
│   │   │   └── mcp-developer.md
│   │   │
│   │   ├── 元编程 (3个)
│   │   │   ├── multi-agent-coordinator.md
│   │   │   ├── agent-installer.md
│   │   │   └── fullstack-developer.md
│   │   │
│   │   └── GitHub 专家 (7个)
│   │       ├── pr-reviewer.md
│   │       ├── github-issue-fixer.md
│   │       ├── instruction-reflector.md
│   │       ├── deep-reflector.md
│   │       ├── insight-documenter.md
│   │       ├── ui-engineer.md
│   │       └── command-creator.md
│
├── hooks/                          # 2 个 Hooks
│   ├── session-start               # 会话启动
│   └── stop-hook                   # 会话结束
│
├── skills-docs/                    # Skills 文档
├── agents-docs/                    # Agents 文档
└── hooks-docs/                     # Hooks 文档
```

### 🚀 快速开始

#### 1. 查看整合报告
```bash
cat .claude/INTEGRATION_COMPLETE.md
```

#### 2. 浏览 Skills
```bash
# 查看所有 skills
ls .claude/skills/

# 查看某个 skill 的文档
cat .claude/skills/brainstorming/SKILL.md
```

#### 3. 浏览 Agents
```bash
# 查看所有 agents
ls .claude/agents/

# 查看某个 agent
cat .claude/agents/python-pro.md
```

#### 4. 查看 Hooks
```bash
cat .claude/hooks/session-start
```

### 📖 组件分类指南

#### Skills 使用场景

| 分类 | Skills | 使用时机 |
|------|--------|---------|
| **项目管理** | cleanup-branches, cleanup-files, merge, push-test-merge, test | 日常开发维护 |
| **开发方法论** | brainstorming, test-driven-development, systematic-debugging | 开始任何开发工作前 |
| **工作流编排** | subagent-driven-development, writing-plans, using-git-worktrees | 复杂任务规划 |
| **质量保证** | verification-before-completion, receiving-code-review | 代码审查和验证 |
| **企业级开发** | kiro-skill, spec-kit-skill, autonomous-skill | 正式项目开发 |
| **研究分析** | deep-research, reflection | 技术调研和总结 |
| **AI 协作** | codex-skill, github-review-pr, skill-creator | AI 辅助开发 |

#### Agents 能力矩阵

| 领域 | Agent 示例 | 专长 |
|------|-----------|------|
| **编程语言** | python-pro, typescript-pro, rust-engineer, golang-pro | 特定语言深度开发 |
| **前端框架** | react-specialist | UI 组件和状态管理 |
| **基础设施** | kubernetes-specialist, devops-engineer, docker-expert, terraform-engineer | 云原生和 DevOps |
| **AI/ML** | llm-architect, prompt-engineer, data-scientist | AI 系统和数据分析 |
| **质量安全** | security-auditor, code-reviewer | 审计和代码审查 |
| **架构设计** | api-designer, refactoring-specialist, fullstack-developer | 系统架构和重构 |
| **元工具** | multi-agent-coordinator, agent-installer, mcp-developer | Agent 管理和扩展 |
| **GitHub 集成** | pr-reviewer, github-issue-fixer, insight-documenter | PR 和 Issue 自动化 |

#### Hooks 触发时机

| Hook | 触发时机 | 用途 |
|------|---------|------|
| **session-start** | 会话启动时 | 自动注入必要的 skills |
| **stop-hook** | 会话结束时 | 清理后台任务 |

### 📚 学习路径

#### 🎓 初学者路径（第1-2周）

```
Day 1-3: 基础工具
  └─ cleanup-branches, cleanup-files, test
  └─ 学习基本的项目管理自动化

Day 4-7: 开发方法论
  └─ brainstorming → writing-plans → test-driven-development
  └─ 理解设计优先和 TDD 工作流

Day 8-14: 质量保证
  └─ verification-before-completion, systematic-debugging
  └─ 掌握代码质量控制
```

#### 🚀 进阶路径（第3-4周）

```
Week 3: 子代理和工作流
  └─ subagent-driven-development, using-git-worktrees
  └─ 学习复杂任务的分解和隔离

Week 4: 企业级工具
  └─ kiro-skill, spec-kit-skill, autonomous-skill
  └─ 掌握正式项目开发流程
```

#### ⭐ 专家路径（第5+周）

```
Week 5+: AI 协作与优化
  └─ codex-skill, deep-research, reflection
  └─ Agents: python-pro, kubernetes-specialist, llm-architect
  └─ 多 Agent 协作：multi-agent-coordinator
  └─ 创建自定义工具：writing-skills, skill-creator
```

### 🌟 推荐组合

#### 组合 1: 日常开发套装
```
brainstorming → writing-plans → test-driven-development → verification-before-completion
+ python-pro / typescript-pro (语言专家)
```

#### 组合 2: 企业项目套装
```
kiro-skill / spec-kit-skill → autonomous-skill → github-review-pr
+ fullstack-developer + code-reviewer
```

#### 组合 3: 研究分析套装
```
deep-research → reflection
+ llm-architect + data-scientist
```

#### 组合 4: DevOps 自动化套装
```
push-test-merge + using-git-worktrees
+ devops-engineer + kubernetes-specialist + terraform-engineer
```

### 🔗 参考资源

本项目整合了以下优质开源项目的内容：

1. **[awesome-claude-code-subagents](https://github.com/anthropics/awesome-claude-code-subagents)**
   - 144 个专业 Agent
   - 完整的能力矩阵和最佳实践

2. **[Superpowers](https://github.com/superpowered-ai/superpowers)**
   - TDD 核心工作流
   - 严格的开发纪律

3. **[claude-code-settings](https://github.com/example/claude-code-settings)**
   - 企业级 Skills 和配置
   - 多模型集成

4. **[claude-code-best-practice](https://github.com/example/claude-code-best-practice)**
   - 最佳实践文档
   - Agent Teams 架构

5. **[Claude-Command-Suite](https://github.com/example/Claude-Command-Suite)**
   - 216 个 Commands
   - 完整的命令系统

### 📝 文档说明

- **INTEGRATION_COMPLETE.md**: 整合完成报告，包含所有组件清单
- **INTEGRATION_PLAN.md**: 原始整合计划
- **skills-docs/**: Skills 详细文档（中英文）
- **agents-docs/**: Agents 详细文档（中英文）
- **hooks-docs/**: Hooks 详细文档（中英文）

### 🤝 贡献

欢迎提交 Issue 和 Pull Request！

### 📄 许可证

MIT License

---

## English

### 📚 Project Overview

This is a comprehensive project for learning and practicing Claude Code, integrating the best components from 5 quality open-source repositories, with detailed bilingual documentation and usage guides.

### 🎯 Features

- **🔧 Practical Components**: 23 Skills + 119 Agents + 2 Hooks
- **📖 Bilingual Docs**: Chinese & English documentation for each component
- **⭐ Curated Content**: Best practices from 5 quality repositories
- **🎓 Learning-Oriented**: Detailed usage, principles, and examples

### 🚀 Quick Start

See Chinese section above for detailed quick start guide.

### 📖 Component Classification

See Chinese section above for complete classification tables.

### 📚 Learning Path

See Chinese section above for beginner, intermediate, and expert learning paths.

### 🌟 Recommended Combinations

See Chinese section above for recommended skill and agent combinations.

### 🔗 References

See Chinese section above for source repositories.

### 📝 License

MIT License

---

**Made with ❤️ for Claude Code learners**
