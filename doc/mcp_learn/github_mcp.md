# GitHub MCP 集成学习笔记

## 问题背景

在尝试使用Claude Code的GitHub MCP功能时遇到了一系列问题，本文档记录了完整的问题排查和解决过程。

## 问题1：GitHub MCP 认证失败

### 错误现象
```
MCP error -32603: Authentication Failed: Bad credentials
```

### 问题分析
1. `.mcp.json`配置中使用了环境变量：
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_PERSONAL_ACCESS_TOKEN}"
      }
    }
  }
}
```

2. 虽然token已经添加到`~/.zshrc`，但当前Claude Code会话启动时环境变量还没有设置
3. MCP服务器在启动时无法读取到`GITHUB_PERSONAL_ACCESS_TOKEN`环境变量

### 解决方案
1. **方案一：重启Claude Code**（推荐，让MCP正常工作）
   - 退出Claude Code
   - 重新启动，这样会加载`~/.zshrc`中的环境变量
   - MCP服务器就能正确获取token

2. **方案二：临时设置环境变量**（当前会话立即生效）
   ```bash
   export GITHUB_PERSONAL_ACCESS_TOKEN="your_token_here"
   ```
   但这只在当前会话有效

3. **方案三：使用GitHub REST API**（绕过MCP，本次采用）
   直接使用curl调用GitHub API，不依赖MCP服务器

## 问题2：Git Push 认证失败

### 错误现象
```bash
git push -u origin feature/test-mcp
# 报错：fatal: could not read Username for 'https://github.com': No such device or address
```

### 问题分析
- 远程仓库使用HTTPS协议：`https://github.com/545487677/claude_code_learning.git`
- HTTPS推送需要输入用户名和密码
- 在非交互式终端中无法输入凭据

### 解决方案：切换到SSH协议

```bash
# 修改远程仓库地址为SSH
git remote set-url origin git@github.com:545487677/claude_code_learning.git

# 验证修改
git remote -v
# origin  git@github.com:545487677/claude_code_learning.git (fetch)
# origin  git@github.com:545487677/claude_code_learning.git (push)

# 现在可以直接推送（前提：已配置SSH密钥）
git push origin feature/test-mcp
```

**SSH vs HTTPS 对比：**

| 协议 | 优点 | 缺点 | 使用场景 |
|------|------|------|----------|
| SSH | 一次配置，永久免密 | 需要配置SSH密钥 | 开发环境，频繁推送 |
| HTTPS | 无需额外配置 | 每次需要输入凭据 | 临时访问，CI/CD |

## 问题3：如何在MCP失效时创建PR和Issue

### 使用GitHub REST API

当MCP服务器无法使用时，可以直接调用GitHub REST API：

#### 创建Pull Request

```bash
curl -X POST \
  -H "Authorization: token YOUR_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/OWNER/REPO/pulls \
  -d '{
    "title": "PR标题",
    "head": "feature-branch",
    "base": "main",
    "body": "PR描述内容"
  }'
```

#### 创建Issue

```bash
curl -X POST \
  -H "Authorization: token YOUR_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/OWNER/REPO/issues \
  -d '{
    "title": "Issue标题",
    "body": "Issue描述内容"
  }'
```

### 为什么API调用会成功？

1. **不依赖环境变量**：直接在curl命令中提供token
2. **不依赖MCP服务器**：直接与GitHub服务器通信
3. **标准HTTP请求**：任何支持HTTP的工具都可以使用

## 关于CI/CD测试

### 澄清：本次测试中并没有CI/CD

实际上在本次操作中，**没有设置或运行CI/CD流程**。可能产生混淆的原因：

1. **GitHub自动功能**：
   - 创建PR后，GitHub会自动检查分支冲突
   - 如果仓库配置了GitHub Actions，会自动触发工作流
   - 但我们的仓库是新建的，没有配置任何CI/CD

2. **本地测试 ≠ CI/CD**：
   - 我们在本地创建了文件并提交
   - 本地测试只是验证代码可以正常提交和推送
   - 真正的CI/CD需要在`.github/workflows/`目录下配置

### 如果要添加CI/CD，需要：

创建`.github/workflows/test.yml`：

```yaml
name: CI Test

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run tests
        run: |
          echo "Running tests..."
          # 这里添加实际的测试命令
          # npm test
          # pytest
          # go test
```

## 完整操作流程总结

### 1. 配置GitHub Token

```bash
# 添加到shell配置文件
echo 'export GITHUB_PERSONAL_ACCESS_TOKEN="your_token"' >> ~/.zshrc

# 当前会话立即生效（临时）
export GITHUB_PERSONAL_ACCESS_TOKEN="your_token"
```

### 2. 切换Git远程地址

```bash
# 从HTTPS切换到SSH
git remote set-url origin git@github.com:USERNAME/REPO.git
```

### 3. 推送代码

```bash
# 创建分支
git checkout -b feature/new-feature

# 添加文件
git add .

# 提交
git commit -m "Add new feature"

# 推送（SSH方式，免密）
git push origin feature/new-feature
```

### 4. 创建PR（三种方式）

**方式一：GitHub MCP**（需要重启Claude Code加载环境变量）
```
使用Claude Code的MCP工具，会自动调用GitHub API
```

**方式二：GitHub CLI**（需要安装gh）
```bash
gh pr create --title "标题" --body "描述"
```

**方式三：GitHub REST API**（无需额外工具）
```bash
curl -X POST \
  -H "Authorization: token TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/OWNER/REPO/pulls \
  -d '{"title":"标题","head":"分支","base":"main","body":"描述"}'
```

## 故障排查检查清单

当遇到GitHub操作问题时，按以下顺序检查：

- [ ] 1. **检查网络连接**
  ```bash
  ping github.com
  ```

- [ ] 2. **检查SSH配置**（如果使用SSH）
  ```bash
  ssh -T git@github.com
  # 应该显示：Hi username! You've successfully authenticated...
  ```

- [ ] 3. **检查Token权限**
  - 访问 https://github.com/settings/tokens
  - 确认token有`repo`权限
  - 确认token未过期

- [ ] 4. **检查环境变量**
  ```bash
  echo $GITHUB_PERSONAL_ACCESS_TOKEN
  # 应该显示token，如果为空则未设置
  ```

- [ ] 5. **检查远程仓库地址**
  ```bash
  git remote -v
  # 确认使用SSH还是HTTPS
  ```

- [ ] 6. **测试GitHub API**
  ```bash
  curl -H "Authorization: token YOUR_TOKEN" \
    https://api.github.com/user
  # 应该返回用户信息
  ```

## 常见GitHub API端点

### 仓库操作
- 列出仓库：`GET /user/repos`
- 创建仓库：`POST /user/repos`
- 获取仓库信息：`GET /repos/:owner/:repo`

### Issue操作
- 列出Issues：`GET /repos/:owner/:repo/issues`
- 创建Issue：`POST /repos/:owner/:repo/issues`
- 更新Issue：`PATCH /repos/:owner/:repo/issues/:issue_number`
- 关闭Issue：`PATCH /repos/:owner/:repo/issues/:issue_number` (state: "closed")

### Pull Request操作
- 列出PRs：`GET /repos/:owner/:repo/pulls`
- 创建PR：`POST /repos/:owner/:repo/pulls`
- 更新PR：`PATCH /repos/:owner/:repo/pulls/:pull_number`
- 合并PR：`PUT /repos/:owner/:repo/pulls/:pull_number/merge`

### 完整API文档
https://docs.github.com/en/rest

## 最佳实践

1. **Token安全**
   - 永远不要将token提交到代码仓库
   - 使用环境变量存储token
   - 定期轮换token
   - 为不同用途创建不同的token（最小权限原则）

2. **Git协议选择**
   - 开发环境优先使用SSH（配置一次，永久免密）
   - CI/CD环境使用HTTPS + Token（更灵活）
   - 公司内网可能只允许HTTPS

3. **MCP vs API**
   - 能用MCP就用MCP（Claude Code集成更好）
   - MCP不可用时降级到GitHub API
   - 了解底层API有助于问题排查

4. **分支管理**
   - 主分支受保护，不直接推送
   - 功能开发使用feature分支
   - 通过PR合并代码，保持代码审查流程

## 参考资源

- GitHub API文档：https://docs.github.com/en/rest
- GitHub CLI：https://cli.github.com/
- SSH密钥配置：https://docs.github.com/en/authentication/connecting-to-github-with-ssh
- Personal Access Token：https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
