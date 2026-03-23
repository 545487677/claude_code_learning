# Claude Code 集成指南：自动化 Push → Test → Merge 流程

## 📋 概述

Claude Code 提供了多种扩展方式，可以将 GitHub 推送、测试和合并流程完全集成。

## 🎯 集成方式对比

| 方式 | 触发方式 | 使用场景 | 复杂度 | 推荐度 |
|------|----------|----------|--------|--------|
| **Skills** | `/skill-name` | 用户主动调用 | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Hooks** | 自动触发 | Git操作后自动执行 | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **MCP Server** | API调用 | 提供工具给Claude | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Agents** | 后台运行 | 复杂多步骤任务 | ⭐⭐⭐ | ⭐⭐⭐⭐ |

## 🎨 方案一：创建 Skills（推荐）

### 什么是 Skills？

Skills 是用户可以通过 `/skill-name` 调用的自定义命令，类似于 `/commit`、`/review-pr` 这些内置技能。

### 创建 Push-Test-Merge Skill

#### 步骤1: 创建 Skills 目录

```bash
# Claude Code skills 目录位置
mkdir -p ~/.claude/skills
```

#### 步骤2: 创建 Skill 配置文件

创建 `~/.claude/skills/push-test-merge.md`:

```markdown
---
name: push-test-merge
description: 推送代码、运行测试、创建并合并PR
trigger: /push-test-merge
model: sonnet
---

# Push → Test → Merge 自动化流程

你是一个自动化部署助手。当用户调用此skill时，执行以下流程：

## 执行步骤

### 1. 检查状态
- 运行 `git status` 查看当前更改
- 确认在正确的分支上
- 询问用户是否继续

### 2. 推送代码
- 确保远程地址是SSH协议
- 提交所有更改（如果有未提交的）
- 推送到远程仓库
- 命令: `git push origin <branch>`

### 3. 创建PR（如果不在main）
- 如果当前不在main分支，创建PR
- 使用GitHub API创建PR
- PR标题：根据最近的commit生成
- PR描述：包含变更摘要和测试计划

### 4. 运行测试
- 查找项目中的测试命令：
  - `package.json` 中的 `npm test`
  - `pytest` (Python项目)
  - `go test` (Go项目)
  - `cargo test` (Rust项目)
- 运行测试并显示结果
- 如果测试失败，停止流程并报告

### 5. 合并PR（测试通过后）
- 使用GitHub API合并PR
- 合并方式：squash（默认）
- 删除源分支（如果不是main）
- 更新本地main分支

### 6. 报告结果
生成最终报告：
- ✅ 推送状态
- ✅ 测试结果
- ✅ PR链接
- ✅ 合并状态

## 配置

用户需要设置：
- `GITHUB_PERSONAL_ACCESS_TOKEN` 环境变量
- SSH密钥已配置

## 示例对话

User: /push-test-merge