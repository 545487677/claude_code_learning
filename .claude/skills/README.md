# 项目自定义 Skills

这个目录包含了为本项目定制的Claude Code skills。

## 📋 可用的 Skills

| Skill | 触发命令 | 功能描述 |
|-------|---------|---------|
| **push-test-merge** | `/push-test-merge` | 完整的推送→测试→PR→合并流程 |
| **test** | `/test` | 自动检测并运行项目测试 |
| **merge** | `/merge` | 合并指定的Pull Request |

## 🚀 快速开始

### 1. 确保环境配置

```bash
# 设置GitHub token
export GITHUB_PERSONAL_ACCESS_TOKEN="your_token"

# 测试SSH连接
ssh -T git@github.com
```

### 2. 使用 Skill

在Claude Code中直接输入：

```
/push-test-merge    # 一键完成完整流程
/test               # 运行测试
/merge              # 合并PR
```

## 📖 详细文档

完整的使用说明请查看：
- [Skills使用指南](../../doc/mcp_learn/skills_guide.md)

## 🔧 自定义

你可以直接编辑这些`.md`文件来自定义behavior。

修改后保存即可，无需重启Claude Code。

## 💡 示例用法

### 场景1: 完成功能开发
```
# 开发完成后
/push-test-merge

# Claude会自动：
# 1. 推送代码
# 2. 运行测试  
# 3. 创建PR
# 4. 合并PR
# 5. 清理分支
```

### 场景2: 快速测试
```
# 修改代码后
/test

# 立即看到测试结果
```

### 场景3: 批量合并
```
# 合并多个PR
/merge
选择PR编号: 1

/merge  
选择PR编号: 2
```

## 🎯 与脚本的区别

| 特性 | Skills | Bash脚本 |
|------|--------|---------|
| 调用方式 | `/command` | `./script.sh` |
| 交互性 | 高 | 低 |
| 上下文理解 | 是 | 否 |
| 错误处理 | 智能 | 固定逻辑 |
| 学习曲线 | 低 | 中 |

## 📚 相关资源

- [Skills完整指南](../../doc/mcp_learn/skills_guide.md)
- [GitHub MCP集成](../../doc/mcp_learn/github_mcp.md)
- [PR管理指南](../../doc/mcp_learn/pr_issue_management.md)
