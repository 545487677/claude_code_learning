# using-git-worktrees Skill 详解

<div align="center">

**Git Worktree 隔离工作空间管理**

**Git Worktree Isolated Workspace Management**

⭐⭐⭐⭐⭐ 必备 Skill | From: Superpowers

[简体中文](#简体中文) | [English](#english)

</div>

---

## 简体中文

### 📖 Skill 简介

**using-git-worktrees** 是一个** Git Worktree 工作空间管理 Skill**，教你如何系统化地创建隔离的开发环境，让你可以在同一个仓库的不同分支上同时工作，而不需要切换分支或担心污染主工作区。

**核心理念**：系统化的目录选择 + 安全验证 = 可靠的隔离。

### 🎯 何时使用

✅ **必须使用的场景**：
- 开始需要隔离的功能开发
- 执行实施计划前（配合 writing-plans）
- 需要在多个分支上同时工作
- 想保护主工作区不被实验性代码影响
- 准备长期开发任务

❌ **不需要使用的场景**：
- 快速的单文件修复
- 不需要隔离的小改动
- 已经在 worktree 中工作

### ⚙️ 工作原理

#### Git Worktree 是什么？

```
常规 Git 工作流:
  主工作区 (main 分支)
  └─ 切换到 feature 分支
  └─ 修改代码
  └─ 切换回 main
  └─ 丢失 feature 的未提交更改 ❌

Git Worktree 工作流:
  主工作区 (main 分支)
  └─ 保持在 main，不切换

  Worktree 1 (.worktrees/feature-a)
  └─ feature-a 分支
  └─ 独立工作

  Worktree 2 (.worktrees/feature-b)
  └─ feature-b 分支
  └─ 独立工作

  ✓ 所有工作区同时存在
  ✓ 共享 .git 目录（节省空间）
  ✓ 互不干扰
```

#### 目录选择流程

```
1. 检查现有目录
   ├─ .worktrees/ 存在？→ 使用它（首选）
   ├─ worktrees/ 存在？→ 使用它
   └─ 都不存在 → 下一步

2. 检查 CLAUDE.md
   └─ 有 worktree 目录偏好？→ 使用偏好

3. 询问用户
   └─ 选项 1: .worktrees/ (项目本地，隐藏)
   └─ 选项 2: ~/.config/superpowers/worktrees/<项目名>/
```

**优先级**：现有目录 > CLAUDE.md > 询问用户

#### 安全验证机制

**项目本地目录（.worktrees 或 worktrees）**：

**关键**：在创建 worktree 之前**必须**验证目录被 gitignore。

```bash
# 验证目录是否被忽略
git check-ignore -q .worktrees 2>/dev/null
```

**如果没有被忽略**：
1. 添加到 .gitignore
2. 提交更改
3. 然后创建 worktree

**为什么重要**：防止意外提交 worktree 内容到仓库。

**全局目录（~/.config/superpowers/worktrees）**：
- 不需要 .gitignore 验证
- 在项目外部，完全隔离

### 💡 使用示例

#### 示例 1: 第一次使用（项目本地）

```
用户: 帮我实现认证功能，用 worktree 隔离

Claude: [使用 using-git-worktrees skill]

步骤 1: 检查现有目录
--------------------
$ ls -d .worktrees 2>/dev/null
(不存在)

$ ls -d worktrees 2>/dev/null
(不存在)

步骤 2: 检查 CLAUDE.md
--------------------
$ grep -i "worktree.*director" CLAUDE.md
(没有偏好设置)

步骤 3: 询问用户
--------------------
"没有找到 worktree 目录。应该在哪里创建 worktrees？

1. .worktrees/ (项目本地，隐藏)
2. ~/.config/superpowers/worktrees/<项目名>/ (全局位置)

你更喜欢哪个？"

用户: 选择 1

步骤 4: 安全验证
--------------------
$ git check-ignore -q .worktrees
退出码: 1 (没有被忽略！)

需要修复！根据 "立即修复坏掉的东西" 规则：

$ echo ".worktrees/" >> .gitignore
$ git add .gitignore
$ git commit -m "chore: add .worktrees to gitignore"
[main a1b2c3d] chore: add .worktrees to gitignore

步骤 5: 创建 Worktree
--------------------
$ git worktree add .worktrees/auth -b feature/auth
Preparing worktree (new branch 'feature/auth')
HEAD is now at a1b2c3d chore: add .worktrees to gitignore

$ cd .worktrees/auth

步骤 6: 运行项目设置
--------------------
检测到 package.json：
$ npm install
...
added 342 packages

步骤 7: 验证清洁基线
--------------------
$ npm test
 PASS  tests/auth.test.ts
 PASS  tests/user.test.ts
...
Tests: 47 passed, 47 total

步骤 8: 报告
--------------------
Worktree ready at /Users/jesse/myproject/.worktrees/auth
Tests passing (47 tests, 0 failures)
Ready to implement auth feature

[现在可以安全地在隔离环境中工作]
```

#### 示例 2: 使用现有目录

```
用户: 创建一个 worktree 来重构数据库层

Claude: [使用 using-git-worktrees skill]

步骤 1: 检查现有目录
--------------------
$ ls -d .worktrees
.worktrees/  ← 找到了！

使用现有的 .worktrees/ 目录

步骤 2: 安全验证
--------------------
$ git check-ignore -q .worktrees
退出码: 0 ✓ (已经被忽略)

步骤 3: 创建 Worktree
--------------------
$ git worktree add .worktrees/db-refactor -b refactor/database
$ cd .worktrees/db-refactor

步骤 4: 自动检测项目类型
--------------------
检测到 pyproject.toml：
$ poetry install
Installing dependencies...

步骤 5: 运行测试
--------------------
$ pytest
=================== 128 passed in 4.2s ===================

步骤 6: 报告
--------------------
Worktree ready at /Users/jesse/myproject/.worktrees/db-refactor
Tests passing (128 tests, 0 failures)
Ready to refactor database layer
```

#### 示例 3: 全局目录（跨项目）

```
用户: 我想用全局 worktrees 位置

Claude: 更新 CLAUDE.md 以保存偏好：

```markdown
## Development Preferences

**Git Worktrees:** Use global directory at ~/.config/superpowers/worktrees/
```

$ git commit -am "docs: set worktree preference"

现在创建 worktree：

步骤 1: 检测项目名
--------------------
$ project=$(basename "$(git rev-parse --show-toplevel")")
project = "myproject"

步骤 2: 创建 Worktree（全局位置）
--------------------
$ git worktree add ~/.config/superpowers/worktrees/myproject/feature-api -b feature/api
$ cd ~/.config/superpowers/worktrees/myproject/feature-api

(不需要 gitignore 验证 - 在项目外部)

步骤 3-5: [设置和测试同上]

Worktree ready at ~/.config/superpowers/worktrees/myproject/feature-api
Tests passing
Ready to implement API feature

优点:
- 所有项目的 worktrees 集中管理
- 不需要担心 gitignore
- 容易清理
```

#### 示例 4: 测试失败时的处理

```
Claude: [创建 worktree]

步骤 1-5: [完成]

步骤 6: 验证清洁基线
--------------------
$ cargo test
...
test database::connection ... FAILED
test api::health_check ... FAILED

failures:
    database::connection
    api::health_check

test result: FAILED. 2 failed; 124 passed

Claude 报告:
"Worktree created at .worktrees/feature-xyz
但基线测试有 2 个失败：
- database::connection
- api::health_check

这些是预先存在的失败吗？
是否应该继续（在隔离环境中调试它们）还是先调查主分支？"

用户可以选择:
1. "继续，我会在 worktree 中修复它们"
2. "等等，让我先在 main 上修复这些"
```

### 🎬 自动项目设置

#### 自动检测逻辑

```bash
# Node.js
if [ -f package.json ]; then
  npm install
fi

# Rust
if [ -f Cargo.toml ]; then
  cargo build
fi

# Python
if [ -f requirements.txt ]; then
  pip install -r requirements.txt
elif [ -f pyproject.toml ]; then
  poetry install
fi

# Go
if [ -f go.mod ]; then
  go mod download
fi

# Ruby
if [ -f Gemfile ]; then
  bundle install
fi
```

**好处**：
- 自动适配项目类型
- 无需手动配置
- 每种语言使用正确的工具

### ⚠️ 最佳实践

#### ✅ DO

1. **总是遵循目录优先级**
   ```
   ✅ 检查现有 → 检查 CLAUDE.md → 询问
   ❌ 假设使用 .worktrees/
   ```

2. **项目本地时总是验证 gitignore**
   ```
   ✅ git check-ignore -q .worktrees
   ❌ 假设已经被忽略
   ```

3. **验证清洁基线**
   ```
   ✅ 运行测试，报告失败
   ❌ 假设测试会通过
   ```

4. **自动检测项目设置**
   ```
   ✅ 检查 package.json/Cargo.toml/etc.
   ❌ 硬编码 npm install
   ```

5. **保存用户偏好**
   ```
   ✅ 在 CLAUDE.md 中记录选择
   ❌ 每次都询问
   ```

#### ❌ DON'T

1. **跳过 ignore 验证**
   ```
   ❌ 问题: Worktree 内容会被追踪，污染 git status
   ✅ 修复: 总是使用 git check-ignore
   ```

2. **假设目录位置**
   ```
   ❌ 问题: 造成不一致，违反项目约定
   ✅ 修复: 遵循优先级
   ```

3. **在失败测试上继续**
   ```
   ❌ 问题: 无法区分新 bug 和原有问题
   ✅ 修复: 报告失败，获得明确许可
   ```

4. **硬编码设置命令**
   ```
   ❌ 问题: 在使用不同工具的项目上会失败
   ✅ 修复: 从项目文件自动检测
   ```

### 📊 常见错误

| 错误 | 后果 | 修复 |
|------|------|------|
| **不验证 gitignore** | Worktree 被追踪 | 总是检查，需要时添加 |
| **假设目录** | 违反约定 | 遵循优先级 |
| **忽略测试失败** | 混淆新旧 bug | 报告并询问 |
| **硬编码命令** | 项目不兼容 | 自动检测 |

### 🔗 相关 Skills

| Skill | 关系 | 用途 |
|-------|------|------|
| **brainstorming** | 之后 | 设计批准后创建 worktree |
| **writing-plans** | 配合 | 执行计划前需要 worktree |
| **subagent-driven-development** | 之前 | 执行任务前需要 worktree |
| **executing-plans** | 之前 | 执行计划前需要 worktree |

### 🎯 快速参考

| 情况 | 操作 |
|------|------|
| `.worktrees/` 存在 | 使用它（验证被忽略） |
| `worktrees/` 存在 | 使用它（验证被忽略） |
| 两者都存在 | 使用 `.worktrees/` |
| 两者都不存在 | 检查 CLAUDE.md → 询问用户 |
| 目录未被忽略 | 添加到 .gitignore + 提交 |
| 基线测试失败 | 报告失败 + 询问 |
| 无 package.json/Cargo.toml | 跳过依赖安装 |

### ✨ 为什么推荐

1. **真正的隔离** 🔒
   - 主工作区保持干净
   - 实验性代码不影响稳定版本
   - 可以同时进行多个开发

2. **安全保证** 🛡️
   - 自动 gitignore 检查
   - 清洁基线验证
   - 防止意外提交

3. **自动化** 🤖
   - 自动检测项目类型
   - 自动运行设置
   - 自动验证

4. **灵活性** 🔄
   - 支持项目本地或全局
   - 保存用户偏好
   - 适配所有语言

5. **与工作流集成** 🔗
   - brainstorming 后自动使用
   - 计划执行的必需步骤
   - 保护生产代码

### 🆚 vs 直接切换分支

| 维度 | using-git-worktrees | 切换分支 |
|------|-------------------|---------|
| **隔离性** | 完全隔离 | 共享工作区 |
| **并行工作** | 可以 | 不可以 |
| **未提交更改** | 保留 | 可能丢失 |
| **切换速度** | 无需切换 | 慢（大项目） |
| **磁盘使用** | 共享 .git | 只有一份 |
| **复杂度** | 稍高（需管理） | 简单 |

---

## English

### 📖 Skill Overview

**using-git-worktrees** is a **Git worktree workspace management skill** that teaches you how to systematically create isolated development environments, allowing you to work on different branches simultaneously without switching or worrying about polluting your main workspace.

**Core Principle**: Systematic directory selection + safety verification = reliable isolation.

### 🎯 When to Use

See Chinese section above for use cases.

### ⚙️ How It Works

See Chinese section above for:
- What is Git Worktree
- Directory selection flow
- Safety verification mechanism

### 💡 Usage Examples

See Chinese section above for 4 detailed examples:
1. First time use (project-local)
2. Using existing directory
3. Global directory (cross-project)
4. Handling test failures

### ⚠️ Best Practices

See Chinese section above for DOs and DON'Ts.

### ✨ Why Recommended

1. **True Isolation** 🔒 - Main workspace stays clean
2. **Safety Guarantees** 🛡️ - Auto gitignore check, baseline verification
3. **Automation** 🤖 - Auto-detect project type, auto setup
4. **Flexibility** 🔄 - Support project-local or global
5. **Workflow Integration** 🔗 - Required step for plan execution

---

**Made with ❤️ for organized developers**
