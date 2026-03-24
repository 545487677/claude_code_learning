# Claude Code Agents 能力总结与测试指南

## 📊 总览

**总计：118 个专业 Agents**

Agents 是 Claude Code 中的专业 AI 助手，每个都针对特定领域进行了优化。使用 Agent 工具可以调用这些专业助手来处理复杂任务。

---

## 🌟 五星必选 Agents（10 个）⭐⭐⭐⭐⭐

这些是最常用、最通用的 Agents，适合大多数开发场景：

| Agent | 专长领域 | 核心能力 | 何时使用 |
|-------|---------|---------|---------|
| **python-pro** | Python 3.11+ 开发 | 类型系统、异步、FastAPI | Python 项目开发、优化、类型安全 |
| **typescript-pro** | TypeScript 高级开发 | 类型编程、泛型、工具类型 | TypeScript 复杂类型、全栈应用 |
| **rust-engineer** | Rust 系统编程 | 所有权、生命周期、零开销 | 高性能系统、内存安全要求 |
| **kubernetes-specialist** | K8s 集群管理 | 部署、配置、故障排除 | K8s 部署、服务编排、集群管理 |
| **devops-engineer** | DevOps 自动化 | CI/CD、基础设施、监控 | 构建流水线、自动化部署 |
| **llm-architect** | LLM 系统设计 | 架构、微调、RAG、推理 | AI 应用开发、LLM 集成 |
| **security-engineer** | 安全审计 | 漏洞扫描、合规检查 | 安全审查、漏洞修复 |
| **multi-agent-coordinator** | 多 Agent 协调 | 任务分解、工作流编排 | 复杂任务需要多个 Agents 协作 |
| **cloud-architect** | 云架构设计 | 多云策略、成本优化 | 云迁移、架构设计、成本优化 |
| **fullstack-developer** | 全栈开发 | 前后端、数据库、API | 完整功能开发、全栈应用 |

---

## ⭐⭐⭐⭐ 四星推荐 Agents（按类别）

### 🌐 语言专家

| Agent | 语言/框架 | 适用场景 |
|-------|----------|---------|
| **golang-pro** | Go 1.18+ | 并发编程、微服务、云原生 |
| **csharp-developer** | C# / .NET Core | ASP.NET、企业应用、Windows 服务 |
| **java-architect** | Java / Spring Boot | 企业架构、微服务、大规模系统 |
| **javascript-pro** | JavaScript ES2023+ | 浏览器、Node.js、全栈 JS |
| **php-pro** | PHP 8.3+ | Laravel、Symfony、企业 Web |

### 🎨 前端专家

| Agent | 框架 | 适用场景 |
|-------|------|---------|
| **react-specialist** | React 18+ | 性能优化、复杂状态管理 |
| **frontend-developer** | 多框架 | React/Vue/Angular 全覆盖 |
| **angular-architect** | Angular 15+ | 企业级前端应用 |
| **vue-expert** | Vue 3 | Composition API、Nuxt 3 |
| **nextjs-developer** | Next.js 14+ | SSR、App Router、全栈 |

### 🏗️ 基础设施专家

| Agent | 专长 | 适用场景 |
|-------|-----|---------|
| **docker-expert** | Docker | 容器化、镜像优化、编排 |
| **terraform-engineer** | Terraform | IaC、多云部署、模块设计 |
| **platform-engineer** | 平台工程 | 内部开发者平台、自服务 |
| **sre-engineer** | SRE | SLO 管理、可靠性工程 |
| **network-engineer** | 网络 | VPC、防火墙、负载均衡 |

### 🤖 AI & ML 专家

| Agent | 专长 | 适用场景 |
|-------|-----|---------|
| **ai-engineer** | AI 系统 | 端到端 AI 实现 |
| **ml-engineer** | ML 生产 | 模型部署、服务化 |
| **mlops-engineer** | MLOps | CI/CD for ML、实验追踪 |
| **machine-learning-engineer** | 机器学习 | 训练流水线、优化 |
| **nlp-engineer** | NLP | 文本处理、语言模型 |

### 📊 数据专家

| Agent | 专长 | 适用场景 |
|-------|-----|---------|
| **data-scientist** | 数据科学 | 分析、预测建模、统计 |
| **data-analyst** | 数据分析 | BI、报表、洞察提取 |
| **data-engineer** | 数据工程 | ETL、数据流水线、数据仓库 |
| **postgres-pro** | PostgreSQL | 查询优化、复制、高可用 |
| **sql-pro** | SQL | 跨数据库查询优化 |

---

## 📚 完整分类目录

### 1. 🌐 Web & API 开发（15 个）

```
api-designer          - API 设计和规范
api-documenter        - API 文档生成
backend-developer     - 后端开发通用
fastapi-developer     - FastAPI Python 框架
fullstack-developer   - 全栈开发
nextjs-developer      - Next.js 框架
rails-expert          - Ruby on Rails
django-developer      - Django 框架
laravel-specialist    - Laravel PHP 框架
wordpress-master      - WordPress 开发
php-pro               - PHP 8.3+
graphql-architect     - GraphQL 设计
websocket-engineer    - WebSocket 实时通信
electron-pro          - Electron 桌面应用
expo-react-native-expert - Expo React Native
```

### 2. 📱 移动开发（4 个）

```
mobile-developer      - 跨平台移动开发
mobile-app-developer  - iOS/Android 原生
flutter-expert        - Flutter 跨平台
swift-expert          - iOS/macOS Swift
```

### 3. 🏗️ 基础设施 & DevOps（12 个）

```
cloud-architect           - 云架构设计
devops-engineer          - DevOps 自动化
sre-engineer             - 站点可靠性工程
platform-engineer        - 平台工程
kubernetes-specialist    - K8s 专家
docker-expert            - Docker 容器
terraform-engineer       - Terraform IaC
azure-infra-engineer     - Azure 基础设施
network-engineer         - 网络架构
deployment-engineer      - 部署自动化
terragrunt-expert        - Terragrunt 编排
windows-infra-admin      - Windows 服务器管理
```

### 4. 🔒 安全 & 质量（5 个）

```
security-engineer        - 安全工程
incident-responder       - 事件响应
devops-incident-responder - DevOps 事件处理
database-optimizer       - 数据库优化
security-auditor         - 安全审计（需添加）
```

### 5. 🤖 AI & ML（8 个）

```
ai-engineer                      - AI 系统工程
llm-architect                    - LLM 架构设计
ml-engineer                      - ML 工程
mlops-engineer                   - MLOps 流水线
machine-learning-engineer        - 机器学习工程
prompt-engineer                  - 提示工程（需添加）
nlp-engineer                     - NLP 工程
reinforcement-learning-engineer  - 强化学习
```

### 6. 📊 数据 & 分析（7 个）

```
data-scientist          - 数据科学
data-analyst            - 数据分析
data-engineer           - 数据工程
data-researcher         - 数据调研
database-administrator  - DBA
postgres-pro            - PostgreSQL 专家
sql-pro                 - SQL 优化专家
```

### 7. 💼 商业 & 产品（9 个）

```
product-manager            - 产品经理
business-analyst           - 业务分析
project-manager            - 项目管理
competitive-analyst        - 竞品分析
market-researcher          - 市场调研
trend-analyst              - 趋势分析
customer-success-manager   - 客户成功
sales-engineer             - 售前工程
risk-manager               - 风险管理
```

### 8. ✍️ 内容 & 文档（5 个）

```
technical-writer    - 技术文档
content-marketer    - 内容营销
api-documenter      - API 文档
ux-researcher       - UX 研究
seo-specialist      - SEO 优化
```

### 9. 🔄 工作流 & 系统（10 个）

```
agent-organizer             - Agent 组织管理
multi-agent-coordinator     - 多 Agent 协调
workflow-orchestrator       - 工作流编排
task-distributor            - 任务分发
context-manager             - 上下文管理
performance-monitor         - 性能监控
knowledge-synthesizer       - 知识综合
scrum-master                - Scrum 管理
it-ops-orchestrator         - IT 运维编排
error-coordinator           - 错误协调
```

### 10. 🎨 设计 & UI（2 个）

```
ui-designer     - UI 设计
ux-researcher   - UX 研究
```

### 11. 🏦 金融 & 合规（5 个）

```
fintech-engineer      - 金融科技
payment-integration   - 支付集成
quant-analyst         - 量化分析
legal-advisor         - 法律顾问
risk-manager          - 风险管理
```

### 12. 🎮 专业领域（7 个）

```
game-developer         - 游戏开发
blockchain-developer   - 区块链开发
iot-engineer           - 物联网
embedded-systems       - 嵌入式系统
cpp-pro                - C++ 专家
m365-admin             - Microsoft 365 管理
```

### 13. 🔍 研究 & 分析（7 个）

```
research-analyst                 - 研究分析
scientific-literature-researcher - 科学文献研究
search-specialist                - 搜索专家
competitive-analyst              - 竞品分析
market-researcher                - 市场研究
trend-analyst                    - 趋势分析
data-researcher                  - 数据研究
```

---

## 🧪 如何使用和测试 Agents

### 方法 1: 明确指定 Agent

```bash
# 在对话中明确要求使用特定 agent
"请使用 python-pro agent 帮我优化这个 Python 函数"

# Claude 会调用 Agent 工具并使用 python-pro
```

### 方法 2: Claude 自动选择

```bash
# 描述任务，让 Claude 选择合适的 agent
"帮我写一个 TypeScript 类型安全的 API 客户端"

# Claude 可能自动选择 typescript-pro agent
```

### 方法 3: 复杂任务的多 Agent 协作

```bash
# 请求需要多个 agents 的任务
"请协调 agents 完成这个全栈功能：
- 前端 React 组件
- FastAPI 后端 API
- PostgreSQL 数据库设计"

# Claude 可能使用 multi-agent-coordinator 来编排：
# - react-specialist
# - fastapi-developer
# - postgres-pro
```

### 方法 4: 查看 Agent 定义

```bash
# 阅读 agent 的 YAML frontmatter 了解其能力
cat .claude/agents/python-pro.md

# 查看详细文档
cat docs/agents/python-pro-详解.md
```

---

## 📖 学习路径建议

### 第 1 周：掌握核心 Agents

1. **选择你的主语言 Agent**（Day 1-3）
   - Python 开发者 → `python-pro`
   - TypeScript/JS → `typescript-pro`
   - 其他语言 → 找到对应的语言专家

2. **学习通用 Agents**（Day 4-5）
   - `fullstack-developer` - 全栈场景
   - `devops-engineer` - 部署自动化

3. **尝试协作**（Day 6-7）
   - `multi-agent-coordinator` - 多 Agent 任务

### 第 2 周：扩展专业领域

根据你的工作需求选择：

- **云原生开发** → `kubernetes-specialist`, `cloud-architect`
- **AI/ML 项目** → `llm-architect`, `ml-engineer`
- **数据工程** → `data-engineer`, `postgres-pro`
- **前端重度** → `react-specialist`, `nextjs-developer`

### 第 3-4 周：深入特定场景

- 探索你项目相关的专业 agents
- 尝试多 agent 协作完成复杂任务
- 创建自己的 agent 定义

---

## 💡 最佳实践

### 1. Agent 选择原则

- **专业性优先**：有专门的 agent 就用专门的（如 `postgres-pro` 而不是通用 `database-administrator`）
- **任务匹配**：选择最匹配任务类型的 agent
- **组合使用**：复杂任务可以用 `multi-agent-coordinator` 编排多个 agents

### 2. 提高效率

```bash
# ✅ 好的做法：明确指定 agent 和任务
"使用 python-pro agent 帮我：
1. 添加类型注解到这个函数
2. 优化性能
3. 添加错误处理"

# ❌ 不好的做法：模糊的请求
"帮我改进这个代码"
```

### 3. 调试 Agent 使用

如果 agent 没有按预期工作：

1. **检查 agent 定义**：`cat .claude/agents/<agent-name>.md`
2. **查看工具权限**：某些 agents 只能用特定工具
3. **明确任务范围**：确保任务在 agent 的专长范围内

---

## 📁 相关文档

- [Python Pro 详解](./python-pro-详解.md) - 已完成的示例文档
- [Agent 总览](./.claude/agents/README.md) - Agents 列表
- [完整学习指南](../LEARNING_GUIDE.md) - 包含 Skills、Hooks、Commands

---

## 🔄 更新记录

- **2024-03-24**: 创建 Agents 能力总结文档
- 总计 118 个 agents，按 13 个类别组织
- 包含使用方法、测试指南、学习路径

---

**开始使用 Agents 提升你的开发效率！** 🚀
