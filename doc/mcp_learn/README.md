# Claude Code 学习文档目录

本目录包含使用Claude Code进行GitHub操作的完整学习笔记和自动化脚本。

## 📚 文档列表

### 1. [GitHub MCP集成学习笔记](./github_mcp.md)
**内容概要：**
- GitHub MCP认证失败问题的完整分析和解决方案
- Git Push使用HTTPS vs SSH的对比和解决方案
- 如何在MCP失效时使用GitHub REST API
- CI/CD概念澄清

**适合场景：**
- 遇到MCP认证错误
- Git推送需要密码输入
- 想要了解GitHub API的使用

**关键命令：**
```bash
# 切换到SSH协议
git remote set-url origin git@github.com:USER/REPO.git

# 使用API创建PR
curl -X POST -H "Authorization: token TOKEN" \
  https://api.github.com/repos/OWNER/REPO/pulls -d '{...}'
```

### 2. [PR和Issue管理指南](./pr_issue_management.md)
**内容概要：**
- 当前仓库PR和Issue状态分析
- 如何合并或关闭PR
- 如何管理Issue生命周期
- 分支清理的完整流程
- 推送代码的详细步骤

**适合场景：**
- 需要整理仓库的PR和Issue
- 想要了解完整的Git工作流
- 学习分支管理最佳实践

**关键操作：**
```bash
# 完整的清理流程
git checkout main
git pull origin main
git merge feature/xxx
git push origin main
git branch -d feature/xxx
git push origin --delete feature/xxx
```

### 3. [Git操作完整指南](./git_operations_guide.md)
**内容概要：**
- Git基础操作命令
- 分支管理详解
- 远程操作指南
- PR和Issue的API操作
- 实战案例
- 常用命令速查表

**适合场景：**
- Git初学者系统学习
- 需要查找特定Git命令
- 想要了解Git工作流程

**快速查询：**
- 分支操作：查看、创建、删除、合并
- 远程操作：推送、拉取、同步
- 问题解决：冲突、撤销、恢复

## 🔧 脚本工具

### 1. [test_pr.sh](../../scripts/test_pr.sh)
**功能：**自动化PR测试流程

**使用方法：**
```bash
./scripts/test_pr.sh
```

**完成的操作：**
- 自动创建带时间戳的测试分支
- 创建测试文件
- 提交更改
- 使用SSH推送到远程
- 自动创建Pull Request

**详细说明：**参见 [scripts/README.md](../../scripts/README.md)

### 2. [cleanup_pr_issue.sh](../../scripts/cleanup_pr_issue.sh)
**功能：**自动化PR和Issue清理

**使用方法：**
```bash
./scripts/cleanup_pr_issue.sh
```

**完成的操作：**
- 合并未完成的PR
- 关闭已完成的Issue
- 删除已合并的分支
- 清理远程跟踪引用

**配置：**修改脚本开头的仓库信息

## 🎯 学习路径

### 初学者路径
1. 先阅读 [GitHub MCP集成学习笔记](./github_mcp.md) 了解基础概念
2. 跟着 [PR和Issue管理指南](./pr_issue_management.md) 实践一次完整流程
3. 遇到问题时查阅 Git操作完整指南（即将添加）

### 进阶路径
1. 阅读所有文档，理解底层原理
2. 修改脚本适配自己的项目
3. 扩展自动化流程

### 实战演练
1. 使用 `test_pr.sh` 创建一个测试PR
2. 手动审查PR
3. 使用 `cleanup_pr_issue.sh` 清理

## 📊 当前仓库状态

### Pull Requests
- ✅ PR #3: 🧪 测试PR (已合并)
- ⚠️ PR #1: 添加新功能 (待处理)

### Issues
- ⚠️ Issue #2: 测试MCP (待关闭)

### 建议操作
```bash
# 运行清理脚本自动处理
./scripts/cleanup_pr_issue.sh
```

## 🛠️ 技术栈

### Git & GitHub
- Git SSH认证
- GitHub REST API v3
- Pull Request工作流
- Issue管理

### 自动化
- Bash脚本
- curl HTTP客户端
- Python JSON处理
- GitHub Actions (待添加)

### 文档
- Markdown格式
- 代码高亮
- 流程图
- 最佳实践

## 📝 文档编写规范

### 命名规则
- 使用小写字母和下划线
- 描述性文件名
- 示例：`github_mcp.md`, `pr_issue_management.md`

### 内容结构
```markdown
# 标题

## 问题背景
- 描述遇到的问题

## 问题分析
- 原因分析

## 解决方案
- 具体步骤
- 代码示例

## 参考资源
- 相关链接
```

### 代码块
- 使用正确的语言标识
- 添加注释说明
- 提供完整的可运行示例

## 🔄 更新日志

### 2026-03-23
- ✅ 创建GitHub MCP集成学习笔记
- ✅ 创建PR和Issue管理指南
- ✅ 创建Git操作完整指南（待补充）
- ✅ 创建test_pr.sh测试脚本
- ✅ 创建cleanup_pr_issue.sh清理脚本
- ✅ 创建scripts使用说明文档
- ✅ 推送所有文档和脚本到仓库

### 待办事项
- [ ] 补充Git操作完整指南
- [ ] 添加GitHub Actions CI/CD配置
- [ ] 创建更多自动化脚本
- [ ] 添加视频教程链接

## 🤝 贡献指南

### 如何添加新文档
1. 在 `doc/mcp_learn/` 目录创建Markdown文件
2. 按照文档编写规范编写内容
3. 更新本README的文档列表
4. 提交PR

### 如何添加新脚本
1. 在 `scripts/` 目录创建脚本文件
2. 添加执行权限：`chmod +x script.sh`
3. 在 `scripts/README.md` 中添加说明
4. 在本README中添加引用
5. 提交PR

## 📚 扩展阅读

### 官方文档
- [Git官方文档](https://git-scm.com/doc)
- [GitHub文档](https://docs.github.com/)
- [GitHub API文档](https://docs.github.com/en/rest)

### 社区资源
- [Pro Git Book](https://git-scm.com/book/zh/v2)
- [Git Cheat Sheet](https://training.github.com/downloads/zh_CN/github-git-cheat-sheet/)
- [GitHub Learning Lab](https://lab.github.com/)

### 相关工具
- [GitHub CLI (gh)](https://cli.github.com/)
- [Git GUI工具](https://git-scm.com/downloads/guis)
- [VS Code Git集成](https://code.visualstudio.com/docs/editor/versioncontrol)

## ❓ 常见问题

### Q: MCP认证失败怎么办？
A: 查看 [GitHub MCP集成学习笔记](./github_mcp.md) 的问题1部分。

### Q: Git推送需要输入密码？
A: 查看 [GitHub MCP集成学习笔记](./github_mcp.md) 的问题2部分，切换到SSH协议。

### Q: 如何清理已合并的PR？
A: 运行 `./scripts/cleanup_pr_issue.sh` 或参考 [PR和Issue管理指南](./pr_issue_management.md)。

### Q: 脚本运行失败？
A: 查看 `scripts/README.md` 的故障排查部分。

## 📧 反馈与支持

遇到问题或有建议？
1. 在仓库创建Issue
2. 提交Pull Request
3. 参考文档中的故障排查部分

---

📝 **文档维护**: Claude Code  
🔄 **最后更新**: 2026-03-23  
⭐ **版本**: v1.0.0
