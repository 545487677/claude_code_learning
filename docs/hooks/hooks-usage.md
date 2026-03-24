# Hooks 使用指南

<div align="center">

**Claude Code 事件驱动自动化系统**

**Claude Code Event-Driven Automation System**

[简体中文](#简体中文) | [English](#english)

</div>

---

## 简体中文

### 📖 Hooks 简介

**Hooks** 是 Claude Code 的**事件驱动自动化系统**，在工具执行前后自动运行，用于强制代码质量、提前发现错误和自动化重复检查。

### 🎯 工作原理

```
用户请求 → Claude 选择工具 → PreToolUse hook → 工具执行 → PostToolUse hook
```

**Hook 类型**：

| 类型 | 触发时机 | 能力 |
|------|---------|------|
| **PreToolUse** | 工具执行前 | 可以阻止（exit 2）或警告 |
| **PostToolUse** | 工具执行后 | 分析输出，不能阻止 |
| **Stop** | 每次 Claude 响应后 | 会话状态持久化 |
| **SessionStart** | 会话开始时 | 初始化和加载上下文 |
| **SessionEnd** | 会话结束时 | 清理和生命周期标记 |
| **PreCompact** | 上下文压缩前 | 保存状态 |

### 📁 项目中已有的 Hooks

你的项目已经整合了 2 个高质量 hooks：

#### 1. session-start (来自 Superpowers)

**位置**: `.claude/hooks/session-start`

**功能**：
- 会话开始时自动加载上下文
- 检测项目包管理器（npm, yarn, pnpm）
- 设置环境变量
- 恢复之前的工作状态

**配置示例**：
```json
{
  "hooks": {
    "SessionStart": [
      {
        "command": ".claude/hooks/session-start"
      }
    ]
  }
}
```

#### 2. stop-hook (来自 Claude-Code-Settings)

**位置**: `.claude/hooks/stop-hook`

**功能**：
- 每次响应后持久化会话状态
- 检查修改的文件
- 提取可学习的模式
- 成本追踪
- 生成会话摘要

**配置示例**：
```json
{
  "hooks": {
    "Stop": [
      {
        "command": ".claude/hooks/stop-hook"
      }
    ]
  }
}
```

### ⚙️ 如何配置 Hooks

#### 方法 1: 在 settings.json 中配置（推荐）

编辑 `~/.claude/settings.json` 或项目中的 `.claude/settings.json`：

```json
{
  "hooks": {
    "SessionStart": [
      {
        "command": ".claude/hooks/session-start",
        "description": "Load session context"
      }
    ],
    "Stop": [
      {
        "command": ".claude/hooks/stop-hook",
        "description": "Save session state"
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{
          "type": "command",
          "command": "node .claude/hooks/git-push-reminder.js"
        }],
        "description": "Remind before git push"
      },
      {
        "matcher": "Write",
        "hooks": [{
          "type": "command",
          "command": "node .claude/hooks/doc-file-warning.js"
        }],
        "description": "Warn about non-standard .md files"
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [{
          "type": "command",
          "command": "node .claude/hooks/prettier-format.js"
        }],
        "description": "Auto-format JS/TS with Prettier"
      }
    ]
  }
}
```

#### 方法 2: 使用 /update-config skill

更简单的方式是使用 Claude Code 的内置 skill：

```
用户: 帮我配置 hooks

Claude: /update-config
[交互式配置界面]
```

### 💡 常用 Hooks 场景

#### 场景 1: 阻止开发服务器在非 tmux 中运行

**问题**: 在终端直接运行 `npm run dev` 会导致日志不可访问

**Hook**:
```json
{
  "matcher": "Bash",
  "hooks": [{
    "type": "command",
    "command": "node .claude/hooks/dev-server-blocker.js"
  }],
  "description": "Block dev server outside tmux"
}
```

**dev-server-blocker.js**:
```javascript
let data = '';
process.stdin.on('data', chunk => data += chunk);
process.stdin.on('end', () => {
  const input = JSON.parse(data);
  const command = input.tool_input?.command || '';

  // 检查是否是开发服务器命令
  const devPatterns = ['npm run dev', 'yarn dev', 'pnpm dev'];
  const isDevCommand = devPatterns.some(p => command.includes(p));

  if (isDevCommand && !process.env.TMUX) {
    console.error('[Hook] BLOCKED: Dev server must run in tmux');
    console.error('[Hook] Use: tmux new-session -s dev');
    process.exit(2); // 阻止执行
  }

  console.log(data);
});
```

#### 场景 2: Git Push 前提醒检查

**问题**: 可能会意外推送不该推送的代码

**Hook**:
```json
{
  "matcher": "Bash",
  "hooks": [{
    "type": "command",
    "command": "node .claude/hooks/git-push-reminder.js"
  }]
}
```

**git-push-reminder.js**:
```javascript
let data = '';
process.stdin.on('data', chunk => data += chunk);
process.stdin.on('end', () => {
  const input = JSON.parse(data);
  const command = input.tool_input?.command || '';

  if (command.includes('git push')) {
    console.error('[Hook] ⚠️  About to push to remote');
    console.error('[Hook] Have you reviewed the changes?');
    console.error('[Hook] Run: git log -1 --stat');
    // 只警告，不阻止（exit 0）
  }

  console.log(data);
});
```

#### 场景 3: 编辑后自动格式化

**问题**: 代码格式不一致

**Hook**:
```json
{
  "matcher": "Edit",
  "hooks": [{
    "type": "command",
    "command": "node .claude/hooks/prettier-format.js"
  }]
}
```

**prettier-format.js**:
```javascript
const { execFileSync } = require('child_process');
const fs = require('fs');

let data = '';
process.stdin.on('data', chunk => data += chunk);
process.stdin.on('end', () => {
  const input = JSON.parse(data);
  const filePath = input.tool_input?.file_path || '';

  // 只格式化 JS/TS 文件
  if (/\.(js|ts|jsx|tsx)$/.test(filePath)) {
    try {
      execFileSync('prettier', ['--write', filePath], { stdio: 'pipe' });
      console.error('[Hook] ✓ Formatted with Prettier');
    } catch (e) {
      console.error('[Hook] ⚠️  Prettier not available');
    }
  }

  console.log(data);
});
```

#### 场景 4: 警告 TODO 注释

**Hook**:
```javascript
let data = '';
process.stdin.on('data', chunk => data += chunk);
process.stdin.on('end', () => {
  const input = JSON.parse(data);
  const newString = input.tool_input?.new_string || '';

  if (/TODO|FIXME|HACK/.test(newString)) {
    console.error('[Hook] ⚠️  New TODO/FIXME added');
    console.error('[Hook] Consider creating a GitHub issue');
  }

  console.log(data);
});
```

#### 场景 5: 阻止大文件创建

**Hook**:
```javascript
let data = '';
process.stdin.on('data', chunk => data += chunk);
process.stdin.on('end', () => {
  const input = JSON.parse(data);
  const content = input.tool_input?.content || '';
  const lines = content.split('\n').length;

  if (lines > 800) {
    console.error('[Hook] BLOCKED: File exceeds 800 lines (' + lines + ')');
    console.error('[Hook] Split into smaller, focused modules');
    process.exit(2); // 阻止
  }

  console.log(data);
});
```

#### 场景 6: 需要测试文件

**Hook**:
```javascript
const fs = require('fs');

let data = '';
process.stdin.on('data', chunk => data += chunk);
process.stdin.on('end', () => {
  const input = JSON.parse(data);
  const filePath = input.tool_input?.file_path || '';

  // 检查 src/ 中的新文件
  if (/src\/.*\.(ts|js)$/.test(filePath) && !/\.test\.|\.spec\./.test(filePath)) {
    const testPath = filePath.replace(/\.(ts|js)$/, '.test.$1');

    if (!fs.existsSync(testPath)) {
      console.error('[Hook] ⚠️  No test file for: ' + filePath);
      console.error('[Hook] Expected: ' + testPath);
      console.error('[Hook] Consider TDD: write tests first');
    }
  }

  console.log(data);
});
```

### 🎬 Hook 输入结构

```typescript
interface HookInput {
  tool_name: string;          // "Bash", "Edit", "Write", "Read", etc.
  tool_input: {
    command?: string;         // Bash: 要运行的命令
    file_path?: string;       // Edit/Write/Read: 目标文件
    old_string?: string;      // Edit: 被替换的文本
    new_string?: string;      // Edit: 替换文本
    content?: string;         // Write: 文件内容
  };
  tool_output?: {             // 仅 PostToolUse
    output?: string;          // 命令/工具输出
  };
}
```

### 🔧 高级功能

#### 1. 运行时控制（推荐）

使用环境变量控制 hook 行为：

```bash
# Hook 配置文件（minimal | standard | strict）
export ECC_HOOK_PROFILE=standard

# 禁用特定 hooks（逗号分隔）
export ECC_DISABLED_HOOKS="pre:bash:tmux-reminder,post:edit:typecheck"
```

**配置文件**：
- `minimal` — 只保留必要的生命周期和安全 hooks
- `standard` — 默认；平衡的质量 + 安全检查
- `strict` — 启用额外的提醒和更严格的防护

#### 2. 异步 Hooks

对于不应阻塞主流程的 hooks（如后台分析）：

```json
{
  "type": "command",
  "command": "node my-slow-hook.js",
  "async": true,
  "timeout": 30
}
```

异步 hooks 在后台运行，不能阻止工具执行。

#### 3. 覆盖插件 Hooks

如果安装了插件，可以在本地覆盖：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [],
        "description": "Override: allow all .md file creation"
      }
    ]
  }
}
```

### 📊 Exit 代码

```
0   — 成功（继续执行）
2   — 阻止工具调用（仅 PreToolUse）
非0 — 错误（记录但不阻止）
```

### ⚠️ 最佳实践

#### ✅ DO

1. **使用 Node.js 编写跨平台 hooks**
   ```javascript
   // 跨平台兼容
   const path = require('path');
   const { execFileSync } = require('child_process');
   ```

2. **提供清晰的错误消息**
   ```javascript
   console.error('[Hook] BLOCKED: Reason');
   console.error('[Hook] Suggested fix: ...');
   ```

3. **快速执行**
   ```javascript
   // PreToolUse hooks 应该 < 100ms
   // 慢操作使用 async: true
   ```

4. **测试 hooks**
   ```bash
   echo '{"tool_name":"Bash","tool_input":{"command":"git push"}}' | node hook.js
   ```

#### ❌ DON'T

1. **不要在 PreToolUse 中执行慢操作**
   ```javascript
   ❌ const result = execSync('npm test'); // 太慢
   ✅ 使用 async: true 或移到 PostToolUse
   ```

2. **不要假设文件路径格式**
   ```javascript
   ❌ if (path.includes('src/'))  // Windows: src\
   ✅ if (path.split(require('path').sep).includes('src'))
   ```

3. **不要忘记输出原始数据**
   ```javascript
   ❌ process.exit(0); // 丢失数据！
   ✅ console.log(data); process.exit(0);
   ```

### 🚀 快速开始

#### 步骤 1: 启用已有的 hooks

编辑 `.claude/settings.json`：

```json
{
  "hooks": {
    "SessionStart": [
      {
        "command": ".claude/hooks/session-start"
      }
    ],
    "Stop": [
      {
        "command": ".claude/hooks/stop-hook"
      }
    ]
  }
}
```

#### 步骤 2: 测试 hooks

```bash
# 启动新会话，应该看到 session-start 运行
claude

# 执行一些操作，然后结束
# 应该看到 stop-hook 保存状态
```

#### 步骤 3: 添加自定义 hook

创建 `.claude/hooks/my-hook.js`：

```javascript
let data = '';
process.stdin.on('data', chunk => data += chunk);
process.stdin.on('end', () => {
  const input = JSON.parse(data);

  // 你的逻辑
  console.error('[MyHook] Running...');

  // 总是输出原始数据
  console.log(data);
});
```

在 `settings.json` 中注册：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{
          "type": "command",
          "command": "node .claude/hooks/my-hook.js"
        }]
      }
    ]
  }
}
```

### 📚 更多示例

查看项目中的 hooks 实现：
- `.claude/hooks/session-start` - 会话初始化
- `.claude/hooks/stop-hook` - 状态持久化

参考优质 hook 仓库：
- [everything-claude-code hooks](https://github.com/yourusername/everything-claude-code/tree/main/hooks)
- [superpowers hooks](https://github.com/superpowers-repo/hooks)

### 🔗 相关资源

- [Skills 文档](../skills/README.md) - Skills 系统
- [Agents 文档](../agents/README.md) - Agents 系统
- [update-config skill](../skills/update-config/) - 配置 hooks 的 skill

---

## English

### 📖 Hooks Overview

**Hooks** are Claude Code's **event-driven automation system** that runs automatically before/after tool execution to enforce code quality, catch mistakes early, and automate repetitive checks.

### 🎯 How It Works

See Chinese section above for the workflow diagram and hook types.

### 💡 Common Use Cases

See Chinese section above for 6 detailed examples:
1. Block dev server outside tmux
2. Git push reminder
3. Auto-format after edit
4. Warn about TODO comments
5. Block large file creation
6. Require test files

### ⚙️ Configuration

See Chinese section above for configuration methods and examples.

### ✨ Best Practices

See Chinese section above for DOs and DON'Ts.

### 🚀 Quick Start

See Chinese section above for the 3-step quick start guide.

---

**Made with ❤️ for automated workflow enthusiasts**
