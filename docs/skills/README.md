# Claude Code Skills 能力总结与测试指南

## 📊 总览

**总计：22 个 Skills**

Skills 是 Claude Code 中的可调用工作流，通过斜杠命令（如 `/test`）或对话触发。每个 Skill 都包含特定的开发模式和最佳实践。

---

## 🌟 五星必学 Skills - TDD 核心工作流 ⭐⭐⭐⭐⭐

这 5 个 Skills 构成了 Claude Code 的核心开发方法论，建议所有用户学习：

| Skill | 功能 | 何时使用 | 触发命令 |
|-------|------|---------|---------|
| **test-driven-development** | TDD 铁律执行 | 实现任何功能或修复 bug 前 | `/test-driven-development` |
| **brainstorming** | 设计优先的头脑风暴 | 任何创造性工作之前 | `/brainstorming` |
| **writing-plans** | 详尽实施计划编写 | 多步骤任务开始前 | `/writing-plans` |
| **verification-before-completion** | 证据优先验证 | 声称完成工作前 | `/verification-before-completion` |
| **systematic-debugging** | 四阶段科学调试 | 遇到任何 bug 或测试失败时 | `/systematic-debugging` |

### 推荐工作流

```
需求 → brainstorming（设计）
     → writing-plans（计划）
     → test-driven-development（TDD 实现）
     → systematic-debugging（调试，如果需要）
     → verification-before-completion（验证）
```

---

## ⭐⭐⭐⭐ 四星推荐 Skills

### 开发辅助

| Skill | 功能 | 何时使用 | 详解文档 |
|-------|------|---------|---------|
| **using-git-worktrees** | Git Worktree 隔离管理 | 需要独立工作空间时 | ✅ 已完成 |
| **receiving-code-review** | 技术严谨的审查接收 | 收到代码审查反馈时 | ✅ 已完成 |
| **subagent-driven-development** | 子代理驱动开发 | 任务可拆分并行执行 | 待补充 |
| **writing-skills** | 编写 Skills 的 TDD 方法 | 创建新 skills 时 | 待补充 |

### 企业级自动化

| Skill | 功能 | 何时使用 | 详解文档 |
|-------|------|---------|---------|
| **autonomous-skill** | 长时运行任务自主执行 | 后台批处理、持续任务 | ✅ 已完成 |
| **deep-research** | 深度调研多 Agent 编排 | 系统性调研、竞品分析 | 待补充 |
| **github-review-pr** | GitHub PR 深度审查 | 审查 Pull Request | 待补充 |
| **kiro-skill** | 交互式功能开发工作流 | 从需求到实现的完整流程 | 待补充 |
| **spec-kit-skill** | 规格驱动开发 | 基于规格的开发流程 | 待补充 |

---

## 📚 完整 Skills 目录

### 1. 核心开发方法论（5 个）⭐⭐⭐⭐⭐

```
brainstorming                    - 设计优先头脑风暴
test-driven-development          - TDD 开发流程
systematic-debugging             - 四阶段调试法
verification-before-completion   - 证据优先验证
writing-plans                    - 实施计划编写
```

**详解文档**：
- [brainstorming-详解.md](./brainstorming-详解.md)
- [test-driven-development-详解.md](./test-driven-development-详解.md)
- [systematic-debugging-详解.md](./systematic-debugging-详解.md)
- [verification-before-completion-详解.md](./verification-before-completion-详解.md)
- [writing-plans-详解.md](./writing-plans-详解.md)

### 2. 工作空间管理（2 个）

```
using-git-worktrees              - Git Worktree 隔离
receiving-code-review            - 代码审查接收
```

**详解文档**：
- [using-git-worktrees-详解.md](./using-git-worktrees-详解.md)
- [receiving-code-review-详解.md](./receiving-code-review-详解.md)

### 3. 企业级自动化（8 个）⭐⭐⭐⭐

```
autonomous-skill                 - 长时自主任务执行
deep-research                    - 深度调研编排
github-review-pr                 - GitHub PR 审查
kiro-skill                       - 交互式功能开发
spec-kit-skill                   - 规格驱动开发
codex-skill                      - OpenAI Codex 集成
skill-creator                    - Skills 创建优化
reflection                       - 会话分析学习
```

**详解文档**：
- [autonomous-skill-详解.md](./autonomous-skill-详解.md)

### 4. 子系统开发（2 个）

```
subagent-driven-development      - 子代理驱动开发
writing-skills                   - Skills 编写方法
```

### 5. 你的自定义 Skills（5 个）

```
cleanup-branches                 - 清理分支（只保留 main）
cleanup-files                    - 清理临时/测试文件
merge                            - 合并 Pull Request
push-test-merge                  - 推送-测试-PR-合并流程
test                             - 自动检测运行测试
```

---

## 🧪 如何使用和测试 Skills

### 方法 1: 斜杠命令（推荐）

```bash
# 直接在 Claude Code 对话中输入斜杠命令
/brainstorming
/test-driven-development
/verification-before-completion

# 带参数的命令
/merge 123
/push-test-merge
```

### 方法 2: 对话触发

```bash
# 在对话中描述任务，Claude 会自动选择合适的 skill
"请使用 brainstorming skill 帮我设计用户认证功能"
"用 TDD 方法帮我实现这个功能"

# 某些关键词会自动触发 skills：
# - "用 TDD" → test-driven-development
# - "调试" / "bug" → systematic-debugging
# - "设计" / "头脑风暴" → brainstorming
```

### 方法 3: 查看 Skill 定义

```bash
# 阅读 SKILL.md 了解 skill 的工作方式
cat .claude/skills/brainstorming/SKILL.md

# 查看详细文档（如果有）
cat docs/skills/brainstorming-详解.md
```

### 方法 4: 测试 Skill 是否加载

```bash
# 在 Claude Code 中，输入斜杠
/

# 应该能看到自动补全的 skills 列表
# 如果看不到某个 skill，检查：
# 1. .claude/skills/<skill-name>/SKILL.md 是否存在
# 2. SKILL.md 格式是否正确
# 3. 是否需要重启 Claude Code
```

---

## 📖 学习路径建议

### 第 1 周：TDD 核心（必学）

**Day 1-2: 测试驱动开发**
```bash
# 1. 学习理论
cat docs/skills/test-driven-development-详解.md

# 2. 实践流程
/test-driven-development

# 3. 实现一个简单功能：
# - 先写测试（RED）
# - 写实现（GREEN）
# - 重构（REFACTOR）
```

**Day 3-4: 设计和计划**
```bash
# 1. 学习设计优先
cat docs/skills/brainstorming-详解.md

# 2. 学习计划编写
cat docs/skills/writing-plans-详解.md

# 3. 实践完整流程：
/brainstorming  # 设计
/writing-plans  # 计划
/test-driven-development  # 实现
```

**Day 5-6: 验证和调试**
```bash
# 1. 学习验证方法
cat docs/skills/verification-before-completion-详解.md

# 2. 学习调试流程
cat docs/skills/systematic-debugging-详解.md

# 3. 实践：
# - 修复一个 bug
# - 使用 systematic-debugging 找根因
# - 用 verification 确认修复
```

**Day 7: 工作空间管理**
```bash
# 1. 学习 git worktrees
cat docs/skills/using-git-worktrees-详解.md

# 2. 创建测试 worktree
/using-git-worktrees

# 3. 在隔离环境中开发功能
```

### 第 2 周：企业级 Skills

**Day 1-3: 长时任务**
```bash
# 1. 学习自主执行
cat docs/skills/autonomous-skill-详解.md

# 2. 尝试后台任务
/autonomous-skill

# 3. 实践：批量处理、持续集成
```

**Day 4-7: 深度工作流**
```bash
# 1. 学习深度调研
cat .claude/skills/deep-research/SKILL.md

# 2. 学习 PR 审查
cat .claude/skills/github-review-pr/SKILL.md

# 3. 学习交互式开发
cat .claude/skills/kiro-skill/SKILL.md

# 4. 实践完整功能开发流程
```

### 第 3-4 周：自定义和优化

**创建自己的 Skills**
```bash
# 1. 学习 skills 编写
cat .claude/skills/writing-skills/SKILL.md

# 2. 使用 skill-creator
cat .claude/skills/skill-creator/SKILL.md

# 3. 创建自己的 skill
/writing-skills

# 4. 测试和优化
```

---

## 💡 最佳实践

### 1. Skill 组合使用

**功能开发完整流程**：
```
1. /brainstorming               # 设计阶段
2. /writing-plans               # 计划阶段
3. /using-git-worktrees         # 隔离环境
4. /test-driven-development     # TDD 实现
5. /verification-before-completion  # 验证
6. /receiving-code-review       # 审查接收
```

**Bug 修复流程**：
```
1. /systematic-debugging        # 找到根因
2. /test-driven-development     # 写测试 + 修复
3. /verification-before-completion  # 验证修复
```

**深度调研流程**：
```
1. /brainstorming               # 明确调研目标
2. /deep-research               # 并行调研
3. /writing-plans               # 总结行动计划
```

### 2. 提高效率技巧

```bash
# ✅ 好的做法：按流程使用 skills
"使用 brainstorming 设计，然后用 writing-plans 做计划"

# ❌ 不好的做法：跳过设计直接写代码
"直接帮我写代码"（缺少设计和测试）
```

### 3. 调试 Skill 问题

如果 skill 没有正常工作：

1. **检查 SKILL.md 格式**：
   ```bash
   cat .claude/skills/<skill-name>/SKILL.md
   # 确保有正确的 YAML frontmatter
   ```

2. **检查触发条件**：
   ```yaml
   # SKILL.md 中的 description 字段决定何时触发
   description: Use when implementing any feature or bugfix
   ```

3. **重启 Claude Code**：Skills 在启动时加载

4. **查看日志**：
   ```bash
   # Claude Code 日志通常在
   ~/.claude/logs/
   ```

---

## 🎯 常见场景 Skills 选择

| 场景 | 推荐 Skills | 工作流 |
|------|------------|--------|
| **新功能开发** | brainstorming → writing-plans → test-driven-development | 设计 → 计划 → TDD 实现 |
| **Bug 修复** | systematic-debugging → test-driven-development → verification | 找根因 → TDD 修复 → 验证 |
| **代码审查** | receiving-code-review | 严谨审查接收 |
| **大型重构** | brainstorming → using-git-worktrees → writing-plans → TDD | 设计 → 隔离 → 计划 → 实现 |
| **深度调研** | brainstorming → deep-research | 明确目标 → 并行调研 |
| **PR 审查** | github-review-pr | 多维度代码审查 |
| **后台任务** | autonomous-skill | 长时自主执行 |
| **规格开发** | spec-kit-skill → kiro-skill | 规格 → 交互实现 |

---

## 🔄 Skill 触发机制

Skills 有两种触发方式：

### 1. 显式触发（斜杠命令）

```bash
/brainstorming
/test-driven-development
/cleanup-branches
```

### 2. 隐式触发（关键词匹配）

Claude 根据 `SKILL.md` 中的 `description` 字段判断何时触发：

```yaml
---
description: Use when implementing any feature or bugfix, before writing implementation code
---
```

常见触发词：
- "TDD" / "测试驱动" → `test-driven-development`
- "设计" / "brainstorm" → `brainstorming`
- "调试" / "debug" → `systematic-debugging`
- "验证" / "完成" → `verification-before-completion`
- "PR 审查" / "review pr" → `github-review-pr`
- "autonomous" / "后台" → `autonomous-skill`

---

## 📁 相关文档

### 详解文档（已完成）

- [brainstorming-详解.md](./brainstorming-详解.md) - 设计优先工作流
- [test-driven-development-详解.md](./test-driven-development-详解.md) - TDD 铁律
- [systematic-debugging-详解.md](./systematic-debugging-详解.md) - 四阶段调试
- [verification-before-completion-详解.md](./verification-before-completion-详解.md) - 证据验证
- [writing-plans-详解.md](./writing-plans-详解.md) - 实施计划
- [using-git-worktrees-详解.md](./using-git-worktrees-详解.md) - Worktree 管理
- [receiving-code-review-详解.md](./receiving-code-review-详解.md) - 审查接收
- [autonomous-skill-详解.md](./autonomous-skill-详解.md) - 自主执行

### 其他文档

- [Skills 总览](../../.claude/skills/README.md)
- [完整学习指南](../LEARNING_GUIDE.md)

---

## 🔄 更新记录

- **2024-03-24**: 创建 Skills 能力总结文档
- 总计 22 个 skills，包含 5 个 TDD 核心 + 8 个企业级 + 5 个自定义
- 8 个详解文档已完成，14 个待补充

---

**开始使用 Skills 建立规范的开发工作流！** 🚀
