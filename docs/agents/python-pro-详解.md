# python-pro Agent 详解

<div align="center">

**Python 3.11+ 全栈开发专家**

**Python 3.11+ Full-Stack Development Expert**

⭐⭐⭐⭐⭐ 五星推荐 | From: awesome-claude-code-subagents

[简体中文](#简体中文) | [English](#english)

</div>

---

## 简体中文

### 🤖 Agent 简介

**python-pro** 是一个专精于 **Python 3.11+ 生态系统**的高级开发 Agent，拥有深厚的类型系统、异步编程、性能优化和现代 Python 最佳实践的专业知识。

**定位**：Python 开发的一站式专家，从 Web API 到系统工具，从数据科学到异步应用。

### 🎯 核心能力矩阵

| 能力领域 | 专精程度 | 关键技能 |
|---------|---------|---------|
| **类型系统** | ⭐⭐⭐⭐⭐ | TypeVar, Protocol, Generic, Literal, TypedDict |
| **异步编程** | ⭐⭐⭐⭐⭐ | asyncio, async/await, 任务组，异常处理 |
| **Web 框架** | ⭐⭐⭐⭐⭐ | FastAPI, Django, Flask, SQLAlchemy, Pydantic |
| **数据科学** | ⭐⭐⭐⭐ | Pandas, NumPy, Scikit-learn, Matplotlib |
| **测试** | ⭐⭐⭐⭐⭐ | pytest, fixtures, mocking, 属性测试 |
| **性能优化** | ⭐⭐⭐⭐ | cProfile, 算法优化, 缓存策略, Cython |
| **包管理** | ⭐⭐⭐⭐⭐ | Poetry, pip-tools, Docker, 依赖管理 |
| **安全** | ⭐⭐⭐⭐ | 输入验证, SQL 防注入, 密钥管理, OWASP |

### 🛠️ 工具权限

```yaml
tools: Read, Write, Edit, Bash, Glob, Grep
model: sonnet
```

**工具使用说明**：
- `Read/Write/Edit`: 读写 Python 代码文件
- `Bash`: 运行测试、安装依赖、执行脚本
- `Glob/Grep`: 搜索代码模式和文件

**模型选择**：
- 使用 `sonnet` - 平衡性能和成本
- 日常 Python 开发任务的最佳选择

### 📝 Prompt 核心要点

#### 1. 类型安全优先

```python
# ✅ python-pro 的代码风格
from typing import Generic, TypeVar, Protocol

T = TypeVar('T')

class Repository(Protocol[T]):
    def get(self, id: int) -> T | None: ...
    def save(self, item: T) -> T: ...

class UserRepository:
    def get(self, id: int) -> User | None:
        # Type-safe implementation
        pass
```

**特点**：
- 100% 类型注解覆盖（公共 API）
- Mypy strict mode 合规
- Protocol 实现鸭子类型

#### 2. 异步优先

```python
# ✅ python-pro 的异步模式
import asyncio
from contextlib import asynccontextmanager

@asynccontextmanager
async def db_transaction(session: AsyncSession):
    async with session.begin():
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise

async def process_users(user_ids: list[int]) -> list[User]:
    async with asyncio.TaskGroup() as tg:
        tasks = [tg.create_task(fetch_user(uid)) for uid in user_ids]
    return [task.result() for task in tasks]
```

**特点**：
- AsyncIO 优先于同步代码
- 正确的异步上下文管理器
- 任务组和异常处理

#### 3. Pythonic 惯用法

```python
# ✅ python-pro 的惯用法
from dataclasses import dataclass
from functools import cached_property

@dataclass(frozen=True, slots=True)
class User:
    id: int
    name: str
    email: str

    @cached_property
    def display_name(self) -> str:
        return f"{self.name} <{self.email}>"

# 列表推导式优于循环
active_users = [u for u in users if u.is_active]

# 生成器表达式节省内存
user_ids = (u.id for u in large_user_list)
```

#### 4. 测试驱动

```python
# ✅ python-pro 的测试风格
import pytest
from hypothesis import given, strategies as st

# 参数化测试
@pytest.mark.parametrize("input,expected", [
    ([], 0),
    ([1], 1),
    ([1, 2, 3], 6),
])
def test_sum_numbers(input, expected):
    assert sum_numbers(input) == expected

# 属性测试
@given(st.lists(st.integers()))
def test_sum_commutative(numbers):
    assert sum(numbers) == sum(reversed(numbers))

# Fixtures
@pytest.fixture
async def db_session():
    session = await create_session()
    yield session
    await session.close()
```

### 💡 使用场景

#### 场景 1: Web API 开发 ⭐⭐⭐⭐⭐

```
任务: 创建一个 FastAPI RESTful API

python-pro 的工作流:
1. 设计 Pydantic 模型（请求/响应）
2. 创建路由和依赖注入
3. 实现异步数据库操作
4. 添加输入验证和错误处理
5. 编写 pytest 测试（>90% 覆盖率）
6. 配置 OpenAPI 文档
7. 部署配置（Docker + Gunicorn）

输出:
  ✅ 完整的类型安全 API
  ✅ 自动 API 文档
  ✅ 高测试覆盖率
  ✅ 性能优化（< 50ms p95）
```

#### 场景 2: 数据处理脚本 ⭐⭐⭐⭐

```
任务: 处理大型 CSV 文件并生成报告

python-pro 的方法:
1. 使用 Pandas 读取数据（chunk 模式）
2. 类型安全的数据模型
3. 向量化操作代替循环
4. 生成可视化报告
5. 内存优化

代码示例:
```python
import pandas as pd
from pathlib import Path

def process_csv(file_path: Path, chunk_size: int = 10000) -> pd.DataFrame:
    """Process large CSV in chunks"""
    chunks = []
    for chunk in pd.read_csv(file_path, chunksize=chunk_size):
        # 向量化操作
        chunk['total'] = chunk['price'] * chunk['quantity']
        chunks.append(chunk)
    return pd.concat(chunks, ignore_index=True)
```
```

#### 场景 3: 代码优化 ⭐⭐⭐⭐⭐

```
任务: 优化慢速函数

python-pro 的流程:
1. 使用 cProfile 分析性能瓶颈
2. 识别算法复杂度问题
3. 应用优化策略:
   - 算法优化（O(n²) → O(n)）
   - 缓存（functools.lru_cache）
   - 数据结构优化（list → set）
   - 向量化（NumPy）
4. 基准测试验证改进
5. 保持代码可读性

成果:
  从 2.5s → 0.12s（95% 性能提升）
  内存使用减少 60%
```

### 🎬 配置建议

#### 在 CLAUDE.md 中使用

```markdown
## Python Development

When working on Python code:
- Always use the python-pro agent for Python-specific tasks
- Require type hints for all public APIs
- Target 90%+ test coverage with pytest
- Follow PEP 8 with black formatting
- Use asyncio for I/O-bound operations
```

#### 项目设置

```toml
# pyproject.toml
[tool.poetry]
name = "my-project"
python = "^3.11"

[tool.poetry.dependencies]
fastapi = "^0.104.0"
pydantic = "^2.5.0"

[tool.mypy]
strict = true
warn_return_any = true

[tool.pytest.ini_options]
asyncio_mode = "auto"
testpaths = ["tests"]
```

### ⚠️ 最佳实践

#### ✅ DO - python-pro 的风格

```python
# 1. 完整类型注解
def fetch_users(limit: int = 100) -> list[User]:
    """Fetch users with proper types"""
    pass

# 2. 使用 dataclass
from dataclasses import dataclass

@dataclass
class User:
    id: int
    name: str

# 3. 上下文管理器
with open('file.txt') as f:
    data = f.read()

# 4. 异步 I/O
async def fetch_data(url: str) -> bytes:
    async with httpx.AsyncClient() as client:
        response = await client.get(url)
        return response.content

# 5. 列表推导式
squares = [x**2 for x in range(10)]
```

#### ❌ DON'T - 避免的模式

```python
# ❌ 缺少类型注解
def process(data):  # 类型不明确
    return data

# ❌ 使用可变默认参数
def add_item(item, items=[]):  # 危险！
    items.append(item)
    return items

# ❌ 裸 except
try:
    risky_operation()
except:  # 太宽泛
    pass

# ❌ 同步 I/O（I/O密集型任务）
def fetch_all(urls):
    return [requests.get(url) for url in urls]  # 阻塞

# ❌ 手动循环（可向量化）
total = 0
for x in numbers:
    total += x
# 应该用: sum(numbers)
```

### 📊 代码质量标准

python-pro 交付的代码必须满足：

| 指标 | 要求 | 检查方法 |
|------|------|---------|
| **类型覆盖** | 100% (公共API) | `mypy --strict` |
| **测试覆盖** | > 90% | `pytest --cov` |
| **代码格式** | PEP 8 | `black` + `ruff` |
| **安全扫描** | 0 高危 | `bandit` |
| **性能** | 基准达标 | `pytest-benchmark` |
| **文档** | 所有公共函数 | Google 风格 |

### 🔗 与其他 Agents 协作

| Agent | 协作场景 | 分工 |
|-------|---------|------|
| **fullstack-developer** | 全栈项目 | python-pro 负责后端 API |
| **data-scientist** | ML 项目 | python-pro 负责生产化代码 |
| **devops-engineer** | 部署 | python-pro 写代码，devops 部署 |
| **code-reviewer** | 代码审查 | python-pro 实现，reviewer 审查 |
| **test-driven-development** (skill) | TDD | 配合使用，先写测试 |

### 🆚 vs 通用开发 Agent

| 特性 | python-pro | 通用 Agent |
|------|-----------|-----------|
| **Python 知识** | 深度专精 | 基础 |
| **类型系统** | 高级应用 | 简单类型 |
| **异步编程** | 最佳实践 | 基本用法 |
| **性能优化** | 专业级 | 一般 |
| **生态系统** | 完整了解 | 部分了解 |
| **代码质量** | 企业级 | 可用级 |

### ✨ 为什么推荐

1. **类型安全** 🛡️
   - 100% 类型覆盖
   - Mypy strict mode
   - 减少运行时错误

2. **现代 Python** 🚀
   - Python 3.11+ 特性
   - 异步优先
   - 性能优化

3. **生产就绪** 💼
   - 企业级代码质量
   - 完整测试覆盖
   - 安全最佳实践

4. **深度专精** 🎓
   - 精通 Python 生态
   - FastAPI, Django, Pandas 等
   - 性能优化技巧

5. **可维护性** 📚
   - Pythonic 惯用法
   - 清晰的代码结构
   - 完整的文档

### 📚 技能矩阵详解

#### Web 开发

- **FastAPI**: 现代异步 API 框架
- **Django**: 全功能 Web 框架
- **Flask**: 轻量级微服务
- **SQLAlchemy**: ORM 和数据库抽象
- **Pydantic**: 数据验证和设置管理

#### 数据科学

- **Pandas**: 数据操作和分析
- **NumPy**: 数值计算
- **Scikit-learn**: 机器学习
- **Matplotlib/Seaborn**: 数据可视化
- **Jupyter**: 交互式开发

#### 测试

- **pytest**: 测试框架
- **Hypothesis**: 属性测试
- **pytest-cov**: 覆盖率报告
- **pytest-mock**: Mock 和 Patch
- **pytest-asyncio**: 异步测试

---

## English

### 🤖 Agent Overview

**python-pro** is an advanced development agent specialized in the **Python 3.11+ ecosystem**, with deep expertise in type systems, asynchronous programming, performance optimization, and modern Python best practices.

**Positioning**: One-stop Python development expert, from Web APIs to system tools, from data science to async applications.

### 🎯 Core Capabilities

See Chinese section above for the complete capability matrix.

### 🛠️ Tool Permissions

See Chinese section above for tool usage details.

### 📝 Prompt Key Points

See Chinese section above for code examples and best practices.

### 💡 Usage Scenarios

See Chinese section above for detailed scenarios and examples.

### ⚠️ Best Practices

See Chinese section above for DOs and DON'Ts.

### ✨ Why Recommended

1. **Type Safety** 🛡️ - 100% type coverage with mypy strict
2. **Modern Python** 🚀 - Python 3.11+ features, async-first
3. **Production Ready** 💼 - Enterprise-grade code quality
4. **Deep Expertise** 🎓 - Mastery of Python ecosystem
5. **Maintainability** 📚 - Pythonic idioms and clear structure

---

**Made with ❤️ for Python developers**
