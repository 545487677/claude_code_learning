# Claude Code Hooks 能力总结与测试指南

## 📊 总览

**总计：26 个 Hook 脚本**

Hooks 是 Claude Code 的事件驱动自动化系统，可以在特定时机（工具执行前后、会话生命周期等）自动运行脚本。

---

## 🎯 Hook 类型分类

### PreToolUse Hooks（工具执行前）- 7 个

在 Claude 调用工具之前执行，可以检查、提醒或阻止操作。

| Hook | 功能 | 推荐度 | 配置难度 |
|------|------|-------|---------|
| **auto-tmux-dev.js** | 自动在 tmux 中启动 dev server | ⭐⭐⭐⭐ | 简单 |
| **pre-bash-tmux-reminder.js** | 提醒长命令使用 tmux | ⭐⭐⭐ | 简单 |
| **pre-bash-git-push-reminder.js** | Git push 前检查提醒 | ⭐⭐⭐⭐⭐ | 简单 |
| **pre-bash-dev-server-block.js** | 阻止非 tmux 环境运行 dev | ⭐⭐⭐⭐ | 简单 |
| **doc-file-warning.js** | 警告非标准文档文件 | ⭐⭐⭐ | 简单 |
| **suggest-compact.js** | 建议手动压缩上下文 | ⭐⭐⭐ | 简单 |
| **config-protection.js** | 保护配置文件不被修改 | ⭐⭐⭐⭐ | 简单 |

**使用场景**：
- 防止意外操作（如直接 push 到 main）
- 提醒最佳实践（如长任务用 tmux）
- 保护重要文件（如 settings.json）

### PostToolUse Hooks（工具执行后）- 6 个

在 Claude 调用工具之后执行，可以自动格式化、检查或记录结果。

| Hook | 功能 | 推荐度 | 配置难度 |
|------|------|-------|---------|
| **post-bash-pr-created.js** | PR 创建后记录 URL | ⭐⭐⭐⭐ | 简单 |
| **post-bash-build-complete.js** | 构建完成后分析 | ⭐⭐⭐ | 简单 |
| **quality-gate.js** | 代码质量门检查 | ⭐⭐⭐⭐ | 中等 |
| **post-edit-format.js** | 自动格式化（Prettier/Biome）| ⭐⭐⭐⭐⭐ | 简单 |
| **post-edit-typecheck.js** | TypeScript 类型检查 | ⭐⭐⭐⭐ | 中等 |
| **post-edit-console-warn.js** | Console.log 警告 | ⭐⭐⭐ | 简单 |

**使用场景**：
- 自动代码格式化
- 代码质量检查
- 构建/测试结果记录

### Lifecycle Hooks（生命周期）- 7 个

在会话的特定生命周期阶段执行。

| Hook | 触发时机 | 功能 | 推荐度 |
|------|---------|------|-------|
| **session-start.js** | 会话启动时 | 加载上下文、初始化环境 | ⭐⭐⭐⭐⭐ |
| **session-end.js** | 会话结束时 | 保存状态、清理资源 | ⭐⭐⭐⭐⭐ |
| **session-end-marker.js** | 会话结束时 | 添加结束标记 | ⭐⭐⭐ |
| **pre-compact.js** | 上下文压缩前 | 保存压缩前状态 | ⭐⭐⭐⭐ |
| **check-console-log.js** | 会话结束前 | 检查是否有 console.log | ⭐⭐⭐⭐ |
| **evaluate-session.js** | 会话结束时 | 提取学习模式 | ⭐⭐⭐ | **cost-tracker.js** | 会话结束时 | 追踪 token 成本 | ⭐⭐⭐⭐ |

**使用场景**：
- 会话状态管理
- 自动保存和恢复
- 成本追踪
- 质量检查

### Utilities（工具脚本）- 6 个

辅助其他 hooks 运行的工具脚本。

```
run-with-flags.js             - Hook 执行包装器
run-with-flags-shell.sh       - Shell 包装器
check-hook-enabled.js         - 检查 hook 是否启用
governance-capture.js         - 治理事件捕获
insaits-security-wrapper.js   - 安全监控包装器
mcp-health-check.js           - MCP 健康检查
```

**说明**：这些通常不需要直接配置，由其他 hooks 调用。

---

## 🚀 快速开始

### 配置方式 1: 使用配置脚本（推荐）

```bash
# 运行配置向导
cd /fs_mol/guojianz/users/resource/cc_learn/claude_code_learning
./.claude/hooks/configure.sh

# 选择配置级别：
# 1 - 最小配置（仅会话管理）
# 2 - 标准配置（推荐日常使用）
# 3 - 完整配置（所有 hooks）
```

### 配置方式 2: 手动复制配置

```bash
# 最小配置（初学者）
cp .claude/hooks-minimal.json .claude/settings.json

# 标准配置（推荐）
cp .claude/hooks-standard.json .claude/settings.json

# 完整配置（高级用户）
cp .claude/hooks.json .claude/settings.json

# 重启 Claude Code 加载配置
```

### 配置方式 3: 手动编辑 settings.json

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "node .claude/hooks/pre-bash-git-push-reminder.js"
      }],
      "description": "Remind before git push"
    }],
    "PostToolUse": [{
      "matcher": "Edit",
      "hooks": [{
        "type": "command",
        "command": "node .claude/hooks/post-edit-format.js"
      }],
      "description": "Auto-format code"
    }],
    "SessionStart": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "node .claude/hooks/session-start.js"
      }]
    }],
    "Stop": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "node .claude/hooks/session-end.js",
        "async": true,
        "timeout": 10
      }]
    }]
  }
}
```

---

## 🧪 测试 Hooks

### 测试单个 Hook

```bash
# 测试 git push 提醒
echo '{"tool_name":"Bash","tool_input":{"command":"git push"}}' | \
  node .claude/hooks/pre-bash-git-push-reminder.js

# 应该看到提醒信息

# 测试会话启动
echo '{}' | node .claude/hooks/session-start.js

# 测试会话结束
echo '{}' | node .claude/hooks/session-end.js
```

### 测试完整配置

```bash
# 1. 启动 Claude Code
claude

# 2. 应该看到 session-start hook 运行

# 3. 执行一些操作测试 hooks：
# - 编辑文件 → 触发 post-edit-format（如果配置了）
# - 尝试 git push → 触发 pre-bash-git-push-reminder
# - 创建 PR → 触发 post-bash-pr-created

# 4. 结束会话
# - 应该看到 session-end 和 cost-tracker 运行
```

### 验证 Hook 是否加载

```bash
# 检查 settings.json 配置
cat .claude/settings.json | jq '.hooks'

# 查看 Claude Code 日志
tail -f ~/.claude/logs/latest.log
```

---

## 📋 三种配置级别对比

### 1. 最小配置（hooks-minimal.json）

**包含**：
- `session-start.js` - 会话启动
- `session-end.js` - 会话结束

**适合**：
- 初学者
- 最小性能影响
- 只需要基本的会话管理

**性能影响**：⭐ 最小

### 2. 标准配置（hooks-standard.json）⭐ 推荐

**包含**：
- ✅ Git push 提醒
- ✅ 自动代码格式化
- ✅ Console.log 检查和警告
- ✅ 会话管理
- ✅ 成本追踪
- ✅ 非标准文档警告

**适合**：
- 日常开发
- 平衡功能和性能
- 大多数用户

**性能影响**：⭐⭐ 轻度

### 3. 完整配置（hooks.json）

**包含**：
- ✅ 所有质量检查
- ✅ Tmux 集成
- ✅ TypeScript 检查
- ✅ 配置保护
- ✅ 完整生命周期管理
- ✅ 质量门检查

**适合**：
- 高级用户
- 企业级项目
- 严格的代码质量要求

**性能影响**：⭐⭐⭐ 中度

---

## 💡 常见场景配置

### 场景 1: Python 项目

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "node .claude/hooks/pre-bash-git-push-reminder.js"
      }]
    }],
    "PostToolUse": [{
      "matcher": "Edit",
      "hooks": [{
        "type": "command",
        "command": "node .claude/hooks/quality-gate.js"
      }]
    }],
    "SessionStart": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "node .claude/hooks/session-start.js"
      }]
    }],
    "Stop": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "node .claude/hooks/session-end.js"
      }]
    }]
  }
}
```

### 场景 2: TypeScript/React 项目

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [
        {"type": "command", "command": "node .claude/hooks/auto-tmux-dev.js"},
        {"type": "command", "command": "node .claude/hooks/pre-bash-git-push-reminder.js"}
      ]
    }],
    "PostToolUse": [{
      "matcher": "Edit",
      "hooks": [
        {"type": "command", "command": "node .claude/hooks/post-edit-format.js"},
        {"type": "command", "command": "node .claude/hooks/post-edit-typecheck.js"},
        {"type": "command", "command": "node .claude/hooks/post-edit-console-warn.js"}
      ]
    }],
    "SessionStart": [{
      "matcher": "*",
      "hooks": [{"type": "command", "command": "node .claude/hooks/session-start.js"}]
    }],
    "Stop": [{
      "matcher": "*",
      "hooks": [
        {"type": "command", "command": "node .claude/hooks/check-console-log.js"},
        {"type": "command", "command": "node .claude/hooks/session-end.js"},
        {"type": "command", "command": "node .claude/hooks/cost-tracker.js"}
      ]
    }]
  }
}
```

### 场景 3: 只要基本功能

```json
{
  "hooks": {
    "SessionStart": [{
      "matcher": "*",
      "hooks": [{"type": "command", "command": "node .claude/hooks/session-start.js"}]
    }],
    "Stop": [{
      "matcher": "*",
      "hooks": [
        {"type": "command", "command": "node .claude/hooks/session-end.js"},
        {"type": "command", "command": "node .claude/hooks/cost-tracker.js"}
      ]
    }]
  }
}
```

---

## 🎯 Hook 选择建议

### 必选 Hooks（所有项目）⭐⭐⭐⭐⭐

```
session-start.js           - 会话初始化
session-end.js             - 保存会话状态
pre-bash-git-push-reminder.js  - 防止意外 push
```

### 推荐 Hooks（日常开发）⭐⭐⭐⭐

```
post-edit-format.js        - 自动格式化
check-console-log.js       - Console 检查
cost-tracker.js            - 成本追踪
doc-file-warning.js        - 文档规范
```

### 可选 Hooks（特定场景）⭐⭐⭐

```
auto-tmux-dev.js           - 如果经常运行 dev server
post-edit-typecheck.js     - TypeScript 项目
quality-gate.js            - 严格质量要求
config-protection.js       - 多人协作项目
```

---

## ⚙️ 环境变量控制

你可以使用环境变量动态控制 hooks：

```bash
# 设置 Hook 配置级别（minimal | standard | strict）
export ECC_HOOK_PROFILE=standard

# 禁用特定 hooks（逗号分隔）
export ECC_DISABLED_HOOKS="pre:bash:tmux-reminder,post:edit:typecheck"

# 启用可选功能
export ECC_ENABLE_INSAITS=1          # 启用安全监控
export ECC_GOVERNANCE_CAPTURE=1       # 启用治理捕获

# 示例：临时禁用所有格式化 hooks
export ECC_DISABLED_HOOKS="post:edit:format"
claude  # 启动 Claude Code
```

---

## 🐛 调试和故障排除

### Hook 没有运行？

1. **检查文件权限**：
   ```bash
   chmod +x .claude/hooks/*.js
   ```

2. **检查 Node.js 版本**：
   ```bash
   node --version  # 应该 >= 16
   ```

3. **测试 hook 脚本**：
   ```bash
   echo '{}' | node .claude/hooks/session-start.js
   # 应该有输出
   ```

4. **检查 settings.json 语法**：
   ```bash
   cat .claude/settings.json | jq .
   # 应该没有语法错误
   ```

5. **查看日志**：
   ```bash
   tail -f ~/.claude/logs/latest.log
   # 查找 hook 相关的错误信息
   ```

### Hook 运行太慢？

1. **使用异步模式**：
   ```json
   {
     "type": "command",
     "command": "node .claude/hooks/session-end.js",
     "async": true,
     "timeout": 10
   }
   ```

2. **减少同步 hooks**：
   - 只保留必要的 PreToolUse hooks
   - PostToolUse hooks 尽量用异步

3. **使用最小配置**：
   ```bash
   cp .claude/hooks-minimal.json .claude/settings.json
   ```

---

## 📖 学习路径

### 第 1 天：基础配置

```bash
# 1. 运行配置脚本
./.claude/hooks/configure.sh

# 2. 选择 "最小配置"

# 3. 测试基本 hooks
echo '{}' | node .claude/hooks/session-start.js
echo '{}' | node .claude/hooks/session-end.js

# 4. 重启 Claude Code，观察 hooks 运行
```

### 第 1 周：标准配置

```bash
# 1. 阅读文档
cat docs/hooks/hooks-install.md
cat docs/hooks/hooks-usage.md

# 2. 升级到标准配置
cp .claude/hooks-standard.json .claude/settings.json

# 3. 测试各类 hooks：
# - 编辑文件看格式化
# - 尝试 git push 看提醒
# - 观察会话生命周期
```

### 第 2 周：自定义配置

```bash
# 1. 根据项目需求调整配置
# 2. 编辑 .claude/settings.json
# 3. 添加/移除特定 hooks
# 4. 测试优化后的配置
```

### 第 3-4 周：创建自定义 Hooks

```bash
# 1. 参考现有 hooks 编写自己的
cat .claude/hooks/pre-bash-git-push-reminder.js

# 2. 创建新 hook 脚本
# 3. 添加到 settings.json
# 4. 测试和调试
```

---

## 📁 相关文档

- [hooks-install.md](./hooks-install.md) - 详细安装配置指南
- [hooks-usage.md](./hooks-usage.md) - 使用指南和最佳实践
- [Hooks 源文件](../../.claude/hooks/) - 所有 hook 脚本
- [完整学习指南](../LEARNING_GUIDE.md)

---

## 🔄 更新记录

- **2024-03-24**: 创建 Hooks 能力总结文档
- 总计 26 个 hooks：7 个 PreToolUse + 6 个 PostToolUse + 7 个 Lifecycle + 6 个 Utilities
- 提供 3 种配置级别：minimal、standard、完整

---

**使用 Hooks 自动化你的开发工作流！** 🚀
