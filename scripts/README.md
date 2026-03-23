# PR 测试脚本使用说明

## 脚本位置
`scripts/test_pr.sh`

## 功能说明
这个脚本自动化执行完整的GitHub PR创建流程，用于测试SSH推送和PR创建功能。

## 执行步骤

脚本会自动完成以下操作：

1. ✅ **检查当前Git状态**
2. ✅ **设置远程仓库为SSH协议**
   ```bash
   git remote set-url origin git@github.com:545487677/claude_code_learning.git
   ```
3. ✅ **切换到main分支并更新**
4. ✅ **创建带时间戳的测试分支**
   - 格式：`test/pr-script-YYYYMMDD_HHMMSS`
5. ✅ **创建测试文件**
   - 自动生成包含时间戳和测试信息的Markdown文件
6. ✅ **提交更改**
   - 使用规范的commit message
7. ✅ **使用SSH推送到远程**
   - 命令：`git push -u origin <branch>`
8. ✅ **自动创建Pull Request**
   - 使用GitHub REST API
   - 包含详细的PR描述

## 使用方法

### 方式一：直接运行
```bash
./scripts/test_pr.sh
```

### 方式二：使用bash执行
```bash
bash scripts/test_pr.sh
```

## 前置要求

### 1. SSH密钥配置
确保已配置GitHub SSH密钥：
```bash
# 测试SSH连接
ssh -T git@github.com
# 应该显示：Hi username! You've successfully authenticated...
```

如果未配置，请参考：
- [GitHub SSH配置文档](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)

### 2. GitHub Personal Access Token
脚本需要GitHub token来创建PR：

**方式一：使用环境变量**（推荐）
```bash
export GITHUB_PERSONAL_ACCESS_TOKEN="your_token_here"
```

**方式二：脚本会使用默认值**
- 脚本中已包含fallback token
- 适用于测试，生产环境应使用环境变量

### 3. Git仓库配置
- 确保在正确的Git仓库目录中
- 有main分支的访问权限
- 可以创建和推送分支

## 输出示例

```
=== GitHub PR 测试脚本 ===
仓库: 545487677/claude_code_learning
分支: test/pr-script-20260323_131752

[1/7] 检查当前状态...
[2/7] 设置远程仓库为SSH协议...
[3/7] 切换到main分支并更新...
[4/7] 创建测试分支...
[5/7] 创建测试文件...
[6/7] 提交更改...
[7/7] 推送分支到远程...
✅ 推送成功！

[8/8] 创建Pull Request...
✅ PR创建成功！

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 PR信息
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  编号: #3
  标题: 🧪 测试PR: 20260323_131752
  分支: test/pr-script-20260323_131752 -> main
  链接: https://github.com/545487677/claude_code_learning/pull/3
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎉 测试完成！所有步骤执行成功！
```

## 验证结果

脚本成功证明了：

### ✅ SSH推送验证
```bash
# 远程仓库已设置为SSH
git remote -v
# origin  git@github.com:545487677/claude_code_learning.git (fetch)
# origin  git@github.com:545487677/claude_code_learning.git (push)

# 推送成功
git push -u origin test/pr-script-20260323_131752
# To github.com:545487677/claude_code_learning.git
#  * [new branch]      test/pr-script-20260323_131752 -> test/pr-script-20260323_131752
```

### ✅ 工作原理

1. **SSH vs HTTPS**
   - HTTPS: `https://github.com/user/repo.git` - 需要输入用户名密码
   - SSH: `git@github.com:user/repo.git` - 使用SSH密钥自动认证

2. **为什么SSH能成功推送**
   - SSH密钥已配置在GitHub账户中
   - Git使用本地私钥与GitHub公钥配对认证
   - 无需交互式输入凭据

3. **PR创建机制**
   - Git本身不支持创建PR
   - 使用GitHub REST API创建PR
   - API需要Personal Access Token认证

## 清理测试分支

测试完成后，可以清理：

```bash
# 查看所有测试分支
git branch -a | grep test/pr-script

# 删除本地分支
git branch -d test/pr-script-20260323_131752

# 删除远程分支
git push origin --delete test/pr-script-20260323_131752
```

或者通过PR合并/关闭后，GitHub会提示删除分支。

## 故障排查

### 问题1：SSH推送失败
```
Permission denied (publickey)
```

**解决方案：**
```bash
# 检查SSH密钥
ls -la ~/.ssh/
# 应该有 id_rsa 和 id_rsa.pub

# 测试SSH连接
ssh -T git@github.com

# 如果失败，需要生成并添加SSH密钥
ssh-keygen -t ed25519 -C "your_email@example.com"
# 然后将 ~/.ssh/id_ed25519.pub 添加到GitHub
```

### 问题2：PR创建失败
```
❌ PR创建失败
```

**可能原因：**
- Token无效或过期
- Token权限不足（需要`repo`权限）
- 分支名称冲突

**解决方案：**
```bash
# 检查token
echo $GITHUB_PERSONAL_ACCESS_TOKEN

# 手动测试API
curl -H "Authorization: token YOUR_TOKEN" \
  https://api.github.com/user
```

### 问题3：分支已存在
```
fatal: A branch named 'xxx' already exists
```

**解决方案：**
- 脚本使用时间戳确保分支名唯一
- 如果仍冲突，删除旧分支：`git branch -D <branch>`

## 技术细节

### 脚本特性
- ✅ 带时间戳的唯一分支名
- ✅ 彩色输出，易于阅读
- ✅ 错误自动退出（`set -e`）
- ✅ 详细的进度提示
- ✅ 完整的PR描述模板

### 使用的技术
- **Bash脚本**：自动化流程
- **Git SSH**：安全的代码推送
- **GitHub REST API**：PR创建
- **Python JSON处理**：API请求和响应解析

## 最佳实践

1. **测试前备份**
   - 确保重要更改已提交
   - 脚本会切换分支

2. **定期清理**
   - 测试分支会累积
   - 定期删除旧的测试分支

3. **生产环境**
   - 修改仓库信息
   - 使用环境变量存储token
   - 添加更多错误处理

## 扩展用法

### 自定义仓库
修改脚本开头的配置：
```bash
REPO_OWNER="your-username"
REPO_NAME="your-repo"
BASE_BRANCH="develop"  # 或其他基础分支
```

### 添加到CI/CD
可以集成到GitHub Actions或其他CI系统：
```yaml
# .github/workflows/test-pr.yml
name: Test PR Creation
on: [workflow_dispatch]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run PR test
        run: ./scripts/test_pr.sh
        env:
          GITHUB_PERSONAL_ACCESS_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## 相关资源

- [Git SSH配置](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [GitHub API文档](https://docs.github.com/en/rest)
- [Bash脚本指南](https://www.gnu.org/software/bash/manual/)
- [Git分支管理](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging)

## 成功案例

✅ **本次测试结果：**
- PR #3: https://github.com/545487677/claude_code_learning/pull/3
- 分支: `test/pr-script-20260323_131752`
- 文件: `test_pr_20260323_131752.md`
- 推送方式: SSH
- PR创建: GitHub API

**证明了：**
1. SSH协议推送完全正常工作
2. 不需要输入用户名密码
3. 可以自动化创建PR
4. 整个流程可以脚本化
