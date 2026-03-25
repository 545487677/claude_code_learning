# Commands 测试指南

> 完整的 Commands 测试方法和实践指南

## 📋 目录

1. [测试准备](#测试准备)
2. [按命名空间测试](#按命名空间测试)
3. [所有 Commands 测试清单](#所有-commands-测试清单)
4. [问题排查](#问题排查)

## 测试准备

### 环境检查

```bash
# 1. 查看所有命令分组
ls .claude/commands/

# 2. 查看具体命名空间
ls .claude/commands/dev/
ls .claude/commands/test/
ls .claude/commands/deploy/

# 3. 统计命令数量
find .claude/commands/ -name "*.md" | wc -l
```

### 命令命名空间

Commands 按功能分组到不同的命名空间：

- **dev**: 开发命令
- **test**: 测试命令
- **deploy**: 部署命令
- **setup**: 配置命令
- **docs**: 文档命令
- **security**: 安全命令
- **performance**: 性能命令
- **project**: 项目管理命令
- **team**: 团队协作命令
- **sync**: 同步命令

## 按命名空间测试

### 1. dev:* 开发命令

#### dev:code-review

**测试目的**：代码审查功能

**测试步骤**：

```
/dev:code-review
```

**预期行为**：
- ✅ 分析代码质量
- ✅ 检查安全漏洞
- ✅ 识别代码异味
- ✅ 提供改进建议
- ✅ 评估复杂度

**测试项目准备**：

```python
# bad_code.py
def func(x):
    if x > 0:
        if x < 10:
            if x % 2 == 0:
                return "small even"
            else:
                return "small odd"
        else:
            return "large"
    else:
        return "negative"
```

**预期输出**：
```markdown
# 代码审查报告

## 问题发现

### 高优先级
1. **过度嵌套** (complexity)
   - 位置：bad_code.py:2-10
   - 问题：嵌套深度达到 3 层
   - 建议：使用 early return 简化逻辑

### 中优先级
2. **函数命名不清晰** (naming)
   - 位置：bad_code.py:1
   - 问题：函数名 'func' 不具描述性
   - 建议：重命名为 'classify_number'

## 改进建议

```python
def classify_number(x: int) -> str:
    """Classify a number based on its value and parity."""
    if x < 0:
        return "negative"
    if x >= 10:
        return "large"
    return "small even" if x % 2 == 0 else "small odd"
```

## 评分
- 可维护性：4/10
- 可读性：5/10
- 安全性：8/10
```

#### dev:refactor-code

**测试**：

```
/dev:refactor-code bad_code.py
```

**预期行为**：
- ✅ 识别重构机会
- ✅ 提供重构方案
- ✅ 保持功能不变
- ✅ 改进代码质量

#### dev:explain-code

**测试**：

```
/dev:explain-code
```

**预期行为**：
- ✅ 解释代码逻辑
- ✅ 识别设计模式
- ✅ 说明复杂部分
- ✅ 提供使用示例

#### dev:fix-issue

**测试**：

```
/dev:fix-issue "修复登录页面的 XSS 漏洞"
```

**预期行为**：
- ✅ 理解问题
- ✅ 定位代码
- ✅ 提供修复方案
- ✅ 添加测试

#### dev:debug-error

**测试**：

```
/dev:debug-error
```

然后提供错误信息：

```
Traceback (most recent call last):
  File "app.py", line 42, in process_data
    result = data['user']['profile']['email']
KeyError: 'profile'
```

**预期行为**：
- ✅ 分析错误原因
- ✅ 提供解决方案
- ✅ 建议预防措施
- ✅ 添加错误处理代码

#### dev:remove-dead-code

**测试**：

```
/dev:remove-dead-code
```

**预期行为**：
- ✅ 扫描未使用的代码
- ✅ 识别未调用的函数
- ✅ 列出待删除项
- ✅ 安全删除代码

### 2. test:* 测试命令

#### test:write-tests

**测试**：

```
/test:write-tests src/api/users.py
```

**预期行为**：
- ✅ 分析待测试代码
- ✅ 生成单元测试
- ✅ 覆盖主要场景
- ✅ 包含边界测试

**预期输出示例**：

```python
import pytest
from src.api.users import UserAPI

@pytest.fixture
def api():
    return UserAPI()

class TestUserAPI:
    def test_create_user_success(self, api):
        user = api.create_user(
            email="test@example.com",
            name="Test User"
        )
        assert user.email == "test@example.com"
        assert user.name == "Test User"

    def test_create_user_invalid_email(self, api):
        with pytest.raises(ValueError):
            api.create_user(
                email="invalid-email",
                name="Test User"
            )

    def test_create_user_duplicate_email(self, api):
        api.create_user(email="test@example.com", name="User 1")
        with pytest.raises(DuplicateEmailError):
            api.create_user(email="test@example.com", name="User 2")

    @pytest.mark.parametrize("email,expected", [
        ("test@example.com", True),
        ("invalid", False),
        ("", False),
        (None, False),
    ])
    def test_validate_email(self, api, email, expected):
        assert api.validate_email(email) == expected
```

#### test:test-coverage

**测试**：

```
/test:test-coverage
```

**预期行为**：
- ✅ 运行覆盖率分析
- ✅ 生成覆盖率报告
- ✅ 标识未覆盖代码
- ✅ 建议添加测试

**预期输出**：

```
# 测试覆盖率报告

## 总体覆盖率：72%

| 模块 | 语句数 | 覆盖数 | 覆盖率 |
|------|--------|--------|--------|
| src/api/users.py | 50 | 40 | 80% |
| src/api/auth.py | 30 | 15 | 50% |
| src/utils/validation.py | 20 | 20 | 100% |

## 未覆盖代码

### src/api/auth.py:45-52
```python
def handle_oauth_callback(code):
    # 未测试的 OAuth 回调处理
    ...
```

## 建议
1. 添加 OAuth 流程的集成测试
2. 为 error handling 分支添加测试
```

#### test:e2e-setup

**测试**：

```
/test:e2e-setup
```

**预期行为**：
- ✅ 设置 E2E 测试框架
- ✅ 配置测试环境
- ✅ 创建示例测试
- ✅ 文档化测试流程

#### test:setup-load-testing

**测试**：

```
/test:setup-load-testing
```

**预期行为**：
- ✅ 配置负载测试工具（k6, Locust）
- ✅ 创建负载测试脚本
- ✅ 定义性能基准
- ✅ 设置监控

### 3. deploy:* 部署命令

#### deploy:prepare-release

**测试**：

```
/deploy:prepare-release
```

**预期行为**：
1. ✅ 检查 Git 状态
2. ✅ 运行所有测试
3. ✅ 生成 CHANGELOG
4. ✅ 更新版本号
5. ✅ 创建 Git 标签
6. ✅ 构建发布产物

**预期输出**：

```
# 发布准备检查

## Git 状态
✅ Working tree clean
✅ On branch: main
✅ Up to date with remote

## 测试结果
✅ Unit tests: 125/125 passed
✅ Integration tests: 45/45 passed
✅ E2E tests: 12/12 passed

## 版本信息
当前版本：1.2.3
新版本：1.3.0

## CHANGELOG 生成
✅ 从 git log 提取 commits
✅ 分类功能/修复/重构
✅ 写入 CHANGELOG.md

## 下一步
运行：git push origin v1.3.0
```

#### deploy:ci-setup

**测试**：

```
/deploy:ci-setup
```

**预期行为**：
- ✅ 识别项目类型
- ✅ 选择 CI 平台（GitHub Actions, GitLab CI）
- ✅ 生成配置文件
- ✅ 配置测试、构建、部署步骤

**预期输出**：

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install -r requirements-dev.txt

      - name: Run tests
        run: pytest --cov=src tests/

      - name: Upload coverage
        uses: codecov/codecov-action@v3

  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run linters
        run: |
          black --check .
          flake8 .
          mypy src/

  build:
    needs: [test, lint]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build Docker image
        run: docker build -t myapp:${{ github.sha }} .
```

#### deploy:setup-kubernetes-deployment

**测试**：

```
/deploy:setup-kubernetes-deployment
```

**预期行为**：
- ✅ 生成 Kubernetes manifests
- ✅ 配置 Deployment
- ✅ 配置 Service
- ✅ 配置 Ingress
- ✅ 配置 ConfigMap/Secret

#### deploy:rollback-deploy

**测试**：

```
/deploy:rollback-deploy v1.2.3
```

**预期行为**：
- ✅ 验证目标版本
- ✅ 执行回滚
- ✅ 验证回滚成功
- ✅ 通知团队

### 4. setup:* 配置命令

#### setup:setup-linting

**测试**：

```
/setup:setup-linting
```

**预期行为**：
- ✅ 检测项目语言
- ✅ 推荐 linter 工具
- ✅ 生成配置文件
- ✅ 添加到 CI

**预期输出**（Python 项目）：

```ini
# .flake8
[flake8]
max-line-length = 88
extend-ignore = E203, W503
exclude = .git,__pycache__,build,dist

# pyproject.toml
[tool.black]
line-length = 88
target-version = ['py311']

[tool.mypy]
python_version = "3.11"
strict = true
warn_return_any = true
warn_unused_configs = true

[tool.isort]
profile = "black"
line_length = 88
```

#### setup:setup-formatting

**测试**：

```
/setup:setup-formatting
```

**预期行为**：
- ✅ 配置代码格式化工具
- ✅ 添加 pre-commit hooks
- ✅ 格式化现有代码
- ✅ 更新文档

#### setup:setup-development-environment

**测试**：

```
/setup:setup-development-environment
```

**预期行为**：
- ✅ 生成开发环境文档
- ✅ 配置虚拟环境
- ✅ 安装依赖
- ✅ 设置环境变量

### 5. docs:* 文档命令

#### docs:generate-api-documentation

**测试**：

```
/docs:generate-api-documentation
```

**预期行为**：
- ✅ 扫描 API 端点
- ✅ 提取文档字符串
- ✅ 生成 OpenAPI/Swagger 规范
- ✅ 创建 API 文档网站

#### docs:create-architecture-documentation

**测试**：

```
/docs:create-architecture-documentation
```

**预期行为**：
- ✅ 分析项目结构
- ✅ 识别组件和依赖
- ✅ 生成架构图
- ✅ 编写架构文档

#### docs:migration-guide

**测试**：

```
/docs:migration-guide "从版本 1.x 升级到 2.x"
```

**预期行为**：
- ✅ 识别破坏性变更
- ✅ 提供迁移步骤
- ✅ 包含代码示例
- ✅ 列出兼容性问题

### 6. security:* 安全命令

#### security:security-audit

**测试**：

```
/security:security-audit
```

**预期行为**：
- ✅ 扫描依赖漏洞
- ✅ 检查代码安全问题
- ✅ 分析权限配置
- ✅ 生成安全报告

**预期输出**：

```markdown
# 安全审计报告

## 漏洞发现

### 高危 (1)
1. **SQL 注入风险**
   - 文件：src/api/users.py:45
   - 代码：`query = f"SELECT * FROM users WHERE id = {user_id}"`
   - 建议：使用参数化查询

### 中危 (3)
2. **硬编码凭证**
   - 文件：config/settings.py:12
   - 代码：`API_KEY = "sk-1234567890"`
   - 建议：使用环境变量

3. **不安全的随机数生成**
   - 文件：src/utils/token.py:8
   - 代码：`token = random.randint(1000, 9999)`
   - 建议：使用 secrets 模块

## 依赖漏洞

| 包名 | 版本 | 漏洞 | 严重程度 |
|------|------|------|---------|
| requests | 2.25.1 | CVE-2023-32681 | 高 |
| pillow | 8.3.2 | CVE-2023-44271 | 中 |

## 修复建议

1. 升级依赖：`pip install --upgrade requests pillow`
2. 修复代码安全问题（见上文）
3. 启用安全 headers
4. 配置 HTTPS
```

#### security:dependency-audit

**测试**：

```
/security:dependency-audit
```

**预期行为**：
- ✅ 扫描依赖漏洞（npm audit, pip-audit）
- ✅ 生成漏洞报告
- ✅ 建议修复版本
- ✅ 自动更新（可选）

### 7. performance:* 性能命令

#### performance:performance-audit

**测试**：

```
/performance:performance-audit
```

**预期行为**：
- ✅ 分析性能瓶颈
- ✅ 识别慢查询
- ✅ 检查资源使用
- ✅ 提供优化建议

#### performance:optimize-bundle-size

**测试**：

```
/performance:optimize-bundle-size
```

**预期行为**：
- ✅ 分析打包大小
- ✅ 识别大依赖
- ✅ 建议代码分割
- ✅ 优化配置

### 8. project:* 项目管理命令

#### project:init-project

**测试**：

```
/project:init-project my-app --type=fastapi
```

**预期行为**：
- ✅ 创建项目结构
- ✅ 生成配置文件
- ✅ 初始化 Git
- ✅ 创建 README

#### project:create-feature

**测试**：

```
/project:create-feature user-authentication
```

**预期行为**：
- ✅ 创建功能分支
- ✅ 生成功能模板
- ✅ 创建测试文件
- ✅ 更新文档

### 9. team:* 团队协作命令

#### team:standup-report

**测试**：

```
/team:standup-report
```

**预期行为**：
- ✅ 分析 Git commits
- ✅ 识别已完成工作
- ✅ 列出进行中任务
- ✅ 标识阻塞问题

#### team:sprint-planning

**测试**：

```
/team:sprint-planning
```

**预期行为**：
- ✅ 列出待规划任务
- ✅ 估算工作量
- ✅ 分配任务
- ✅ 设置 Sprint 目标

## 所有 Commands 测试清单

### dev 命令 (20+)

| Command | 测试状态 | 评分 | 备注 |
|---------|---------|------|------|
| dev:code-review | ✅ | 9/10 | 分析全面 |
| dev:refactor-code | ⬜ | - | 待测试 |
| dev:explain-code | ⬜ | - | 待测试 |
| dev:fix-issue | ⬜ | - | 待测试 |
| dev:debug-error | ⬜ | - | 待测试 |
| dev:remove-dead-code | ⬜ | - | 待测试 |
| dev:code-permutation-tester | ⬜ | - | 待测试 |

### test 命令 (10+)

| Command | 测试状态 | 评分 | 备注 |
|---------|---------|------|------|
| test:write-tests | ⬜ | - | 待测试 |
| test:test-coverage | ⬜ | - | 待测试 |
| test:e2e-setup | ⬜ | - | 待测试 |
| test:setup-load-testing | ⬜ | - | 待测试 |

### deploy 命令 (10+)

| Command | 测试状态 | 评分 | 备注 |
|---------|---------|------|------|
| deploy:prepare-release | ⬜ | - | 待测试 |
| deploy:ci-setup | ⬜ | - | 待测试 |
| deploy:setup-kubernetes-deployment | ⬜ | - | 待测试 |
| deploy:rollback-deploy | ⬜ | - | 待测试 |

### setup 命令 (15+)

| Command | 测试状态 | 评分 | 备注 |
|---------|---------|------|------|
| setup:setup-linting | ⬜ | - | 待测试 |
| setup:setup-formatting | ⬜ | - | 待测试 |
| setup:setup-development-environment | ⬜ | - | 待测试 |

### docs 命令 (5+)

| Command | 测试状态 | 评分 | 备注 |
|---------|---------|------|------|
| docs:generate-api-documentation | ⬜ | - | 待测试 |
| docs:create-architecture-documentation | ⬜ | - | 待测试 |

### security 命令 (5+)

| Command | 测试状态 | 评分 | 备注 |
|---------|---------|------|------|
| security:security-audit | ⬜ | - | 待测试 |
| security:dependency-audit | ⬜ | - | 待测试 |

### performance 命令 (5+)

| Command | 测试状态 | 评分 | 备注 |
|---------|---------|------|------|
| performance:performance-audit | ⬜ | - | 待测试 |
| performance:optimize-bundle-size | ⬜ | - | 待测试 |

## 问题排查

### 问题1：Command 找不到

**症状**：执行 `/namespace:command` 提示不存在

**排查**：
```bash
# 列出所有命令
find .claude/commands/ -name "*.md"

# 检查命名空间
ls .claude/commands/[namespace]/
```

### 问题2：Command 权限不足

**症状**：Command 需要权限但被拒绝

**解决**：
```json
// settings.json
{
  "permissions": {
    "commands": {
      "[command-name]": {
        "allow": ["Bash", "Write"]
      }
    }
  }
}
```

### 问题3：Command 执行失败

**症状**：Command 执行但报错

**排查**：
- 检查依赖是否安装
- 验证项目结构
- 查看日志输出

## 最佳实践

1. **使用命名空间组织命令**
2. **明确命令的输入输出**
3. **处理错误和边界情况**
4. **提供清晰的使用文档**
5. **定期测试所有命令**

---

**下一步**：测试所有 Commands，完成测试清单 ✓
