# Everything Claude Code Hooks 配置指南

## 📦 已安装的 Hooks

所有 everything-claude-code 的 hook 脚本已复制到此目录！

### 文件清单

```
.claude/hooks/
├── README.md                      # 使用指南
├── hooks.json                     # 完整配置（所有 hooks）
├── hooks-minimal.json             # 最小配置（推荐初学者）
├── hooks-standard.json            # 标准配置（推荐日常使用）
│
├── PreToolUse Hooks:
├── auto-tmux-dev.js               # 自动在 tmux 中启动开发服务器
├── pre-bash-tmux-reminder.js      # 提醒长命令使用 tmux
├── pre-bash-git-push-reminder.js  # Git push 前提醒
├── doc-file-warning.js            # 警告非标准文档文件
├── suggest-compact.js             # 建议手动压缩上下文
├── config-protection.js           # 保护配置文件不被修改
├── pre-bash-dev-server-block.js   # 阻止在非 tmux 环境运行 dev server
│
├── PostToolUse Hooks:
├── post-bash-pr-created.js        # PR 创建后记录
├── post-bash-build-complete.js    # 构建完成分析
├── quality-gate.js                # 质量检查
├── post-edit-format.js            # 自动格式化（Prettier/Biome）
├── post-edit-typecheck.js         # TypeScript 类型检查
├── post-edit-console-warn.js      # Console.log 警告
│
├── Lifecycle Hooks:
├── session-start.js               # 会话启动
├── session-end.js                 # 会话结束
├── session-end-marker.js          # 会话结束标记
├── pre-compact.js                 # 压缩前保存状态
├── check-console-log.js           # 检查 console.log
├── evaluate-session.js            # 评估会话模式
├── cost-tracker.js                # 成本跟踪
│
└── Utilities:
    ├── run-with-flags.js          # Hook 执行包装器
    ├── run-with-flags-shell.sh    # Shell 包装器
    ├── check-hook-enabled.js      # Hook 启用检查
    ├── governance-capture.js      # 治理事件捕获
    ├── insaits-security-wrapper.js # 安全监控包装器
    └── mcp-health-check.js        # MCP 健康检查
```

## 🚀 快速开始

### 方式 1: 最小配置（推荐初学者）

只启用最基本的 hooks：

```bash
cp .claude/hooks-minimal.json .claude/settings.json
```

或手动添加到你的 `~/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [{
      "matcher": "*",
      "hooks": [{"type": "command", "command": "node .claude/hooks/session-start.js"}]
    }],
    "Stop": [{
      "matcher": "*",
      "hooks": [{"type": "command", "command": "node .claude/hooks/session-end.js"}]
    }]
  }
}
```

### 方式 2: 标准配置（推荐日常使用）

启用常用的质量检查 hooks：

```bash
cp .claude/hooks-standard.json .claude/settings.json
```

### 方式 3: 完整配置（高级用户）

启用所有 hooks：

```bash
cp .claude/hooks.json .claude/settings.json
```

## 📋 配置说明

### PreToolUse Hooks（工具执行前）

| Hook | 功能 | 推荐级别 |
|------|------|---------|
| **auto-tmux-dev.js** | 自动在 tmux 中启动 dev server | ⭐⭐⭐⭐ |
| **pre-bash-tmux-reminder.js** | 提醒长命令使用 tmux | ⭐⭐⭐ |
| **pre-bash-git-push-reminder.js** | Git push 前检查提醒 | ⭐⭐⭐⭐⭐ |
| **doc-file-warning.js** | 警告非标准文档文件 | ⭐⭐⭐ |
| **suggest-compact.js** | 建议手动压缩 | ⭐⭐⭐ |
| **config-protection.js** | 保护配置文件 | ⭐⭐⭐⭐ |

### PostToolUse Hooks（工具执行后）

| Hook | 功能 | 推荐级别 |
|------|------|---------|
| **post-bash-pr-created.js** | 记录 PR URL | ⭐⭐⭐⭐ |
| **quality-gate.js** | 质量检查 | ⭐⭐⭐⭐ |
| **post-edit-format.js** | 自动格式化 | ⭐⭐⭐⭐⭐ |
| **post-edit-typecheck.js** | TypeScript 检查 | ⭐⭐⭐⭐ |
| **post-edit-console-warn.js** | Console 警告 | ⭐⭐⭐ |

### Lifecycle Hooks（生命周期）

| Hook | 功能 | 推荐级别 |
|------|------|---------|
| **session-start.js** | 会话初始化 | ⭐⭐⭐⭐⭐ |
| **session-end.js** | 保存会话状态 | ⭐⭐⭐⭐⭐ |
| **pre-compact.js** | 压缩前保存 | ⭐⭐⭐⭐ |
| **evaluate-session.js** | 提取学习模式 | ⭐⭐⭐ |
| **cost-tracker.js** | 成本追踪 | ⭐⭐⭐ |

## ⚙️ 环境变量控制

你可以使用环境变量控制 hooks 行为：

```bash
# Hook 配置文件（minimal | standard | strict）
export ECC_HOOK_PROFILE=standard

# 禁用特定 hooks
export ECC_DISABLED_HOOKS="pre:bash:tmux-reminder,post:edit:typecheck"

# 启用可选功能
export ECC_ENABLE_INSAITS=1          # 启用安全监控
export ECC_GOVERNANCE_CAPTURE=1       # 启用治理捕获
```

## 🎯 常见场景配置

### 场景 1: Python 项目

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{"type": "command", "command": "node .claude/hooks/pre-bash-git-push-reminder.js"}]
    }],
    "PostToolUse": [{
      "matcher": "Edit",
      "hooks": [
        {"type": "command", "command": "node .claude/hooks/quality-gate.js"}
      ]
    }],
    "SessionStart": [{
      "matcher": "*",
      "hooks": [{"type": "command", "command": "node .claude/hooks/session-start.js"}]
    }],
    "Stop": [{
      "matcher": "*",
      "hooks": [{"type": "command", "command": "node .claude/hooks/session-end.js"}]
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
      "hooks": [{"type": "command", "command": "node .claude/hooks/session-end.js"}]
    }]
  }
}
```

### 场景 3: 只要基本的生命周期

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

## 🔧 测试 Hooks

### 测试单个 Hook

```bash
# 创建测试输入
echo '{"tool_name":"Bash","tool_input":{"command":"git push"}}' | node .claude/hooks/pre-bash-git-push-reminder.js

# 应该看到警告信息
```

### 测试完整配置

```bash
# 启动 Claude Code
claude

# 在新会话中应该看到 session-start hook 运行
# 执行一些操作
# 结束会话应该看到 session-end hook 运行
```

## 🐛 调试

如果 hooks 没有运行：

1. **检查文件权限**：
   ```bash
   chmod +x .claude/hooks/*.js
   ```

2. **检查 Node.js**：
   ```bash
   node --version  # 应该 >= 16
   ```

3. **测试 hook 脚本**：
   ```bash
   echo '{}' | node .claude/hooks/session-start.js
   ```

4. **查看日志**：
   ```bash
   # Claude Code 日志通常在
   ~/.claude/logs/
   ```

## 📚 更多信息

- [Hooks 详细文档](./README.md)
- [Everything Claude Code GitHub](https://github.com/yourusername/everything-claude-code)
- [Claude Code 官方文档](https://docs.anthropic.com/claude/docs/claude-code)

## ⚠️ 注意事项

1. **首次使用**：建议从最小配置开始
2. **性能影响**：过多同步 hooks 会降低响应速度
3. **异步 hooks**：使用 `"async": true` 避免阻塞
4. **路径问题**：所有路径相对于项目根目录

## 🎓 学习路径

1. **第 1 天**：启用最小配置，了解生命周期 hooks
2. **第 1 周**：添加 Git push 提醒和格式化 hooks
3. **第 2 周**：启用质量检查和 TypeScript hooks
4. **第 3 周**：根据项目需求自定义配置
5. **长期**：创建自己的 custom hooks

---

**配置完成！开始享受自动化的工作流吧！** 🚀
