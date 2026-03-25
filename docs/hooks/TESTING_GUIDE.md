# Hooks 测试指南

> 完整的 Hooks 测试方法和实践指南

## 📋 目录

1. [测试准备](#测试准备)
2. [Hook 类型测试](#hook-类型测试)
3. [所有 Hooks 测试清单](#所有-hooks-测试清单)
4. [Hook 编排测试](#hook-编排测试)
5. [问题排查](#问题排查)

## 测试准备

### 环境检查

```bash
# 1. 查看所有 Hooks
ls .claude/hooks/

# 2. 检查 Hook 配置
cat .claude/settings.json | jq '.hooks'

# 3. 验证 Hook 脚本权限
ls -la .claude/hooks/*.js
```

### Hook 生命周期

Hooks 按触发时机分类：

- **session-start**: 会话开始时
- **session-end**: 会话结束时
- **pre-bash**: Bash 命令执行前
- **post-bash**: Bash 命令执行后
- **pre-edit**: 文件编辑前
- **post-edit**: 文件编辑后
- **pre-write**: 文件写入前
- **post-write**: 文件写入后
- **pre-read**: 文件读取前
- **post-read**: 文件读取后
- **pre-compact**: 压缩前
- **post-compact**: 压缩后

## Hook 类型测试

### 1. Session Hooks

#### session-start

**测试目的**：验证会话开始时的初始化

**准备工作**：

```json
// settings.json
{
  "hooks": {
    "session-start": {
      "script": ".claude/hooks/session-start.js",
      "enabled": true
    }
  }
}
```

**测试步骤**：
1. 退出当前会话
2. 重新启动 Claude Code
3. 观察启动输出

**预期行为**：
- ✅ Hook 自动执行
- ✅ 显示欢迎信息
- ✅ 加载项目配置
- ✅ 检查环境状态

**示例输出**：
```
🚀 Welcome to Claude Code!

项目：claude_code_learning
分支：main
最后提交：2 hours ago

📊 今日统计：
- Commits: 5
- Files changed: 12
- Lines added: 234

💡 提示：使用 /help 查看可用命令
```

#### session-end

**测试**：

```json
{
  "hooks": {
    "session-end": {
      "script": ".claude/hooks/session-end.js",
      "enabled": true
    }
  }
}
```

**测试步骤**：
1. 正常使用一段时间
2. 输入 `exit` 或关闭窗口
3. 观察退出时的行为

**预期行为**：
- ✅ 保存会话状态
- ✅ 生成会话报告
- ✅ 清理临时文件
- ✅ 显示统计信息

### 2. Pre-Bash Hooks

#### pre-bash-git-push-reminder

**测试目的**：在 git push 前提醒用户

**配置**：

```json
{
  "hooks": {
    "pre-bash": [
      {
        "pattern": "git push",
        "script": ".claude/hooks/pre-bash-git-push-reminder.js",
        "enabled": true
      }
    ]
  }
}
```

**测试步骤**：

```
执行命令：git push origin main
```

**预期行为**：
- ✅ Hook 拦截命令
- ✅ 显示提醒信息
- ✅ 询问是否继续
- ✅ 根据用户选择执行或取消

**预期输出**：
```
⚠️  Git Push 提醒

即将推送到：origin/main

检查清单：
□ 是否运行了测试？
□ 是否更新了文档？
□ 是否检查了代码质量？
□ 是否考虑了破坏性变更？

确认推送？(y/N)
```

#### pre-bash-tmux-reminder

**测试**：

```
执行长时间运行的命令（如：npm run dev）
```

**预期行为**：
- ✅ 检测长时间命令
- ✅ 建议使用 tmux
- ✅ 提供 tmux 命令

**预期输出**：
```
💡 建议使用 tmux

检测到长时间运行命令：npm run dev

建议在 tmux 中运行：
  tmux new -s dev
  npm run dev

是否继续在当前会话运行？(y/N)
```

#### pre-bash-dev-server-block

**测试**：

```
尝试同时启动多个开发服务器
```

**预期行为**：
- ✅ 检测端口冲突
- ✅ 阻止重复启动
- ✅ 显示已运行的服务

### 3. Post-Bash Hooks

#### post-bash-build-complete

**配置**：

```json
{
  "hooks": {
    "post-bash": [
      {
        "pattern": "npm run build|yarn build|pnpm build",
        "script": ".claude/hooks/post-bash-build-complete.js",
        "enabled": true
      }
    ]
  }
}
```

**测试**：

```
npm run build
```

**预期行为**：
- ✅ 构建完成后触发
- ✅ 分析构建产物
- ✅ 显示大小统计
- ✅ 提供优化建议

**预期输出**：
```
✅ 构建完成

📊 构建统计：
- 总大小：2.3 MB
- Gzip 后：645 KB
- 文件数：12

📦 主要文件：
- main.js: 1.2 MB
- vendor.js: 800 KB
- styles.css: 300 KB

💡 优化建议：
1. main.js 较大，考虑代码分割
2. 启用 tree-shaking
```

#### post-bash-pr-created

**测试**：

```
gh pr create --title "Feature: Add user auth" --body "..."
```

**预期行为**：
- ✅ 检测 PR 创建
- ✅ 添加标签
- ✅ 分配审查者
- ✅ 通知团队

### 4. Pre-Edit Hooks

#### pre-edit-check-permission

**测试**：

```
尝试编辑受保护的文件（如 settings.json）
```

**预期行为**：
- ✅ 检测受保护文件
- ✅ 警告用户
- ✅ 要求确认

**预期输出**：
```
⚠️  警告：正在编辑配置文件

文件：settings.json
这是一个敏感配置文件，修改可能影响系统行为

确认继续？(y/N)
```

### 5. Post-Edit Hooks

#### post-edit-format

**配置**：

```json
{
  "hooks": {
    "post-edit": [
      {
        "pattern": "\\.(js|ts|jsx|tsx|py)$",
        "script": ".claude/hooks/post-edit-format.js",
        "enabled": true
      }
    ]
  }
}
```

**测试步骤**：

1. 编辑一个 Python 文件
2. 保存后观察

**预期行为**：
- ✅ 自动运行格式化工具（black, prettier）
- ✅ 显示格式化结果
- ✅ 更新文件内容

**预期输出**：
```
🎨 代码格式化

工具：black
文件：src/main.py
状态：✅ 已格式化

变更：
- 修复 3 处缩进
- 调整 2 处换行
```

#### post-edit-typecheck

**测试**：

```
编辑 TypeScript 文件
```

**预期行为**：
- ✅ 运行类型检查（tsc）
- ✅ 报告类型错误
- ✅ 建议修复

**预期输出**：
```
🔍 类型检查

文件：src/api.ts

❌ 发现 2 个类型错误：

src/api.ts:15:10 - error TS2345
  Type 'string' is not assignable to type 'number'

src/api.ts:23:5 - error TS2322
  Property 'name' is missing in type

建议运行：npm run type-check
```

#### post-edit-console-warn

**测试**：

```
在代码中添加 console.log
```

**预期行为**：
- ✅ 检测 console.log
- ✅ 警告开发者
- ✅ 建议使用日志库

**预期输出**：
```
⚠️  Console 语句检测

文件：src/app.js:42
代码：console.log('Debug:', data);

建议：
- 生产环境应移除 console 语句
- 考虑使用专业日志库（winston, pino）
- 或使用条件日志：if (DEBUG) console.log(...)
```

### 6. Pre-Write Hooks

#### pre-write-doc-warn

**配置**：

```json
{
  "hooks": {
    "pre-write": [
      {
        "pattern": "\\.md$",
        "script": ".claude/hooks/pre-write-doc-warn.js",
        "enabled": true
      }
    ]
  }
}
```

**测试**：

```
尝试创建不必要的文档文件
```

**预期行为**：
- ✅ 检测文档文件创建
- ✅ 提醒用户考虑必要性
- ✅ 建议编辑现有文档

### 7. Special Hooks

#### mcp-health-check

**配置**：

```json
{
  "hooks": {
    "session-start": {
      "script": ".claude/hooks/mcp-health-check.js",
      "enabled": true
    }
  }
}
```

**预期行为**：
- ✅ 检查 MCP 服务器状态
- ✅ 验证连接
- ✅ 报告可用工具

**预期输出**：
```
🔌 MCP 健康检查

✅ GitHub MCP: 已连接
  - 工具：17 个
  - 状态：正常

✅ Filesystem MCP: 已连接
  - 工具：12 个
  - 状态：正常

⚠️  IDE MCP: 未连接
  - 建议：检查 VS Code 是否运行
```

#### cost-tracker

**配置**：

```json
{
  "hooks": {
    "session-end": {
      "script": ".claude/hooks/cost-tracker.js",
      "enabled": true
    }
  }
}
```

**预期行为**：
- ✅ 统计 Token 使用
- ✅ 计算成本
- ✅ 显示统计

**预期输出**：
```
💰 成本统计

本次会话：
- Input tokens: 45,230
- Output tokens: 12,450
- 总成本：$0.32

本月累计：
- 会话数：28
- 总 tokens：1,234,567
- 总成本：$8.45
- 预计月成本：$12.50
```

#### evaluate-session

**预期行为**：
- ✅ 评估会话质量
- ✅ 识别改进点
- ✅ 生成反馈报告

## 所有 Hooks 测试清单

### Session Hooks

| Hook | 测试状态 | 评分 | 备注 |
|------|---------|------|------|
| session-start | ✅ | 9/10 | 初始化完善 |
| session-end | ✅ | 8/10 | 统计准确 |
| evaluate-session | ⬜ | - | 待测试 |
| session-end-marker | ⬜ | - | 待测试 |

### Pre-Bash Hooks

| Hook | 测试状态 | 评分 | 备注 |
|------|---------|------|------|
| pre-bash-git-push-reminder | ✅ | 9/10 | 提醒有效 |
| pre-bash-tmux-reminder | ✅ | 8/10 | 检测准确 |
| pre-bash-dev-server-block | ⬜ | - | 待测试 |

### Post-Bash Hooks

| Hook | 测试状态 | 评分 | 备注 |
|------|---------|------|------|
| post-bash-build-complete | ⬜ | - | 待测试 |
| post-bash-pr-created | ⬜ | - | 待测试 |

### Post-Edit Hooks

| Hook | 测试状态 | 评分 | 备注 |
|------|---------|------|------|
| post-edit-format | ⬜ | - | 待测试 |
| post-edit-typecheck | ⬜ | - | 待测试 |
| post-edit-console-warn | ⬜ | - | 待测试 |

### Pre-Write Hooks

| Hook | 测试状态 | 评分 | 备注 |
|------|---------|------|------|
| pre-write-doc-warn | ⬜ | - | 待测试 |
| doc-file-warning | ⬜ | - | 待测试 |

### Special Hooks

| Hook | 测试状态 | 评分 | 备注 |
|------|---------|------|------|
| mcp-health-check | ⬜ | - | 待测试 |
| cost-tracker | ⬜ | - | 待测试 |
| config-protection | ⬜ | - | 待测试 |
| quality-gate | ⬜ | - | 待测试 |
| suggest-compact | ⬜ | - | 待测试 |

## Hook 编排测试

### 场景1：完整的 Git 工作流

**配置**：

```json
{
  "hooks": {
    "pre-bash": [
      {
        "pattern": "git commit",
        "script": ".claude/hooks/pre-bash-lint-check.js"
      },
      {
        "pattern": "git push",
        "script": ".claude/hooks/pre-bash-git-push-reminder.js"
      }
    ],
    "post-bash": [
      {
        "pattern": "git push",
        "script": ".claude/hooks/post-bash-notify-team.js"
      }
    ]
  }
}
```

**测试流程**：

```bash
1. git add .
2. git commit -m "feat: add feature"
   → pre-bash hook 运行 lint
3. git push origin main
   → pre-bash hook 显示提醒
   → post-bash hook 通知团队
```

### 场景2：代码质量保证

**配置**：

```json
{
  "hooks": {
    "post-edit": [
      {
        "pattern": "\\.(ts|tsx)$",
        "script": ".claude/hooks/post-edit-typecheck.js"
      },
      {
        "pattern": "\\.(ts|tsx|js|jsx)$",
        "script": ".claude/hooks/post-edit-format.js"
      },
      {
        "pattern": "\\.(ts|tsx|js|jsx)$",
        "script": ".claude/hooks/post-edit-console-warn.js"
      }
    ]
  }
}
```

**测试**：编辑一个 TypeScript 文件

**预期顺序**：
1. 类型检查
2. 代码格式化
3. Console 检测

### 场景3：会话生命周期管理

**配置**：

```json
{
  "hooks": {
    "session-start": {
      "script": ".claude/hooks/session-start.js"
    },
    "pre-compact": {
      "script": ".claude/hooks/suggest-compact.js"
    },
    "session-end": [
      {
        "script": ".claude/hooks/cost-tracker.js"
      },
      {
        "script": ".claude/hooks/evaluate-session.js"
      },
      {
        "script": ".claude/hooks/session-end-marker.js"
      }
    ]
  }
}
```

## 问题排查

### 问题1：Hook 不触发

**症状**：配置了 Hook 但没有执行

**排查步骤**：

```bash
# 1. 检查配置
cat .claude/settings.json | jq '.hooks'

# 2. 验证 enabled 状态
cat .claude/settings.json | jq '.hooks.["post-edit"][0].enabled'

# 3. 检查脚本权限
ls -la .claude/hooks/[hook-script].js

# 4. 测试脚本
node .claude/hooks/[hook-script].js
```

**常见原因**：
- Hook 未启用（`enabled: false`）
- Pattern 不匹配
- 脚本路径错误
- 脚本无执行权限

**解决方案**：

```json
{
  "hooks": {
    "post-edit": [
      {
        "pattern": "\\.js$",  // 确保 pattern 正确
        "script": ".claude/hooks/post-edit-format.js",  // 路径正确
        "enabled": true  // 确保启用
      }
    ]
  }
}
```

### 问题2：Hook 执行错误

**症状**：Hook 触发但报错

**排查**：

```bash
# 查看错误日志
tail -f .claude/logs/hooks.log

# 测试 Hook 脚本
node .claude/hooks/[hook-script].js --test
```

**常见错误**：
- 依赖缺失
- 权限不足
- 路径问题

### 问题3：Hook 性能问题

**症状**：Hook 执行太慢，影响体验

**解决方案**：

1. **异步执行**：
```javascript
// Hook 脚本
module.exports = async function hook(context) {
  // 不阻塞主流程
  setImmediate(async () => {
    await performSlowOperation();
  });

  return { allow: true };
};
```

2. **缓存结果**：
```javascript
const cache = new Map();

module.exports = function hook(context) {
  if (cache.has(context.file)) {
    return cache.get(context.file);
  }

  const result = expensiveCheck(context.file);
  cache.set(context.file, result);
  return result;
};
```

3. **条件执行**：
```javascript
module.exports = function hook(context) {
  // 只在必要时执行
  if (!shouldRun(context)) {
    return { allow: true };
  }

  return performCheck(context);
};
```

### 问题4：Hook 冲突

**症状**：多个 Hook 相互干扰

**解决方案**：

```json
{
  "hooks": {
    "post-edit": [
      {
        "pattern": "\\.js$",
        "script": ".claude/hooks/format.js",
        "priority": 1  // 先执行
      },
      {
        "pattern": "\\.js$",
        "script": ".claude/hooks/lint.js",
        "priority": 2  // 后执行
      }
    ]
  }
}
```

## 创建自定义 Hook

### 简单 Hook 示例

```javascript
// .claude/hooks/custom-hook.js

module.exports = function myHook(context) {
  // context 包含：
  // - file: 文件路径
  // - content: 文件内容
  // - command: 命令（对于 bash hooks）

  console.log('Hook 触发！');
  console.log('文件：', context.file);

  // 返回值：
  // - allow: 是否允许继续
  // - message: 提示信息（可选）
  // - modified: 修改后的内容（可选）

  return {
    allow: true,
    message: '检查通过'
  };
};
```

### 高级 Hook 示例

```javascript
// .claude/hooks/advanced-hook.js

const fs = require('fs');
const path = require('path');

module.exports = async function advancedHook(context) {
  try {
    // 读取配置
    const config = JSON.parse(
      fs.readFileSync('.claude/settings.json', 'utf8')
    );

    // 执行检查
    const issues = await checkFile(context.file, context.content);

    if (issues.length > 0) {
      return {
        allow: false,
        message: `发现 ${issues.length} 个问题：\n${issues.join('\n')}`
      };
    }

    // 修改内容（可选）
    const modified = applyFixes(context.content);

    return {
      allow: true,
      modified: modified,
      message: '自动修复了一些问题'
    };

  } catch (error) {
    console.error('Hook 执行错误：', error);
    return {
      allow: true  // 发生错误时允许继续
    };
  }
};

async function checkFile(file, content) {
  const issues = [];

  // 检查逻辑
  if (content.includes('TODO')) {
    issues.push('包含 TODO 注释');
  }

  if (content.length > 10000) {
    issues.push('文件过大（>10000 字符）');
  }

  return issues;
}

function applyFixes(content) {
  // 自动修复逻辑
  return content
    .replace(/\t/g, '  ')  // Tab 转空格
    .trim();  // 移除首尾空格
}
```

## 测试报告模板

```markdown
# [Hook 名称] 测试报告

**测试日期**：2026-03-25
**Hook 类型**：[pre-bash/post-edit/etc]

## 配置

```json
{
  "pattern": "...",
  "script": "...",
  "enabled": true
}
```

## 测试场景

### 场景1：正常触发
**操作**：[描述]
**预期**：Hook 触发并执行
**结果**：✅ 通过

### 场景2：Pattern 匹配
**操作**：[描述]
**预期**：Pattern 正确匹配
**结果**：✅ 通过

### 场景3：性能测试
**操作**：连续触发 10 次
**执行时间**：平均 125ms
**结果**：✅ 可接受

## 总体评价

| 维度 | 评分 |
|------|------|
| 触发准确性 | 9/10 |
| 执行效率 | 8/10 |
| 错误处理 | 9/10 |
| 用户体验 | 8/10 |

**总分**：34/40 (85%)

## 改进建议
1. [建议1]
2. [建议2]
```

## 最佳实践

1. **轻量级 Hook**
   - 避免在 Hook 中执行耗时操作
   - 使用异步执行非关键任务

2. **清晰的反馈**
   - 提供明确的提示信息
   - 说明 Hook 做了什么

3. **错误处理**
   - 捕获所有异常
   - 失败时不应阻塞用户

4. **可配置性**
   - 允许用户启用/禁用
   - 提供配置选项

5. **文档化**
   - 说明 Hook 的用途
   - 提供配置示例

---

**下一步**：测试所有 Hooks，完成测试清单 ✓
