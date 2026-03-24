# Agents 文档 / Agents Documentation

<div align="center">

**Claude Code 的 AI 代理系统**

**AI Agent System for Claude Code**

[简体中文](#简体中文) | [English](#english)

</div>

---

## 简体中文

### 什么是 Agents？

**Agents（代理）** 是 Claude Code 中独立的 AI 助手，每个 Agent 都专注于特定领域的任务。它们就像是你团队中的专家成员，拥有特定的技能和知识。

### 🎯 核心特点

- ✅ **专业化**：每个 Agent 专注于特定领域（如 Python 开发、数据分析等）
- ✅ **独立执行**：有自己的工具访问权限和工作流程
- ✅ **可配置**：可以指定使用的模型、工具集合等
- ✅ **可组合**：多个 Agents 可以协作完成复杂任务

### 📂 目录结构

```
agents/
├── README.md                      # 本文件
├── docs/                          # 详细文档
│   ├── 01-agents-basics.md        # 基础概念（必读）
│   ├── 02-agent-structure.md      # Agent 文件结构详解
│   ├── 03-agent-creation.md       # 如何创建自己的 Agent
│   └── 04-agent-testing.md        # Agent 测试指南
│
├── examples/                      # 示例 Agents
│   ├── simple-agent.md            # 简单示例
│   ├── python-expert.md           # Python 开发专家
│   └── data-analyzer.md           # 数据分析专家
│
├── tests/                         # 测试用例
│   └── test-agent-example.md      # 测试示例
│
└── [100+ agent files]             # 你已有的 agents（从其他项目复制）
```

### 🚀 快速开始

#### 1. 理解 Agent 的基本概念
```bash
cat .claude/agents/docs/01-agents-basics.md
```

#### 2. 查看一个简单的示例
```bash
cat .claude/agents/examples/simple-agent.md
```

#### 3. 学习如何创建自己的 Agent
```bash
cat .claude/agents/docs/03-agent-creation.md
```

### 📝 Agent 基本结构

一个 Agent 文件使用 **Markdown 格式**，包含两部分：

#### 1. Frontmatter (YAML 头部)
```yaml
---
name: python-pro                   # Agent 名称 (唯一标识)
description: "Python 开发专家"      # 简短描述 (用于 Agent 选择)
tools: Read, Write, Edit, Bash      # 可用工具列表
model: sonnet                       # 使用的模型 (opus/sonnet/haiku)
---
```

#### 2. Prompt (Markdown 正文)
```markdown
You are a senior Python developer...

When invoked:
1. Step one...
2. Step two...
```

### 🔧 如何使用 Agent

在 Claude Code 中，有两种方式使用 Agent：

#### 方式 1: 手动调用 (使用 Agent 工具)
```
用户: 请使用 python-pro agent 帮我优化这段代码
Claude: [调用 Agent('python-pro', '优化代码...')]
```

#### 方式 2: 自动选择
Claude 会根据任务自动选择合适的 Agent：
```
用户: 帮我写一个 Python 脚本处理 CSV 文件
Claude: [自动选择 python-pro agent]
```

### 📚 现有 Agents 说明

你的 `.claude/agents/` 目录中有 **100+ 个 Agent 文件**，这些是从 [awesome-claude-code-subagents](https://github.com/anthropics/awesome-claude-code-subagents) 项目复制的。

#### 主要分类

| 分类 | Agent 示例 | 用途 |
|------|-----------|------|
| **开发语言** | `python-pro`, `javascript-pro`, `rust-engineer` | 特定语言开发 |
| **框架专家** | `react-specialist`, `django-developer`, `nextjs-developer` | 框架开发 |
| **DevOps** | `docker-expert`, `kubernetes-specialist`, `terraform-engineer` | 基础设施 |
| **数据科学** | `data-scientist`, `ml-engineer`, `data-analyst` | 数据分析和机器学习 |
| **架构设计** | `cloud-architect`, `microservices-architect`, `api-designer` | 系统架构 |
| **协调管理** | `agent-organizer`, `multi-agent-coordinator`, `task-distributor` | Agent 团队管理 |

#### 如何查找合适的 Agent

1. **按名称搜索**
   ```bash
   ls .claude/agents/ | grep python
   ```

2. **查看 Agent 描述**
   ```bash
   head -10 .claude/agents/python-pro.md
   ```

3. **搜索特定功能**
   ```bash
   grep -l "database" .claude/agents/*.md
   ```

### 🎓 学习路径

```
第 1 步: 阅读基础概念
└─ docs/01-agents-basics.md

第 2 步: 理解 Agent 结构
└─ docs/02-agent-structure.md

第 3 步: 查看示例 Agent
└─ examples/simple-agent.md
└─ examples/python-expert.md

第 4 步: 创建自己的 Agent
└─ docs/03-agent-creation.md

第 5 步: 学习测试方法
└─ docs/04-agent-testing.md
```

### 💡 最佳实践

1. ✅ **专注单一职责**：每个 Agent 应专注于一个明确的领域
2. ✅ **清晰的描述**：description 字段要准确描述 Agent 的能力
3. ✅ **合理的工具集**：只授予 Agent 必要的工具权限
4. ✅ **详细的 Prompt**：在 Markdown 正文中提供清晰的指令
5. ✅ **包含示例**：在 Prompt 中包含使用示例

### 🔗 相关文档

- [Skills 文档](../skills/README.md) - 了解 Skills 与 Agents 的区别
- [配置指南](../docs/configuration-guide.md) - Agent 权限配置
- [最佳实践](../docs/best-practices.md) - Agent 使用最佳实践

---

## English

### What are Agents?

**Agents** are independent AI assistants in Claude Code, each focused on domain-specific tasks. They're like expert members of your team, each with specific skills and knowledge.

### 🎯 Key Features

- ✅ **Specialized**: Each Agent focuses on a specific domain (e.g., Python development, data analysis)
- ✅ **Independent**: Has its own tool access and workflows
- ✅ **Configurable**: Can specify models, toolsets, etc.
- ✅ **Composable**: Multiple Agents can collaborate on complex tasks

### 📂 Directory Structure

See Chinese section above for the complete directory tree.

### 🚀 Quick Start

#### 1. Understand Agent Basics
```bash
cat .claude/agents/docs/01-agents-basics.md
```

#### 2. Check a Simple Example
```bash
cat .claude/agents/examples/simple-agent.md
```

#### 3. Learn to Create Your Own Agent
```bash
cat .claude/agents/docs/03-agent-creation.md
```

### 📝 Basic Agent Structure

An Agent file uses **Markdown format** with two parts:

#### 1. Frontmatter (YAML Header)
```yaml
---
name: python-pro                   # Agent name (unique ID)
description: "Python expert"        # Brief description (for Agent selection)
tools: Read, Write, Edit, Bash      # Available tools
model: sonnet                       # Model to use (opus/sonnet/haiku)
---
```

#### 2. Prompt (Markdown Body)
```markdown
You are a senior Python developer...

When invoked:
1. Step one...
2. Step two...
```

### 🔧 How to Use Agents

Two ways to use Agents in Claude Code:

#### Method 1: Manual Invocation (Using Agent Tool)
```
User: Please use python-pro agent to optimize this code
Claude: [Calls Agent('python-pro', 'optimize code...')]
```

#### Method 2: Automatic Selection
Claude automatically selects the appropriate Agent:
```
User: Help me write a Python script to process CSV files
Claude: [Automatically selects python-pro agent]
```

### 📚 Existing Agents Overview

Your `.claude/agents/` directory contains **100+ Agent files** copied from [awesome-claude-code-subagents](https://github.com/anthropics/awesome-claude-code-subagents).

#### Main Categories

| Category | Agent Examples | Purpose |
|----------|---------------|---------|
| **Languages** | `python-pro`, `javascript-pro`, `rust-engineer` | Language-specific development |
| **Frameworks** | `react-specialist`, `django-developer`, `nextjs-developer` | Framework development |
| **DevOps** | `docker-expert`, `kubernetes-specialist`, `terraform-engineer` | Infrastructure |
| **Data Science** | `data-scientist`, `ml-engineer`, `data-analyst` | Data analysis and ML |
| **Architecture** | `cloud-architect`, `microservices-architect`, `api-designer` | System architecture |
| **Orchestration** | `agent-organizer`, `multi-agent-coordinator`, `task-distributor` | Agent team management |

#### Finding the Right Agent

1. **Search by Name**
   ```bash
   ls .claude/agents/ | grep python
   ```

2. **View Agent Description**
   ```bash
   head -10 .claude/agents/python-pro.md
   ```

3. **Search by Functionality**
   ```bash
   grep -l "database" .claude/agents/*.md
   ```

### 🎓 Learning Path

```
Step 1: Read Basic Concepts
└─ docs/01-agents-basics.md

Step 2: Understand Agent Structure
└─ docs/02-agent-structure.md

Step 3: Review Example Agents
└─ examples/simple-agent.md
└─ examples/python-expert.md

Step 4: Create Your Own Agent
└─ docs/03-agent-creation.md

Step 5: Learn Testing Methods
└─ docs/04-agent-testing.md
```

### 💡 Best Practices

1. ✅ **Single Responsibility**: Each Agent should focus on one clear domain
2. ✅ **Clear Description**: The description field should accurately describe Agent capabilities
3. ✅ **Reasonable Toolset**: Grant only necessary tool permissions
4. ✅ **Detailed Prompt**: Provide clear instructions in the Markdown body
5. ✅ **Include Examples**: Include usage examples in the Prompt

### 🔗 Related Documentation

- [Skills Documentation](../skills/README.md) - Understand Skills vs Agents
- [Configuration Guide](../docs/configuration-guide.md) - Agent permission configuration
- [Best Practices](../docs/best-practices.md) - Agent usage best practices
