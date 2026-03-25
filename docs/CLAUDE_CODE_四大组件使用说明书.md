# Claude Code 四大组件使用说明书

<div align="center">

**Agents · Skills · Commands · Hooks**

**完整工作流编排指南**

⭐⭐⭐⭐⭐ 必读文档

</div>

---

## 📖 总览

Claude Code 提供了 **4 个核心组件**，它们各司其职又相互配合，构成了完整的 AI 辅助开发生态：

| 组件 | 数量 | 类型 | 触发方式 | 主要用途 |
|------|------|------|----------|----------|
| **Agents** | 100+ | 专业助手 | 自动/手动 | 特定领域的专业开发 |
| **Skills** | 20+ | 工作流 | 关键词/命令 | 复杂多步骤任务编排 |
| **Commands** | 150+ | 指令 | `/命名空间:指令` | 快速执行特定操作 |
| **Hooks** | 20+ | 自动化 | 事件触发 | 自动化流程控制 |

## 🎯 四大组件详解

### 1. Agents - 专业领域助手

**定义**: 专门化的 AI 助手，每个 Agent 精通特定领域或技术栈。

**特点**:
- ✅ 专业知识深度
- ✅ 特定技术栈优化
- ✅ 可独立工作
- ✅ 可多 Agent 协作

**存储位置**: `.claude/agents/`

**使用场景**:

#### 场景 1: 单 Agent 专业开发
```
你: "使用 typescript-pro agent 创建一个类型安全的 React Hook"

系统:
  ↓
typescript-pro Agent 启动
  ↓
生成完整的类型定义 + React Hook 代码
```

#### 场景 2: 多 Agent 协作
```
你: "构建一个全栈应用"

系统编排:
  ↓
backend-developer → 设计 API
  ↓
frontend-developer → 构建 UI
  ↓
devops-engineer → 配置部署
```

**Agent 分类**:

| 类别 | 数量 | 典型 Agents | 用途 |
|------|------|-------------|------|
| **编程语言** | 20+ | python-pro, typescript-pro, golang-pro, rust-engineer | 特定语言开发 |
| **前后端** | 15+ | react-specialist, backend-developer, fullstack-developer | Web 开发 |
| **AI/ML** | 10+ | ml-engineer, data-scientist, llm-architect, nlp-engineer | 算法研究 |
| **DevOps** | 20+ | devops-engineer, kubernetes-specialist, docker-expert | 部署运维 |
| **专业领域** | 30+ | security-engineer, database-administrator, api-designer | 专业任务 |

**触发方式**:
```bash
# 方式 1: 直接提及
"使用 python-pro agent 优化这段代码"

# 方式 2: Agent 工具（多 Agent）
# 系统会自动调用合适的 Agent

# 方式 3: 明确指定
"@python-pro 帮我重构这个函数"
```

---

### 2. Skills - 复杂工作流

**定义**: 多步骤、可复用的工作流模板，通常涉及多个操作和决策点。

**特点**:
- ✅ 多步骤编排
- ✅ 可调用 Agents
- ✅ 包含决策逻辑
- ✅ 支持用户交互

**存储位置**: `.claude/skills/`

**使用场景**:

#### 场景 1: 学术研究
```
你: "深度调研 Transformer 最新进展"

deep-research Skill:
  ↓
1. 任务分解
   - 文献综述 → research-analyst
   - 技术对比 → llm-architect
   - 应用统计 → data-scientist
  ↓
2. 并行执行（3 个 Agents 同时工作）
  ↓
3. 结果整合
  ↓
4. 生成综合报告
```

#### 场景 2: 完整 CI/CD
```
你: "/push-test-merge"

push-test-merge Skill:
  ↓
1. 代码检查 (lint, format)
  ↓
2. 推送代码 (git push)
  ↓
3. 运行测试 (test skill)
  ↓
4. 创建 PR
  ↓
5. 等待通过
  ↓
6. 自动合并
```

#### 场景 3: 论文分析
```
你: "分析这篇论文 @paper.pdf"

paper-analysis Skill:
  ↓
1. 提取论文结构
  ↓
2. 6 维度分析
   - Task, Challenge, Insight
   - Flaw, Motivation, Formula
  ↓
3. 保存分析结果
  ↓
4. 生成研究笔记
```

**Skills 分类**:

| 类别 | Skills | 用途 |
|------|--------|------|
| **研究类** | paper-analysis, deep-research, brainstorming | 学术研究工作流 |
| **开发类** | test, systematic-debugging, test-driven-development | 开发辅助 |
| **工程类** | push-test-merge, cleanup-branches, merge | CI/CD 流程 |
| **协作类** | github-review-pr, receiving-code-review, reflection | 团队协作 |

**触发方式**:
```bash
# 方式 1: 关键词触发
"深度调研 XXX"  → deep-research
"分析这篇论文"  → paper-analysis
"运行测试"     → test

# 方式 2: Skill 工具
/paper-analysis
/test
/deep-research

# 方式 3: 明确调用
"使用 deep-research skill 调研..."
```

---

### 3. Commands - 快速指令

**定义**: 命名空间组织的快速指令，执行特定的单一操作。

**特点**:
- ✅ 单一职责
- ✅ 快速执行
- ✅ 命名空间组织
- ✅ 参数化

**存储位置**: `.claude/commands/`

**命名空间组织**:

```
/命名空间:指令名

例如:
/dev:code-review       → 代码审查
/test:write-tests      → 生成测试
/deploy:prepare-release → 准备发布
/setup:setup-linting   → 配置 Linter
```

**使用场景**:

#### 场景 1: 开发工作流
```
/dev:code-review          # 代码审查
/dev:explain-code         # 解释代码
/dev:refactor-code        # 重构
/dev:debug-error          # 调试错误
/dev:clean-branches       # 清理分支
```

#### 场景 2: 测试工作流
```
/test:write-tests         # 生成测试
/test:test-coverage       # 覆盖率分析
/test:e2e-setup          # E2E 测试配置
/test:setup-load-testing  # 负载测试
```

#### 场景 3: 部署工作流
```
/deploy:prepare-release   # 准备发布
/deploy:add-changelog     # 添加更新日志
/deploy:containerize-application # 容器化
```

#### 场景 4: 性能优化
```
/performance:performance-audit  # 性能审计
/performance:optimize-bundle-size # 优化包大小
/performance:add-performance-monitoring # 添加监控
```

**命名空间列表**:

| 命名空间 | 指令数 | 主要用途 |
|----------|--------|----------|
| **dev:** | 20+ | 开发辅助 |
| **test:** | 10+ | 测试相关 |
| **deploy:** | 10+ | 部署发布 |
| **setup:** | 15+ | 环境配置 |
| **docs:** | 8+ | 文档生成 |
| **security:** | 5+ | 安全审计 |
| **performance:** | 8+ | 性能优化 |
| **project:** | 12+ | 项目管理 |
| **team:** | 10+ | 团队协作 |

---

### 4. Hooks - 自动化触发器

**定义**: 基于事件的自动化脚本，在特定时机自动执行。

**特点**:
- ✅ 事件驱动
- ✅ 自动执行
- ✅ 无需手动触发
- ✅ 可配置开关

**存储位置**: `.claude/hooks/`

**Hook 类型**:

#### 1. 会话 Hooks
```javascript
// session-start.js
// 触发: 每次会话开始时
用途:
  - 加载项目上下文
  - 设置工作环境
  - 显示欢迎信息
```

#### 2. 工具前置 Hooks (pre-*)
```javascript
// pre-bash-git-push-reminder.js
// 触发: git push 前
用途:
  - 检查是否运行过测试
  - 检查是否 lint
  - 提醒确认推送

// pre-bash-dev-server-block.js
// 触发: 启动开发服务器前
用途:
  - 检查端口占用
  - 检查依赖安装
```

#### 3. 工具后置 Hooks (post-*)
```javascript
// post-edit-format.js
// 触发: 编辑文件后
用途:
  - 自动格式化代码
  - 运行 Prettier

// post-edit-typecheck.js
// 触发: 编辑 TypeScript 文件后
用途:
  - 运行类型检查
  - 显示类型错误

// post-bash-pr-created.js
// 触发: 创建 PR 后
用途:
  - 通知团队
  - 添加标签
  - 分配审查者
```

#### 4. 专用 Hooks
```javascript
// mcp-health-check.js
// 触发: 定期或手动
用途:
  - 检查 MCP 服务状态
  - 诊断连接问题

// cost-tracker.js
// 触发: API 调用后
用途:
  - 追踪 API 使用成本
  - 提醒额度
```

**Hooks 配置**: `.claude/hooks.json`

```json
{
  "session-start": {
    "enabled": true,
    "script": "hooks/session-start.js"
  },
  "pre-bash": {
    "enabled": true,
    "patterns": {
      "git push": "hooks/pre-bash-git-push-reminder.js"
    }
  },
  "post-edit": {
    "enabled": true,
    "patterns": {
      "*.ts": "hooks/post-edit-typecheck.js",
      "*.{js,ts,jsx,tsx}": "hooks/post-edit-format.js"
    }
  }
}
```

---

## 🔗 组合使用策略

### 组合模式 1: Agent + Command

**场景**: 快速专业操作

```
你: "使用 python-pro agent /dev:refactor-code"

工作流:
  ↓
python-pro Agent 激活
  ↓
执行 refactor-code Command
  ↓
输出重构后的代码
```

**典型组合**:
- `typescript-pro` + `/dev:code-review` → TypeScript 代码审查
- `security-engineer` + `/security:security-audit` → 安全审计
- `devops-engineer` + `/deploy:prepare-release` → 准备发布

---

### 组合模式 2: Skill + Agents (多 Agent 编排)

**场景**: 复杂多步骤任务

```
你: "使用 deep-research skill 调研 Transformer"

工作流:
  ↓
deep-research Skill 启动
  ↓
1. research-analyst Agent → 文献综述
2. llm-architect Agent → 架构对比
3. data-scientist Agent → 数据分析
  ↓
整合结果 → 生成报告
```

**典型组合**:
- `deep-research` + (research-analyst, data-scientist, ml-engineer)
- `push-test-merge` + (devops-engineer, backend-developer)
- `github-review-pr` + (code-reviewer, security-engineer)

---

### 组合模式 3: Hook + Command

**场景**: 自动化工作流

```
配置 Hook:
  post-edit → 文件修改后
    ↓
  自动触发 /dev:code-review
    ↓
  显示代码建议
```

**典型组合**:
- `post-edit` → `/test:write-tests` (编辑后自动生成测试)
- `pre-bash (git push)` → `/test:test-coverage` (推送前检查覆盖率)
- `session-start` → `/project:project-health-check` (启动时检查项目健康)

---

### 组合模式 4: Skill + Hook

**场景**: 自动化复杂流程

```
配置 Hook:
  post-bash (PR created) → 触发
    ↓
  github-review-pr Skill
    ↓
  1. code-reviewer Agent 审查
  2. security-engineer Agent 扫描
  3. 自动评论 PR
```

**典型组合**:
- `post-bash (commit)` + `test` Skill
- `session-start` + `reflection` Skill
- `pre-bash (deploy)` + `systematic-debugging` Skill

---

### 组合模式 5: 完整工作流 (All)

**场景**: 端到端自动化

```
研究论文 → 实现 → 测试 → 部署

阶段 1: 研究
  deep-research Skill
    ↓
  research-analyst, llm-architect
    ↓
  生成研究报告

阶段 2: 实现
  Hook: session-start → 加载上下文
    ↓
  python-pro Agent + ml-engineer Agent
    ↓
  /dev:code-review 审查

阶段 3: 测试
  Hook: post-edit → 自动格式化
    ↓
  test Skill
    ↓
  /test:test-coverage 检查覆盖率

阶段 4: 部署
  Hook: pre-bash (git push) → 提醒
    ↓
  push-test-merge Skill
    ↓
  /deploy:prepare-release
    ↓
  Hook: post-bash (PR created) → 通知团队
```

---

## 📋 典型使用场景

### 场景 1: 算法研究工作流

```
┌─ 论文阅读
│  ├─ Skill: paper-analysis
│  └─ 输出: 6 维度分析
│
├─ 文献调研
│  ├─ Skill: deep-research
│  ├─ Agents: research-analyst, data-scientist
│  └─ 输出: 综述报告
│
├─ 实现开发
│  ├─ Agent: python-pro, ml-engineer
│  ├─ Hook: post-edit-format (自动格式化)
│  └─ 输出: 训练代码
│
├─ 实验管理
│  ├─ Agent: ml-engineer (W&B 集成)
│  ├─ Command: /test:write-tests
│  └─ 输出: 实验报告
│
└─ 论文写作
   ├─ Agent: research-analyst
   ├─ Command: /docs:generate-api-documentation
   └─ 输出: 论文草稿
```

### 场景 2: 前端开发工作流

```
┌─ 组件开发
│  ├─ Agent: typescript-pro, react-specialist
│  ├─ Hook: post-edit-typecheck (类型检查)
│  └─ Command: /dev:create-ui-component
│
├─ 测试编写
│  ├─ Skill: test-driven-development
│  ├─ Command: /test:write-tests
│  └─ Hook: post-edit → 自动运行测试
│
├─ 代码审查
│  ├─ Command: /dev:code-review
│  ├─ Agent: code-reviewer
│  └─ Hook: pre-bash (git push) → 提醒
│
└─ 部署发布
   ├─ Skill: push-test-merge
   ├─ Command: /deploy:prepare-release
   └─ Hook: post-bash (PR created) → 通知
```

### 场景 3: 后端 API 开发

```
┌─ API 设计
│  ├─ Agent: backend-developer, api-designer
│  └─ Command: /setup:design-rest-api
│
├─ 数据库设计
│  ├─ Agent: database-administrator
│  └─ Command: /setup:design-database-schema
│
├─ 安全审查
│  ├─ Agent: security-engineer
│  ├─ Command: /security:security-audit
│  └─ Skill: systematic-debugging
│
└─ 部署
   ├─ Agent: devops-engineer
   ├─ Command: /deploy:containerize-application
   └─ Hook: pre-bash (deploy) → 运行测试
```

### 场景 4: 机器学习项目

```
┌─ 数据分析
│  ├─ Agent: data-scientist
│  ├─ Skill: deep-research (数据调研)
│  └─ 输出: EDA 报告
│
├─ 模型训练
│  ├─ Agent: ml-engineer
│  ├─ Command: /test:write-tests (单元测试)
│  └─ Hook: post-bash (训练完成) → 记录实验
│
├─ 模型优化
│  ├─ Agent: llm-architect (LoRA 微调)
│  ├─ Agent: prompt-engineer (Prompt 优化)
│  └─ Command: /performance:performance-audit
│
└─ 部署服务
   ├─ Agent: devops-engineer
   ├─ Command: /deploy:setup-kubernetes-deployment
   └─ Skill: push-test-merge
```

---

## 🎯 快速参考

### 什么时候用 Agent?
- ✅ 需要特定领域专业知识
- ✅ 代码需要特定技术栈优化
- ✅ 需要多个专家协作
- 例: "用 typescript-pro 重构这段代码"

### 什么时候用 Skill?
- ✅ 多步骤复杂流程
- ✅ 需要决策和用户交互
- ✅ 可复用的工作流模板
- 例: "深度调研"、"完整 CI/CD 流程"

### 什么时候用 Command?
- ✅ 单一明确的操作
- ✅ 快速执行
- ✅ 参数化配置
- 例: `/dev:code-review`, `/test:write-tests`

### 什么时候用 Hook?
- ✅ 自动化重复操作
- ✅ 事件驱动的流程
- ✅ 无需手动触发
- 例: 保存后自动格式化、推送前自动测试

---

## 💡 最佳实践

### 1. 从简单到复杂

```
Level 1: 单 Command
  /dev:code-review

Level 2: Agent + Command
  typescript-pro + /dev:refactor-code

Level 3: Skill (多步骤)
  deep-research

Level 4: Skill + Agents (编排)
  deep-research + (research-analyst, data-scientist, ml-engineer)

Level 5: 完整自动化 (All)
  Hooks + Skills + Agents + Commands
```

### 2. 合理配置 Hooks

```javascript
// 推荐配置
{
  // 高频操作自动化
  "post-edit": {
    "*.{js,ts}": "format.js"  // 自动格式化
  },

  // 关键节点提醒
  "pre-bash": {
    "git push": "push-reminder.js"  // 推送前提醒
  },

  // 避免过度自动化
  // ❌ 不要在每次编辑后都运行完整测试
  // ✅ 推送前再运行完整测试
}
```

### 3. 选择合适的 Agent

```
任务特点 → Agent 选择

简单脚本 → python-pro
类型安全 → typescript-pro
ML 训练 → ml-engineer
NLP 任务 → nlp-engineer
大模型 → llm-architect
数据分析 → data-scientist
部署运维 → devops-engineer
```

### 4. Skill vs Command

```
判断标准:

多步骤? Yes → Skill, No → Command
需要交互? Yes → Skill, No → Command
调用 Agent? Yes → Skill, 可能 → Command
可复用? Both → Skill 优先

例子:
- 单次代码审查 → Command (/dev:code-review)
- 完整 PR 流程 → Skill (github-review-pr)
- 格式化代码 → Command (/dev:format)
- 调研项目 → Skill (deep-research)
```

---

## 📚 学习路径

### 第 1 周: 基础使用
- [ ] 尝试 5 个不同的 Commands
- [ ] 调用 3 个不同的 Agents
- [ ] 使用 1 个 Skill
- [ ] 查看所有可用组件: `/help`

### 第 2 周: 组合使用
- [ ] Agent + Command 组合
- [ ] 配置 1 个 Hook
- [ ] 使用多 Agent 协作的 Skill

### 第 3 周: 工作流定制
- [ ] 创建自己的 Command
- [ ] 配置完整的 Hooks 工作流
- [ ] 定制 Skill 参数

### 第 4 周: 高级应用
- [ ] 端到端自动化流程
- [ ] 多 Agent 编排
- [ ] 自定义 Agent

---

## 🔍 查找组件

### 查看所有可用组件
```bash
# 查看所有 Agents
ls .claude/agents/

# 查看所有 Skills
ls .claude/skills/

# 查看所有 Commands (按命名空间)
ls .claude/commands/

# 查看所有 Hooks
ls .claude/hooks/
```

### 使用帮助
```bash
# 总体帮助
/help

# 查看特定组件
/dev:README      # Dev 命名空间的所有命令
/test:README     # Test 命名空间的所有命令
```

---

## 📖 相关文档

- **详解文档**: `docs/agents/*-详解.md`, `docs/skills/*-详解.md`
- **学习指南**: `docs/DETAILED_DOCS_COMPLETION.md`
- **测试指南**: `docs/agents/TESTING_GUIDE.md`, `docs/skills/TESTING_GUIDE.md`
- **快速开始**: `docs/QUICK_START.md`

---

**版本**: 1.0
**更新日期**: 2024-03-25
**适用范围**: Claude Code CLI

**开始使用**: 选择一个场景，尝试相应的组合！🚀
