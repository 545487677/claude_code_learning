# Claude Code Commands 能力总结与测试指南

## 📊 总览

**总计：26 个 Commands**

Commands 是 Claude Code 中预定义的命令工具，用于快速执行常见的开发任务，如部署、测试、文档生成等。

---

## 📚 Commands 完整目录

### 1. 边界与上下文管理（2 个）

```
boundary          - 边界定义和管理
context           - 上下文管理工具
```

### 2. 部署与开发（2 个）

```
deploy            - 部署自动化
dev               - 开发服务器管理
```

### 3. 文档与媒体（2 个）

```
docs              - 文档生成和管理
media             - 媒体文件处理
```

### 4. 内存与性能（2 个）

```
memory            - 内存管理工具
performance       - 性能分析和优化
```

### 5. 编排与协调（1 个）

```
orchestration     - 任务编排协调
```

### 6. 项目与推理（2 个）

```
project           - 项目管理工具
reasoning         - 推理和分析工具
```

### 7. 语言专项（1 个）

```
rust              - Rust 专项工具
```

### 8. 安全与语义（2 个）

```
security          - 安全检查工具
semantic          - 语义分析工具
```

### 9. 会话与设置（2 个）

```
session           - 会话管理
setup             - 环境配置
```

### 10. 模拟与技能（2 个）

```
simulation        - 模拟和测试
skills            - Skills 管理
```

### 11. 工作流（1 个）

```
spec-workflow     - 规格工作流
```

### 12. 框架专项（1 个）

```
svelte            - Svelte 框架工具
```

### 13. 同步与团队（2 个）

```
sync              - 同步工具
team              - 团队协作
```

### 14. 测试（1 个）

```
test              - 测试执行和管理
```

### 15. Web & MCP（2 个）

```
webmcp            - Web MCP 集成
wfgy              - WFGY 工具
```

---

## 🌟 推荐 Commands（按使用频率）

### 高频使用 ⭐⭐⭐⭐⭐

| Command | 功能 | 使用场景 |
|---------|------|---------|
| **test** | 测试执行 | 运行单元测试、集成测试 |
| **dev** | 开发服务器 | 启动开发环境 |
| **deploy** | 部署 | 部署到生产/测试环境 |
| **docs** | 文档 | 生成或更新文档 |
| **project** | 项目管理 | 项目初始化、配置 |

### 中频使用 ⭐⭐⭐⭐

| Command | 功能 | 使用场景 |
|---------|------|---------|
| **security** | 安全检查 | 漏洞扫描、安全审计 |
| **performance** | 性能分析 | 性能测试、优化 |
| **orchestration** | 任务编排 | 复杂工作流管理 |
| **session** | 会话管理 | 会话状态保存/恢复 |
| **sync** | 同步 | 数据/配置同步 |

### 特定场景 ⭐⭐⭐

| Command | 功能 | 使用场景 |
|---------|------|---------|
| **rust** | Rust 工具 | Rust 项目开发 |
| **svelte** | Svelte 工具 | Svelte 项目开发 |
| **spec-workflow** | 规格流程 | 基于规格的开发 |
| **simulation** | 模拟测试 | 场景模拟、压力测试 |
| **boundary** | 边界定义 | DDD、微服务边界 |

### 辅助工具 ⭐⭐

| Command | 功能 | 使用场景 |
|---------|------|---------|
| **context** | 上下文管理 | 上下文切换 |
| **memory** | 内存管理 | 内存分析、优化 |
| **semantic** | 语义分析 | 代码语义理解 |
| **media** | 媒体处理 | 图片、视频处理 |
| **reasoning** | 推理分析 | 代码推理、分析 |

---

## 🧪 如何使用 Commands

### 方法 1: 直接调用（如果支持）

某些 commands 可能支持直接调用（具体取决于实现）：

```bash
# 示例（实际使用方式可能不同）
claude command test
claude command deploy --env=production
```

### 方法 2: 通过对话触发

```bash
# 在 Claude Code 对话中描述任务
"请运行项目测试"           # 可能触发 test command
"帮我部署到生产环境"       # 可能触发 deploy command
"生成项目文档"            # 可能触发 docs command
```

### 方法 3: 查看 Command 定义

```bash
# 阅读 command 目录了解其功能
ls .claude/commands/test/
cat .claude/commands/test/README.md  # 如果有

# 查看 command 脚本或配置
find .claude/commands/test/ -type f
```

### 方法 4: 集成到 Skills

Commands 通常被 Skills 调用，例如：

```bash
# test skill 可能调用 test command
/test

# deploy skill 可能调用 deploy command
/deploy
```

---

## 📖 Commands vs Skills vs Hooks 的区别

| 特性 | Commands | Skills | Hooks |
|------|----------|--------|-------|
| **定义** | 预定义的可执行任务 | 工作流和方法论 | 事件驱动的自动化 |
| **触发方式** | 直接调用或被 Skills 调用 | 斜杠命令或对话 | 自动触发（事件） |
| **用途** | 执行具体任务 | 指导工作流程 | 自动化检查/操作 |
| **示例** | `test`, `deploy`, `docs` | `/test-driven-development`, `/brainstorming` | `pre-bash-git-push-reminder.js` |
| **可见性** | 工具层面 | 用户层面 | 后台运行 |

**关系**：
```
User → Skills → Commands → Hooks
         ↓         ↓         ↓
      工作流    具体任务   自动化
```

---

## 🎯 常见场景 Commands 选择

### 开发阶段

```
dev               - 启动开发服务器
test              - 运行测试
docs              - 生成文档
reasoning         - 代码分析
```

### 质量保证

```
test              - 执行测试套件
security          - 安全扫描
performance       - 性能分析
simulation        - 场景模拟
```

### 部署上线

```
deploy            - 部署应用
sync              - 同步配置
orchestration     - 编排任务
session           - 会话管理
```

### 特定技术栈

```
rust              - Rust 项目
svelte            - Svelte 项目
webmcp            - Web MCP 集成
spec-workflow     - 规格驱动开发
```

---

## 💡 最佳实践

### 1. Command 组合使用

```bash
# 开发流程
dev → test → docs → deploy

# 质量检查流程
test → security → performance

# 部署流程
test → deploy → sync
```

### 2. 与 Skills 集成

Commands 通常不直接使用，而是通过 Skills 调用：

```bash
# test skill 内部可能调用
# - test command（运行测试）
# - docs command（更新测试文档）

# deploy skill 内部可能调用
# - test command（部署前测试）
# - security command（安全检查）
# - deploy command（执行部署）
# - sync command（同步配置）
```

### 3. 自定义 Commands

如果需要创建自己的 command：

1. 在 `.claude/commands/` 创建新目录
2. 添加必要的脚本和配置文件
3. 文档化功能和用法
4. 在 Skills 中集成使用

---

## 🔍 深入了解 Commands

### Command 目录结构

```
.claude/commands/
├── README.md              # Commands 总览
├── test/                  # 测试 command
│   ├── README.md          # 说明文档
│   ├── run-tests.js       # 执行脚本
│   └── config.json        # 配置文件
├── deploy/                # 部署 command
│   ├── README.md
│   ├── deploy.sh
│   └── config.yaml
└── ...                    # 其他 commands
```

### Command 实现方式

Commands 可以用多种方式实现：

1. **Shell 脚本**：`.sh` 文件
2. **Node.js 脚本**：`.js` 文件
3. **Python 脚本**：`.py` 文件
4. **配置文件**：`.json`, `.yaml` 定义
5. **可执行文件**：任何可执行程序

### Command 与工具的关系

```
Claude Code Tools（Bash, Read, Write, etc.）
    ↑
Commands（封装常用操作）
    ↑
Skills（组合 Commands 形成工作流）
    ↑
User（通过对话或斜杠命令触发）
```

---

## 📚 学习路径

### 第 1 周：了解核心 Commands

```bash
# 1. 查看 Commands 目录
ls .claude/commands/

# 2. 阅读几个常用 Commands
cat .claude/commands/test/README.md
cat .claude/commands/deploy/README.md

# 3. 理解 Commands 的作用
# - 它们如何被 Skills 调用？
# - 它们封装了什么操作？
```

### 第 2 周：测试 Commands

```bash
# 1. 通过 Skills 间接使用 Commands
/test                    # 可能调用 test command

# 2. 观察 Commands 的执行
# - 查看日志
# - 理解输入输出
# - 了解配置选项
```

### 第 3-4 周：创建自定义 Commands

```bash
# 1. 识别重复的手动任务
# 2. 创建 command 封装这些任务
# 3. 在 Skills 中集成使用
# 4. 文档化和分享
```

---

## 🐛 调试 Commands

### Command 没有正常工作？

1. **检查 Command 目录**：
   ```bash
   ls .claude/commands/<command-name>/
   ```

2. **查看 Command 脚本**：
   ```bash
   cat .claude/commands/<command-name>/*.sh
   cat .claude/commands/<command-name>/*.js
   ```

3. **检查权限**：
   ```bash
   chmod +x .claude/commands/<command-name>/*.sh
   ```

4. **查看日志**：
   ```bash
   # 执行 command 并查看输出
   ./.claude/commands/<command-name>/run.sh
   ```

---

## 🔄 Commands 与其他组件的关系

### Commands → Skills 调用关系

```
Skills（工作流）调用 Commands（任务）

示例：
/test-driven-development skill
  ↓
调用 test command（运行测试）
调用 docs command（更新文档）
```

### Commands → Hooks 触发关系

```
Commands 执行 → 触发 Hooks

示例：
deploy command 执行
  ↓
触发 post-bash-build-complete hook
触发 quality-gate hook
```

### 完整流程

```
User 输入：/test-driven-development
  ↓
Skill: test-driven-development 激活
  ↓
调用 Command: test
  ↓
执行工具：Bash, Read, Write
  ↓
触发 Hook: post-edit-format
  ↓
返回结果给 User
```

---

## 📁 相关文档

- [Commands 源文件](../../.claude/commands/) - 所有 command 目录
- [Skills README](../skills/README.md) - Skills 与 Commands 的关系
- [Hooks README](../hooks/README.md) - Hooks 与 Commands 的关系
- [完整学习指南](../LEARNING_GUIDE.md)

---

## 🔄 更新记录

- **2024-03-24**: 创建 Commands 能力总结文档
- 总计 26 个 commands，按 15 个类别组织
- 说明 Commands、Skills、Hooks 的关系和使用方式

---

## ⚠️ 注意事项

1. **Commands 文档待完善**：
   - 大多数 commands 还没有详细的使用文档
   - 需要逐个探索每个 command 的功能
   - 可以通过查看源代码了解实现

2. **Commands 可能需要特定环境**：
   - 某些 commands 可能需要特定的依赖
   - 某些 commands 可能只在特定项目类型中可用
   - 使用前检查依赖和要求

3. **Commands 与 Skills 的区别**：
   - Commands 是**工具**，执行具体任务
   - Skills 是**流程**，指导如何使用工具
   - 通常通过 Skills 使用 Commands，而不是直接调用

---

**探索 Commands 扩展 Claude Code 的能力！** 🚀
