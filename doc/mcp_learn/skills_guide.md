# Claude Code Skills 使用指南

## 📋 什么是 Skills？

Skills 是 Claude Code 的自定义命令，用户可以通过 `/skill-name` 来调用。它们类似于内置命令如 `/commit`、`/review-pr` 等。

## 🎯 本项目创建的 Skills

我们在 `.claude/skills/` 目录创建了3个自定义技能：

### 1. `/push-test-merge` - 完整自动化流程

**功能**: 推送代码 → 运行测试 → 创建PR → 合并PR

**使用场景**:
- 完成功能开发，想要一键部署
- 需要执行完整的CI/CD流程
- 快速合并小的修复

**使用方法**:
```
/push-test-merge
```

**执行流程**:
```
1. 检查Git状态
2. 推送代码到远程
3. 运行项目测试
4. 创建Pull Request
5. 合并PR
6. 清理分支
7. 生成报告
```

**参数选项**:
```
/push-test-merge --no-test      # 跳过测试
/push-test-merge --auto-merge   # 自动合并不询问
/push-test-merge --keep-branch  # 保留源分支
```

### 2. `/test` - 运行测试

**功能**: 自动检测项目类型并运行测试

**使用场景**:
- 快速运行测试验证代码
- 不确定项目的测试命令
- 在提交前检查

**使用方法**:
```
/test
```

**支持的项目类型**:
- Node.js (npm test)
- Python (pytest)
- Go (go test)
- Rust (cargo test)
- PHP (phpunit)
- 自定义脚本 (scripts/test.sh)

**参数选项**:
```
/test --watch      # 监视模式
/test --coverage   # 显示覆盖率
/test --verbose    # 详细输出
```

### 3. `/merge` - 合并PR

**功能**: 使用GitHub API合并Pull Request

**使用场景**:
- 快速合并已审查的PR
- 批量合并多个PR
- 自定义合并方式

**使用方法**:
```
/merge              # 交互式选择PR
/merge 123          # 直接合并PR #123
```

**合并方式**:
- `squash` (推荐) - 压缩为一个commit
- `merge` - 保留所有commit
- `rebase` - 线性历史

**参数选项**:
```
/merge 123 --squash      # 使用squash方式
/merge 123 --no-delete   # 不删除分支
/merge --auto            # 自动选择第一个PR
```

## 📁 Skills 文件结构

```
.claude/
└── skills/
    ├── push-test-merge.md    # 完整自动化流程
    ├── test.md               # 测试执行
    └── merge.md              # PR合并
```

## 🚀 如何使用

### 方法1: 直接调用（项目内）

在项目目录中，直接使用斜杠命令：

```bash
# 启动Claude Code
claude

# 在对话中输入
/push-test-merge
```

### 方法2: 全局使用

如果想在任何项目都能使用，复制到全局目录：

```bash
# 复制到全局skills目录
cp .claude/skills/* ~/.claude/skills/
```

## ⚙️ 配置要求

使用这些skills需要：

### 1. 环境变量

```bash
# 添加到 ~/.zshrc 或 ~/.bashrc
export GITHUB_PERSONAL_ACCESS_TOKEN="your_github_token"
```

### 2. SSH密钥

```bash
# 测试SSH连接
ssh -T git@github.com

# 应该显示: Hi username! You've successfully authenticated...
```

### 3. Git仓库

确保在Git仓库根目录执行。

## 🎨 Skill 的工作原理

### Skill 文件格式

每个skill是一个Markdown文件，包含frontmatter和prompt：

```markdown
---
name: skill-name           # skill名称
description: 描述          # 功能描述
trigger: /skill-name       # 触发命令
model: sonnet              # 使用的模型
---

# Skill Prompt

这里是给Claude的指令...
```

### 执行流程

```
用户输入: /skill-name
    ↓
Claude Code 加载 skill文件
    ↓
执行 skill 中的指令
    ↓
调用工具 (Bash, API, etc.)
    ↓
返回结果给用户
```

## 🔧 自定义 Skills

### 创建新的 Skill

1. **创建文件**:
```bash
touch .claude/skills/my-skill.md
```

2. **编写内容**:
```markdown
---
name: my-skill
description: 我的自定义skill
trigger: /my-skill
model: sonnet
---

# 我的Skill

执行以下操作：
1. ...
2. ...
```

3. **测试**:
```
/my-skill
```

### Skill 最佳实践

1. **清晰的步骤**: 分步骤说明要做什么
2. **错误处理**: 处理可能的错误情况
3. **用户交互**: 在关键步骤询问用户确认
4. **详细输出**: 显示执行进度和结果
5. **参数支持**: 支持常用参数选项

## 📊 Skills vs Hooks vs Agents

| 特性 | Skills | Hooks | Agents |
|------|--------|-------|--------|
| 触发方式 | 手动 `/command` | 自动（Git操作后） | 后台运行 |
| 交互性 | 高（可询问用户） | 低（自动执行） | 中（后台但可通知） |
| 适用场景 | 用户主动操作 | 自动化检查 | 长时间任务 |
| 复杂度 | 简单 | 中等 | 较高 |

### 使用建议

- **用 Skills**: 需要用户决策的操作（合并PR、部署等）
- **用 Hooks**: 自动化检查（lint、格式化等）
- **用 Agents**: 复杂的后台任务（大规模重构、分析等）

## 🎯 实战示例

### 示例1: 快速修复并合并

```
# 1. 修改代码
vim bug.js

# 2. 使用skill自动推送测试合并
/push-test-merge

# Claude会：
# - 自动commit
# - 推送到远程
# - 运行测试
# - 创建并合并PR
# - 清理分支
```

### 示例2: 测试驱动开发

```
# 1. 写测试
vim test.js

# 2. 运行测试（应该失败）
/test

# 3. 写实现
vim code.js

# 4. 再次测试（应该通过）
/test

# 5. 推送
/push-test-merge
```

### 示例3: 批量合并PR

```
# 查看所有PR
/merge

# Claude显示:
# 1. PR #100 - Feature A
# 2. PR #101 - Feature B
# 3. PR #102 - Bug fix

# 逐个合并
选择: 1
/merge
选择: 2
/merge
选择: 3
```

## ❓ 常见问题

### Q: 为什么我的skill不工作？

A: 检查以下几点：
1. skill文件是否在 `.claude/skills/` 目录
2. frontmatter格式是否正确
3. 环境变量是否设置
4. 是否在正确的目录执行

### Q: 可以修改现有的skill吗？

A: 可以！直接编辑 `.claude/skills/*.md` 文件，保存后重新调用即可。

### Q: skill可以调用其他skill吗？

A: 可以！在skill的prompt中提到其他skill即可。

### Q: 关于那个 API Error 是什么？

A: 
```
API Error: 400 工具名称过长，请检查:
mcp__plugin_clinical-trials_ClinicalTrials__search_by_eligibility
```

**原因**: 
- 这是MCP服务器的问题，临床试验插件的工具名称太长
- 与我们创建的skills无关
- 是Claude Code系统的一个已知问题

**解决方案**:
1. **忽略它**: 不影响我们的skills使用
2. **禁用插件**: 如果持续出现，可以在 `.mcp.json` 中移除该插件
3. **等待更新**: Claude Code团队会修复这个问题

**临时禁用方法**:
```json
// .mcp.json
{
  "mcpServers": {
    // 注释掉或删除 clinical-trials 插件
    // "clinical-trials": { ... }
  }
}
```

### Q: skill能访问哪些工具？

A: Skills可以使用Claude Code的所有工具：
- Bash命令
- Git操作
- GitHub API
- 文件读写
- MCP服务器提供的工具

## 📚 进阶主题

### 创建参数化的 Skill

```markdown
---
name: deploy
description: 部署到指定环境
trigger: /deploy
---

# 部署Skill

检查用户输入的参数：
- `/deploy` - 询问环境
- `/deploy prod` - 部署到生产环境
- `/deploy staging` - 部署到测试环境

根据环境执行不同的部署脚本...
```

### 创建交互式 Skill

```markdown
---
name: interactive-setup
description: 交互式项目设置
trigger: /setup
---

# 项目设置Skill

1. 询问用户项目类型
2. 询问用户依赖
3. 生成配置文件
4. 安装依赖
5. 初始化Git
6. 创建GitHub仓库
```

### 组合多个 Skills

```markdown
---
name: full-deploy
description: 完整的部署流程
trigger: /full-deploy
---

# 完整部署Skill

执行以下skills:
1. /test - 运行测试
2. /push-test-merge - 推送并合并
3. /deploy prod - 部署到生产

每个步骤失败都会停止...
```

## 🎓 学习资源

### 官方文档
- [Claude Code文档](https://docs.anthropic.com/claude/docs)
- [Skills示例](https://github.com/anthropics/claude-code-examples)

### 本项目资源
- [MCP学习笔记](./github_mcp.md)
- [PR管理指南](./pr_issue_management.md)
- [Git操作指南](./git_operations_guide.md)

### 社区资源
- [Claude Code Community](https://community.anthropic.com/)
- [GitHub Discussions](https://github.com/anthropics/claude-code/discussions)

## ✅ 总结

本项目创建的3个skills提供了完整的GitHub自动化流程：

1. **`/push-test-merge`** - 一键完成推送、测试、PR创建和合并
2. **`/test`** - 智能检测并运行项目测试
3. **`/merge`** - 快速合并Pull Request

这些skills可以：
- ✅ 大幅提高开发效率
- ✅ 减少重复性操作
- ✅ 标准化工作流程
- ✅ 随项目共享和版本控制

开始使用：
```bash
# 1. 查看skills
ls .claude/skills/

# 2. 在Claude Code中调用
/push-test-merge
/test
/merge
```

---

📝 **创建时间**: 2026-03-23  
🔄 **最后更新**: 2026-03-23  
✍️ **作者**: Claude Code Integration
