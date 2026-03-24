# Claude Code 学习测试指南

<div align="center">

**完整的组件能力总结与测试路线图**

**Complete Component Capabilities and Testing Roadmap**

📅 更新时间: 2024-03-24

</div>

---

## 📊 项目组件统计

| 类型 | 数量 | 状态 | 文档 |
|------|------|------|------|
| **Agents** | 119 | ✅ 已整合 | 1 个详解 + README |
| **Skills** | 22 | ✅ 已整合 | 8 个详解 + README |
| **Hooks** | 26 | ✅ 已配置 | 完整指南 |
| **Commands** | 26 | ✅ 已整合 | 待补充 |
| **总计** | **193** | **全部就绪** | **学习路径完善** |

---

## 🎯 Skills 能力总结（22 个）

### 你的原有 Skills（5 个）

| Skill | 功能 | 何时使用 | 测试方法 |
|-------|------|---------|---------|
| **cleanup-branches** | 清理所有分支，只保留 main | 项目结束清理时 | `/cleanup-branches` |
| **cleanup-files** | 清理临时文件、测试文件 | 项目清理时 | `/cleanup-files` |
| **merge** | 合并指定的 Pull Request | 审查通过后 | `/merge <PR号>` |
| **push-test-merge** | 自动推送、测试、PR、合并 | 完整流程自动化 | `/push-test-merge` |
| **test** | 自动检测并运行项目测试 | 验证代码时 | `/test` |

### Superpowers TDD 核心（9 个）⭐⭐⭐⭐⭐

| Skill | 功能 | 详解文档 | 推荐指数 |
|-------|------|---------|---------|
| **brainstorming** | 设计优先的头脑风暴 | ✅ 已完成 | ⭐⭐⭐⭐⭐ |
| **test-driven-development** | TDD 铁律执行 | ✅ 已完成 | ⭐⭐⭐⭐⭐ |
| **systematic-debugging** | 四阶段科学调试 | ✅ 已完成 | ⭐⭐⭐⭐⭐ |
| **verification-before-completion** | 证据优先验证 | ✅ 已完成 | ⭐⭐⭐⭐⭐ |
| **writing-plans** | 详尽实施计划编写 | ✅ 已完成 | ⭐⭐⭐⭐⭐ |
| **using-git-worktrees** | Git Worktree 管理 | ✅ 已完成 | ⭐⭐⭐⭐ |
| **receiving-code-review** | 技术严谨的审查接收 | ✅ 已完成 | ⭐⭐⭐⭐ |
| **subagent-driven-development** | 子代理驱动开发 | 待补充 | ⭐⭐⭐⭐ |
| **writing-skills** | 编写 Skills 的 TDD 方法 | 待补充 | ⭐⭐⭐ |

### Claude-Code-Settings 企业级（8 个）⭐⭐⭐⭐

| Skill | 功能 | 详解文档 | 推荐指数 |
|-------|------|---------|---------|
| **autonomous-skill** | 长时运行任务自主执行 | ✅ 已完成 | ⭐⭐⭐⭐⭐ |
| **kiro-skill** | 交互式功能开发工作流 | 待补充 | ⭐⭐⭐⭐ |
| **spec-kit-skill** | 规格驱动开发 | 待补充 | ⭐⭐⭐⭐ |
| **deep-research** | 深度调研多 Agent 编排 | 待补充 | ⭐⭐⭐⭐ |
| **github-review-pr** | GitHub PR 深度审查 | 待补充 | ⭐⭐⭐⭐ |
| **codex-skill** | OpenAI Codex 集成 | 待补充 | ⭐⭐⭐ |
| **skill-creator** | 创建和优化 Skills | 待补充 | ⭐⭐⭐ |
| **reflection** | 会话分析和学习提取 | 待补充 | ⭐⭐⭐ |

---

## 🤖 Agents 能力总结（119 个）

### 五星必选 Agents（10 个）⭐⭐⭐⭐⭐

| Agent | 专长领域 | 核心能力 | 详解文档 |
|-------|---------|---------|---------|
| **python-pro** | Python 3.11+ 开发 | 类型系统、异步、FastAPI | ✅ 已完成 |
| **typescript-pro** | TypeScript 高级开发 | 类型编程、泛型、工具类型 | 待补充 |
| **rust-engineer** | Rust 系统编程 | 所有权、生命周期、零开销 | 待补充 |
| **kubernetes-specialist** | K8s 集群管理 | 部署、配置、故障排除 | 待补充 |
| **devops-engineer** | DevOps 自动化 | CI/CD、基础设施、监控 | 待补充 |
| **llm-architect** | LLM 系统设计 | 架构、微调、RAG、推理 | 待补充 |
| **security-auditor** | 安全审计 | 漏洞扫描、合规检查 | 待补充 |
| **agent-installer** | Agent 管理 | 发现、安装、配置 Agents | 待补充 |
| **code-reviewer** | 代码审查 | 质量检查、最佳实践 | 待补充 |
| **multi-agent-coordinator** | 多 Agent 协调 | 任务分解、工作流编排 | 待补充 |

### 四星推荐 Agents（10 个）⭐⭐⭐⭐

**语言专家**：
- **golang-pro** - Go 并发编程、微服务
- **csharp-developer** - C# .NET Core、ASP.NET
- **java-architect** - Java 企业架构、Spring Boot

**前端专家**：
- **react-specialist** - React 18+、性能优化
- **frontend-developer** - 多框架全栈前端
- **angular-architect** - Angular 15+、企业应用

**基础设施**：
- **docker-expert** - Docker 容器化、镜像优化
- **terraform-engineer** - IaC、多云部署
- **platform-engineer** - 内部开发者平台

**数据 & AI**：
- **data-scientist** - 数据分析、预测建模
- **ai-engineer** - AI 系统端到端实现
- **ml-engineer** - ML 模型生产部署

### GitHub 专家（7 个）⭐⭐⭐⭐

| Agent | 功能 |
|-------|------|
| **pr-reviewer** | Pull Request 审查 |
| **github-issue-fixer** | GitHub Issue 自动修复 |
| **instruction-reflector** | 指令反思和优化 |
| **deep-reflector** | 深度反思分析 |
| **insight-documenter** | 洞察文档化 |
| **ui-engineer** | UI 工程实现 |
| **command-creator** | 命令创建器 |

### 完整分类（按领域）

#### 🌐 Web & API 开发（15 个）
- api-designer, api-documenter, backend-developer, fastapi-developer
- fullstack-developer, nextjs-developer, rails-expert
- django-developer, laravel-specialist, wordpress-master
- php-pro, graphql-architect, websocket-engineer
- electron-pro, expo-react-native-expert

#### 📱 移动开发（4 个）
- mobile-developer, mobile-app-developer, flutter-expert, swift-expert

#### 🏗️ 基础设施 & DevOps（12 个）
- cloud-architect, devops-engineer, sre-engineer, platform-engineer
- kubernetes-specialist, docker-expert, terraform-engineer
- azure-infra-engineer, network-engineer, deployment-engineer
- terragrunt-expert, windows-infra-admin

#### 🔒 安全 & 质量（5 个）
- security-engineer, security-auditor, incident-responder
- code-reviewer, database-optimizer

#### 🤖 AI & ML（8 个）
- ai-engineer, llm-architect, ml-engineer, mlops-engineer
- machine-learning-engineer, prompt-engineer, nlp-engineer
- reinforcement-learning-engineer

#### 📊 数据 & 分析（6 个）
- data-scientist, data-analyst, data-engineer, data-researcher
- database-administrator, postgres-pro, sql-pro

#### 💼 商业 & 产品（9 个）
- product-manager, business-analyst, project-manager
- competitive-analyst, market-researcher, trend-analyst
- customer-success-manager, sales-engineer, risk-manager

#### ✍️ 内容 & 文档（5 个）
- technical-writer, content-marketer, api-documenter
- ux-researcher, seo-specialist

#### 🔄 工作流 & 系统（10 个）
- agent-organizer, multi-agent-coordinator, workflow-orchestrator
- task-distributor, context-manager, performance-monitor
- knowledge-synthesizer, scrum-master, agent-installer
- it-ops-orchestrator

#### 🎨 设计 & UI（3 个）
- ui-designer, ui-engineer, ux-researcher

#### 🏦 金融 & 合规（4 个）
- fintech-engineer, payment-integration, quant-analyst
- legal-advisor, risk-manager

#### 🎮 专业领域（7 个）
- game-developer, blockchain-developer, iot-engineer
- embedded-systems, cpp-pro, refactoring-specialist
- mcp-developer

---

## 🔧 Hooks 能力总结（26 个）

### PreToolUse Hooks（工具执行前）- 7 个

| Hook | 功能 | 推荐度 |
|------|------|--------|
| **auto-tmux-dev.js** | 自动在 tmux 中启动 dev server | ⭐⭐⭐⭐ |
| **pre-bash-tmux-reminder.js** | 提醒长命令使用 tmux | ⭐⭐⭐ |
| **pre-bash-git-push-reminder.js** | Git push 前检查 | ⭐⭐⭐⭐⭐ |
| **pre-bash-dev-server-block.js** | 阻止非 tmux 环境 dev | ⭐⭐⭐⭐ |
| **doc-file-warning.js** | 警告非标准文档文件 | ⭐⭐⭐ |
| **suggest-compact.js** | 建议手动压缩上下文 | ⭐⭐⭐ |
| **config-protection.js** | 保护配置文件不被改 | ⭐⭐⭐⭐ |

### PostToolUse Hooks（工具执行后）- 6 个

| Hook | 功能 | 推荐度 |
|------|------|--------|
| **post-bash-pr-created.js** | PR 创建后记录 | ⭐⭐⭐⭐ |
| **post-bash-build-complete.js** | 构建完成分析 | ⭐⭐⭐ |
| **quality-gate.js** | 质量门检查 | ⭐⭐⭐⭐ |
| **post-edit-format.js** | 自动格式化（Prettier/Biome）| ⭐⭐⭐⭐⭐ |
| **post-edit-typecheck.js** | TypeScript 类型检查 | ⭐⭐⭐⭐ |
| **post-edit-console-warn.js** | Console.log 警告 | ⭐⭐⭐ |

### Lifecycle Hooks（生命周期）- 7 个

| Hook | 功能 | 推荐度 |
|------|------|--------|
| **session-start.js** | 会话启动，加载上下文 | ⭐⭐⭐⭐⭐ |
| **session-end.js** | 保存会话状态 | ⭐⭐⭐⭐⭐ |
| **session-end-marker.js** | 会话结束标记 | ⭐⭐⭐ |
| **pre-compact.js** | 压缩前保存状态 | ⭐⭐⭐⭐ |
| **check-console-log.js** | 检查 console.log | ⭐⭐⭐⭐ |
| **evaluate-session.js** | 提取学习模式 | ⭐⭐⭐ |
| **cost-tracker.js** | 追踪 token 成本 | ⭐⭐⭐⭐ |

### Utilities（工具）- 6 个

辅助脚本：run-with-flags.js, check-hook-enabled.js, governance-capture.js 等

---

## 📚 学习测试路线图

### 第 1 周：基础 Skills（必学）

#### Day 1-2: TDD 核心

```bash
# 1. 学习 test-driven-development
cat .claude/skills-docs/test-driven-development-详解.md

# 2. 实践：写一个简单函数
# - 先写测试
# - 运行测试（RED）
# - 写实现（GREEN）
# - 重构（REFACTOR）

# 3. 测试 skill
/test-driven-development
```

#### Day 3-4: 设计和计划

```bash
# 1. 学习 brainstorming
cat .claude/skills-docs/brainstorming-详解.md

# 2. 学习 writing-plans
cat .claude/skills-docs/writing-plans-详解.md

# 3. 实践工作流：
# brainstorming → writing-plans → test-driven-development
```

#### Day 5-6: 验证和调试

```bash
# 1. 学习 verification-before-completion
cat .claude/skills-docs/verification-before-completion-详解.md

# 2. 学习 systematic-debugging
cat .claude/skills-docs/systematic-debugging-详解.md

# 3. 实践：修复一个 bug
# - 使用 systematic-debugging 找根因
# - 用 TDD 写测试
# - 用 verification 确认修复
```

#### Day 7: 工作空间管理

```bash
# 1. 学习 using-git-worktrees
cat .claude/skills-docs/using-git-worktrees-详解.md

# 2. 创建一个 worktree 测试
git worktree add .worktrees/test-feature -b test/feature
```

### 第 2 周：核心 Agents

#### Day 1-3: Python 开发（如果用 Python）

```bash
# 1. 学习 python-pro agent
cat .claude/agents-docs/python-pro-详解.md

# 2. 让 Claude 使用 python-pro
"请使用 python-pro agent 帮我优化这个 Python 函数"

# 3. 观察 agent 如何：
# - 添加类型注解
# - 优化性能
# - 遵循最佳实践
```

#### Day 4-5: 代码审查

```bash
# 1. 学习 receiving-code-review
cat .claude/skills-docs/receiving-code-review-详解.md

# 2. 学习 code-reviewer agent
cat .claude/agents/code-reviewer.md

# 3. 实践：
# - 提交代码给 Claude 审查
# - 使用 receiving-code-review skill 处理反馈
```

#### Day 6-7: 多 Agent 协作

```bash
# 1. 学习 multi-agent-coordinator
cat .claude/agents/multi-agent-coordinator.md

# 2. 尝试复杂任务：
# "请协调多个 agents 完成这个全栈功能"
```

### 第 3 周：企业级 Skills

#### Day 1-2: 长时任务

```bash
# 1. 学习 autonomous-skill
cat .claude/skills-docs/autonomous-skill-详解.md

# 2. 尝试后台任务：
# "使用 autonomous-skill 批量处理这些文件"
```

#### Day 3-4: 深度调研

```bash
# 1. 学习 deep-research
cat .claude/skills/deep-research/SKILL.md

# 2. 实践：
# "使用 deep-research 调研最佳的 Python Web 框架"
```

#### Day 5-7: PR 审查和工作流

```bash
# 1. 学习 github-review-pr
cat .claude/skills/github-review-pr/SKILL.md

# 2. 学习 kiro-skill 和 spec-kit-skill
# 3. 实践完整的功能开发流程
```

### 第 4 周：Hooks 和自动化

#### Day 1-2: 配置 Hooks

```bash
# 1. 阅读 Hooks 指南
cat .claude/hooks/INSTALL.md

# 2. 运行配置脚本
./.claude/hooks/configure.sh

# 3. 选择 "标准配置"

# 4. 测试 hooks
echo '{}' | node .claude/hooks/session-start.js
```

#### Day 3-5: 测试各类 Hooks

```bash
# PreToolUse: 尝试 git push，看提醒
git add .
git commit -m "test"
git push  # 应该看到提醒

# PostToolUse: 编辑文件，看自动格式化
# 编辑一个 .js 文件 → 保存 → 观察 Prettier

# Lifecycle: 观察会话开始和结束
# 启动 Claude → 看 session-start
# 工作一会 → 退出 → 看 session-end
```

#### Day 6-7: 自定义 Hooks

```bash
# 1. 参考 README 创建自己的 hook
cat .claude/hooks/README.md

# 2. 创建一个简单的 hook
# 例如：提醒 commit message 长度
```

---

## 🧪 测试方法速查

### Skills 测试

```bash
# 方法 1: 斜杠命令
/brainstorming
/test-driven-development

# 方法 2: 直接对话
"请使用 brainstorming skill 帮我设计用户认证功能"

# 方法 3: 查看 skill 是否加载
# 在对话中 Claude 会提到使用了哪个 skill
```

### Agents 测试

```bash
# 方法 1: 明确指定
"请使用 python-pro agent 帮我优化这个函数"

# 方法 2: Claude 自动选择
"帮我写一个 TypeScript 类型安全的 API 客户端"
# Claude 可能自动选择 typescript-pro

# 方法 3: 查看 agent 文档
cat .claude/agents/python-pro.md
```

### Hooks 测试

```bash
# 单个 hook 测试
echo '{"tool_name":"Bash","tool_input":{"command":"git push"}}' | \
  node .claude/hooks/pre-bash-git-push-reminder.js

# 完整流程测试
# 1. 启动 Claude Code
# 2. 执行各种操作
# 3. 观察 hooks 是否触发
```

---

## 📂 文件组织结构

```
.claude/
├── README.md                          # 项目总览
├── INTEGRATION_COMPLETE.md            # 整合完成报告
├── HOOKS_SETUP_COMPLETE.md            # Hooks 配置完成
├── 整合完成报告.md                    # 中文总结
│
├── agents/                            # 119 个 Agents
│   ├── README.md                      # Agents 总览
│   ├── python-pro.md                  # 示例
│   └── ...
│
├── agents-docs/                       # Agents 详解文档（待补充）
│   └── python-pro-详解.md             # 已完成示例
│
├── skills/                            # 22 个 Skills
│   ├── README.md                      # Skills 总览
│   ├── brainstorming/                 # 示例目录
│   │   └── SKILL.md
│   └── ...
│
├── skills-docs/                       # Skills 详解文档
│   ├── brainstorming-详解.md          # ✅ 已完成
│   ├── test-driven-development-详解.md # ✅ 已完成
│   ├── autonomous-skill-详解.md       # ✅ 已完成
│   ├── systematic-debugging-详解.md    # ✅ 已完成
│   ├── verification-before-completion-详解.md # ✅ 已完成
│   ├── writing-plans-详解.md          # ✅ 已完成
│   ├── using-git-worktrees-详解.md    # ✅ 已完成
│   └── receiving-code-review-详解.md   # ✅ 已完成
│
├── hooks/                             # 26 个 Hook 脚本
│   ├── README.md                      # Hooks 使用指南
│   ├── INSTALL.md                     # 安装配置详解
│   ├── configure.sh                   # 配置脚本
│   └── *.js                           # Hook 脚本
│
├── hooks.json                         # 完整配置
├── hooks-standard.json                # 标准配置
├── hooks-minimal.json                 # 最小配置
│
└── commands/                          # 26 个 Commands（待补充文档）
    └── ...
```

---

## ✅ 已完成文档清单

### Skills 详解（8/22）

- ✅ brainstorming-详解.md（15KB，200行）
- ✅ test-driven-development-详解.md
- ✅ autonomous-skill-详解.md
- ✅ systematic-debugging-详解.md
- ✅ verification-before-completion-详解.md
- ✅ writing-plans-详解.md
- ✅ using-git-worktrees-详解.md
- ✅ receiving-code-review-详解.md

### Agents 详解（1/119）

- ✅ python-pro-详解.md（12KB，180行）

### Hooks 文档（完整）

- ✅ hooks/README.md - 完整使用指南
- ✅ hooks/INSTALL.md - 安装配置详解
- ✅ HOOKS_SETUP_COMPLETE.md - 配置完成总结

---

## 📝 待补充文档（按优先级）

### 高优先级（最常用）

1. **typescript-pro** - TypeScript 开发必备
2. **subagent-driven-development** - 子代理开发模式
3. **kiro-skill** - 交互式功能开发
4. **deep-research** - 深度调研工作流

### 中优先级（重要功能）

5. **code-reviewer** - 代码审查 agent
6. **multi-agent-coordinator** - 多 agent 协调
7. **github-review-pr** - GitHub PR 审查
8. **spec-kit-skill** - 规格驱动开发

### 低优先级（特定场景）

9. 其他 agents（按需补充）
10. Commands 文档

---

## 🎓 推荐学习顺序

### 给初学者

1. 先学 **TDD 核心 5 件套**：
   - test-driven-development
   - brainstorming
   - writing-plans
   - verification-before-completion
   - systematic-debugging

2. 然后学 **Hooks 基础**：
   - 配置最小 hooks
   - 理解生命周期

3. 最后学 **Agents 应用**：
   - python-pro 或 typescript-pro（看你的语言）
   - code-reviewer

### 给有经验的开发者

1. 直接学 **企业级 Skills**：
   - autonomous-skill
   - deep-research
   - github-review-pr

2. 配置 **完整 Hooks**：
   - 质量检查
   - 自动格式化
   - 成本追踪

3. 掌握 **Agent 协作**：
   - multi-agent-coordinator
   - 多语言专家 agents

---

## 💡 使用技巧

### 查看可用组件

```bash
# 查看所有 skills
ls .claude/skills/

# 查看所有 agents
ls .claude/agents/ | head -20

# 查看已配置的 hooks
cat .claude/settings.json
```

### 快速查找

```bash
# 搜索特定功能的 agent
grep -r "Python" .claude/agents/*.md

# 搜索特定的 skill
grep -r "TDD\|测试" .claude/skills/*/SKILL.md
```

### 组合使用

```
工作流示例：
brainstorming（设计）
  → writing-plans（计划）
  → using-git-worktrees（隔离）
  → test-driven-development（实现）
  → verification-before-completion（验证）
  → receiving-code-review（审查）
```

---

## 🚀 开始学习

```bash
# 1. 查看这份指南
cat .claude/LEARNING_GUIDE.md

# 2. 选择一个 skill 开始
cat .claude/skills-docs/brainstorming-详解.md

# 3. 在 Claude Code 中测试
/brainstorming

# 4. 按学习路线图逐步学习
```

---

**祝你学习愉快！有问题随时查看文档或询问！** 🎉

**Created with ❤️ by Claude Code Integration System**
