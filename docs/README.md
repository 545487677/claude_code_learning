# Claude Code 完整学习文档

<div align="center">

**Claude Code 组件能力总结、学习路径与测试指南**

📅 更新时间: 2024-03-24

[English](#english) | [中文](#中文)

</div>

---

## 📊 项目统计

| 类型 | 数量 | 详解文档 | 状态 |
|------|------|---------|------|
| **Agents** | 118 | 1 个 | ✅ 已整合 |
| **Skills** | 22 | 8 个 | ✅ 已整合 |
| **Hooks** | 26 | 完整 | ✅ 已配置 |
| **Commands** | 26 | 待补充 | ✅ 已整合 |
| **总计** | **192** | **完整文档系统** | **学习就绪** |

---

## 📚 文档目录

### 🤖 [Agents - 专业 AI 助手](./agents/README.md)

118 个专业领域的 AI agents，涵盖：

- **五星必选**（10 个）：python-pro、typescript-pro、rust-engineer、kubernetes-specialist 等
- **语言专家**（25 个）：覆盖主流编程语言
- **前端专家**（15 个）：React、Vue、Angular、Next.js 等
- **基础设施**（12 个）：Docker、K8s、Terraform、云架构
- **AI & ML**（8 个）：LLM、MLOps、NLP、强化学习
- **数据**（7 个）：数据科学、工程、DBA
- **商业 & 产品**（9 个）：PM、BA、市场调研
- **其他专业领域**：内容、工作流、设计、金融、游戏等

**详解文档**：
- [python-pro-详解.md](./agents/python-pro-详解.md) - Python 3.11+ 专家（12KB，180行）

**快速开始**：
\`\`\`bash
# 查看 agents 能力总结
cat docs/agents/README.md

# 使用特定 agent
"请使用 python-pro agent 帮我优化这个 Python 函数"
\`\`\`

---

### 🎯 [Skills - 工作流与方法论](./skills/README.md)

22 个开发工作流，包含：

- **TDD 核心**（5 个）⭐⭐⭐⭐⭐：test-driven-development、brainstorming、writing-plans、verification-before-completion、systematic-debugging
- **工作空间管理**（2 个）：using-git-worktrees、receiving-code-review
- **企业级自动化**（8 个）：autonomous-skill、deep-research、github-review-pr、kiro-skill、spec-kit-skill 等
- **子系统开发**（2 个）：subagent-driven-development、writing-skills
- **自定义 Skills**（5 个）：cleanup-branches、cleanup-files、merge、push-test-merge、test

**详解文档**（8 个已完成）：
- [brainstorming-详解.md](./skills/brainstorming-详解.md)
- [test-driven-development-详解.md](./skills/test-driven-development-详解.md)
- [systematic-debugging-详解.md](./skills/systematic-debugging-详解.md)
- [verification-before-completion-详解.md](./skills/verification-before-completion-详解.md)
- [writing-plans-详解.md](./skills/writing-plans-详解.md)
- [using-git-worktrees-详解.md](./skills/using-git-worktrees-详解.md)
- [receiving-code-review-详解.md](./skills/receiving-code-review-详解.md)
- [autonomous-skill-详解.md](./skills/autonomous-skill-详解.md)

**快速开始**：
\`\`\`bash
# 使用 TDD skill
/test-driven-development
\`\`\`

---

### 🔧 [Hooks - 事件驱动自动化](./hooks/README.md)

26 个 hook 脚本，实现自动化

**配置级别**：
- **最小配置**：仅会话管理（初学者）
- **标准配置**：Git 提醒 + 格式化 + 检查（推荐）⭐
- **完整配置**：所有质量检查（高级用户）

**快速开始**：
\`\`\`bash
# 运行配置向导
./.claude/hooks/configure.sh
\`\`\`

---

### 🛠️ [Commands - 预定义任务](./commands/README.md)

26 个预定义命令工具

---

## 🎓 完整学习路径

### 第 1 周：TDD 核心 Skills（必学）⭐⭐⭐⭐⭐

**Day 1-2**: 测试驱动开发
\`\`\`bash
cat docs/skills/test-driven-development-详解.md
/test-driven-development
\`\`\`

**Day 3-4**: 设计和计划
\`\`\`bash
cat docs/skills/brainstorming-详解.md
/brainstorming
\`\`\`

### 第 2 周：核心 Agents
### 第 3 周：Hooks 自动化  
### 第 4 周：企业级 Skills

详见 [LEARNING_GUIDE.md](./LEARNING_GUIDE.md)

---

## 📂 文档结构

\`\`\`
docs/
├── README.md                      # 本文件 - 总览
├── agents/README.md               # Agents 能力总结
├── skills/README.md               # Skills 能力总结  
├── hooks/README.md                # Hooks 能力总结
├── commands/README.md             # Commands 能力总结
└── LEARNING_GUIDE.md              # 完整学习指南
\`\`\`

---

<div align="center">

**🎉 开始你的 Claude Code 学习之旅！**

[Agents](./agents/) | [Skills](./skills/) | [Hooks](./hooks/) | [Commands](./commands/)

</div>
