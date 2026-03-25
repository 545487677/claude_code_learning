# test Skill 详解

<div align="center">

**智能检测和运行项目测试**

**Intelligent Test Detection and Execution**

⭐⭐⭐⭐⭐ 开发者必备 | 自创 Skill

[简体中文](#简体中文) | [English](#english)

</div>

---

## 简体中文

### 📖 Skill 简介

**test** 是一个**智能测试执行 Skill**，自动检测项目的测试框架、定位测试文件、运行测试并报告结果，无需手动配置。

**核心价值**：一个命令，适配所有测试框架。

### 🎯 核心原则

```
测试应该：
- 自动检测框架 ✅
- 智能找到测试 ✅
- 清晰报告结果 ✅

Not:
  手动查找测试命令 ❌
  记忆不同框架语法 ❌
```

### ⚙️ 工作原理

```
触发时:
1. 检测测试框架
   Python → pytest, unittest
   JavaScript → jest, mocha, vitest
   Go → go test
   Rust → cargo test
   等等...

2. 定位测试文件
   - 扫描 test/, tests/, __tests__/
   - 匹配 test_*.py, *.test.js 等模式

3. 运行测试
   - 使用框架原生命令
   - 传递必要参数

4. 报告结果
   - 成功/失败统计
   - 失败用例详情
   - 覆盖率（如可用）
```

### 💡 使用示例

#### 示例 1: 自动检测 Python 测试

**输入**：
```
运行项目测试
```

或

```
/test
```

**检测过程**：
```bash
# 检查是否有 pytest
$ which pytest
/usr/bin/pytest

# 查找测试文件
$ find . -name "test_*.py" -o -name "*_test.py"
./tests/test_api.py
./tests/test_utils.py

# 运行 pytest
$ pytest tests/
```

**输出**：
```
✅ 测试框架：pytest
✅ 发现测试文件：2 个

运行结果：
============================= test session starts ==============================
collected 25 items

tests/test_api.py ..........                                             [ 40%]
tests/test_utils.py...............                                       [100%]

============================== 25 passed in 1.23s ===============================

✅ 25/25 passed
```

#### 示例 2: JavaScript 项目测试

**输入**：
```
运行测试
```

**检测过程**：
```bash
# 检查 package.json
$ cat package.json | jq '.scripts.test'
"jest"

# 查找测试文件
$ find src -name "*.test.js" -o -name "*.spec.js"
src/api.test.js
src/utils.test.js
```

**输出**：
```
✅ 测试框架：jest
✅ 发现测试文件：2 个

PASS  src/api.test.js
PASS  src/utils.test.js

Test Suites: 2 passed, 2 total
Tests:       18 passed, 18 total

✅ 18/18 passed
```

#### 示例 3: 运行特定测试

**输入**：
```
运行 test_api.py 的测试
```

**行为**：
```bash
$ pytest tests/test_api.py -v

tests/test_api.py::test_get_user PASSED
tests/test_api.py::test_create_user PASSED
tests/test_api.py::test_update_user PASSED
tests/test_api.py::test_delete_user PASSED

✅ 4/4 passed
```

#### 示例 4: 测试失败处理

**输入**：
```
运行测试
```

**输出**：
```
✅ 测试框架：pytest
⚠️  发现失败：2/25 tests failed

FAILED tests/test_api.py::test_login - AssertionError
FAILED tests/test_utils.py::test_validate - ValueError

详细错误：

tests/test_api.py::test_login
    def test_login():
        response = api.login("user", "wrong_password")
>       assert response.status == 200
E       assert 401 == 200

tests/test_utils.py::test_validate
    def test_validate(self):
>       assert validate_email("invalid")
E       ValueError: Invalid email format

❌ 2 个测试失败
建议：检查 test_api.py:42 和 test_utils.py:15
```

#### 示例 5: 没有测试时的处理

**输入**：
```
运行测试
```

**行为**：
```
⚠️  未找到测试文件

检查了以下位置：
- ./tests/
- ./test/
- ./*_test.py
- ./*.test.js

建议：
1. 创建测试目录：mkdir tests
2. 添加第一个测试文件
3. 或者指定测试位置

需要帮助设置测试吗？
```

### 🚨 支持的测试框架

| 语言 | 框架 | 检测方式 |
|------|------|---------|
| **Python** | pytest | `which pytest` |
| | unittest | Python 内置 |
| **JavaScript** | jest | package.json scripts |
| | mocha | package.json scripts |
| | vitest | vite.config.js |
| **Go** | go test | `go.mod` 存在 |
| **Rust** | cargo test | `Cargo.toml` 存在 |
| **Ruby** | rspec | `Gemfile` 包含 rspec |
| **Java** | JUnit | `pom.xml` 或 `build.gradle` |

### 📋 最佳实践

#### 1. 组织测试文件
```
✅ 推荐结构：
project/
├── src/
│   ├── api.py
│   └── utils.py
└── tests/
    ├── test_api.py
    └── test_utils.py

✅ 命名约定：
- Python: test_*.py or *_test.py
- JavaScript: *.test.js or *.spec.js
- Go: *_test.go
```

#### 2. 快速测试反馈
```
# 只运行失败的测试
pytest --lf

# 并行运行测试
pytest -n auto

# 监听模式（持续测试）
jest --watch
```

#### 3. 测试覆盖率
```
# Python
pytest --cov=src tests/

# JavaScript
jest --coverage

输出：
Coverage: 85%
Missing: src/api.py lines 42-48
```

### 🔗 相关 Skills/Agents/Commands

| 组件 | 关系 | 用途 |
|------|------|------|
| **test-driven-development** | 配合 | TDD 工作流 |
| **verification-before-completion** | 配合 | 完成前验证 |
| **test:write-tests** (Command) | 配合 | 生成测试代码 |
| **test:test-coverage** (Command) | 配合 | 覆盖率分析 |

### ✨ 为什么推荐

1. **零配置** 🎯
   - 自动检测框架
   - 无需记忆命令
   - 适配多种语言

2. **快速反馈** ⚡
   - 一个命令运行
   - 清晰的结果报告
   - 失败时显示详情

3. **智能处理** 🧠
   - 找不到测试时提示
   - 建议修复方案
   - 支持指定文件

4. **开发效率** 🚀
   - 减少上下文切换
   - 统一的测试接口
   - 加速开发流程

### 🆚 vs 手动运行

| 维度 | test Skill | 手动运行 |
|------|-----------|---------|
| **便捷性** | 一个命令 | 需要记忆语法 |
| **适配性** | 自动检测 | 手动配置 |
| **错误处理** | 智能提示 | 需要查文档 |
| **效率** | 高 | 低 |

### 📝 触发方式

- "运行项目测试"
- "运行测试"
- "test"
- "/test"
- "跑一下测试"
- "执行测试"

### ⚠️ 注意事项

1. **首次使用**：
   - 确保测试框架已安装
   - 遵循标准目录结构

2. **CI/CD 集成**：
   - 可配合 pre-commit hook
   - 可在 CI 中使用

3. **性能**：
   - 大型项目考虑并行测试
   - 使用缓存加速

---

## English

### 📖 Skill Overview

**test** is an **intelligent test execution skill** that automatically detects testing frameworks, locates test files, runs tests, and reports results without manual configuration.

**Core Value**: One command, works with all frameworks.

### ✨ Why Recommended

1. **Zero Configuration** 🎯 - Auto-detect frameworks
2. **Fast Feedback** ⚡ - One command to run
3. **Intelligent Handling** 🧠 - Smart suggestions when no tests found
4. **Development Efficiency** 🚀 - Accelerate workflow

---

**Made with ❤️ for developers who value efficiency**
