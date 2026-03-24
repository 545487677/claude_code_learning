# writing-plans Skill 详解

<div align="center">

**详尽实施计划的编写艺术**

**The Art of Writing Comprehensive Implementation Plans**

⭐⭐⭐⭐⭐ 必备 Skill | From: Superpowers

[简体中文](#简体中文) | [English](#english)

</div>

---

## 简体中文

### 📖 Skill 简介

**writing-plans** 是一个**实施计划编写 Skill**，教你如何将设计文档转化为详尽的、一步一步的实施计划，假设执行者对代码库零了解，需要你提供所有细节。

**核心理念**：计划应该详尽到让一个技术熟练但对你的代码库和领域完全陌生的工程师也能执行。

### 🎯 何时使用

✅ **必须使用的场景**：
- 有了规格或需求文档（来自 brainstorming）
- 准备实施多步骤任务时
- 需要将大任务分解为小任务
- 准备委托给其他工程师或 Agent

❌ **不需要使用的场景**：
- 单步骤的简单任务
- 探索性编程（没有明确需求）
- 正在做的就是编写计划本身

### ⚙️ 工作原理

#### 核心流程

```
输入: 设计文档（来自 brainstorming）
      ↓
   范围检查
      ↓
   文件结构设计
      ↓
   任务分解（2-5 分钟/任务）
      ↓
   详细步骤编写
      ↓
   计划审查循环
      ↓
   执行方式选择
      ↓
输出: 详尽的实施计划（.md 文件）
```

#### 关键原则

**原则 1: 假设零上下文**
```
执行者只知道:
  ✅ 基本编程知识
  ✅ 技术栈（Python, TypeScript 等）

执行者不知道:
  ❌ 你的代码库结构
  ❌ 你的命名约定
  ❌ 你的测试框架配置
  ❌ 你的领域知识
```

**原则 2: 一切都要明确**
```
❌ 错误: "添加验证"
✅ 正确:
```python
def validate_email(email: str) -> bool:
    if '@' not in email:
        raise ValueError("Email must contain @")
    return True
```
```

**原则 3: 小任务粒度**
```
每个步骤 = 2-5 分钟
- 写测试 - 1 步
- 运行测试 - 1 步
- 写代码 - 1 步
- 再运行测试 - 1 步
- 提交 - 1 步
```

**原则 4: DRY, YAGNI, TDD**
```
DRY (Don't Repeat Yourself):
  - 避免重复代码
  - 提取共同模式

YAGNI (You Aren't Gonna Need It):
  - 只实现需要的功能
  - 不要添加"将来可能需要"的东西

TDD (Test-Driven Development):
  - 先写测试
  - 再写实现
  - 每个任务都遵循
```

### 💡 使用示例

#### 示例 1: 简单功能的计划

```markdown
# 用户邮箱验证功能实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 添加用户邮箱验证功能，防止无效邮箱注册

**Architecture:** 在 User 模型中添加 validate_email 方法，在注册时调用

**Tech Stack:** Python 3.11+, pytest, re 模块

---

## 文件结构

**将创建的文件**:
- `tests/test_user_validation.py` - 邮箱验证测试

**将修改的文件**:
- `src/models/user.py:45-60` - 添加 validate_email 方法
- `src/api/auth.py:123-130` - 在注册端点调用验证

---

### 任务 1: 邮箱验证测试

**Files:**
- Create: `tests/test_user_validation.py`

- [ ] **Step 1: 写失败的测试**

```python
import pytest
from src.models.user import User

def test_email_validation_valid():
    """Valid email should not raise error"""
    user = User(email="test@example.com", name="Test")
    assert user.email == "test@example.com"

def test_email_validation_invalid_no_at():
    """Email without @ should raise ValueError"""
    with pytest.raises(ValueError, match="Email must contain @"):
        User(email="invalid-email", name="Test")

def test_email_validation_invalid_no_domain():
    """Email without domain should raise ValueError"""
    with pytest.raises(ValueError, match="Email must contain domain"):
        User(email="test@", name="Test")
```

- [ ] **Step 2: 运行测试确认失败**

Run: `pytest tests/test_user_validation.py -v`

Expected output:
```
FAILED test_email_validation_valid - NameError: User has no __init__
FAILED test_email_validation_invalid_no_at - NameError: ...
FAILED test_email_validation_invalid_no_domain - NameError: ...
```

✓ 确认测试失败且原因正确

- [ ] **Step 3: 实现验证逻辑**

Modify: `src/models/user.py`

在 User 类中添加：

```python
class User:
    def __init__(self, email: str, name: str):
        self.email = self._validate_email(email)
        self.name = name

    def _validate_email(self, email: str) -> str:
        """验证邮箱格式"""
        if '@' not in email:
            raise ValueError("Email must contain @")

        parts = email.split('@')
        if len(parts) != 2 or not parts[1]:
            raise ValueError("Email must contain domain")

        return email
```

- [ ] **Step 4: 运行测试确认通过**

Run: `pytest tests/test_user_validation.py -v`

Expected output:
```
PASSED test_email_validation_valid
PASSED test_email_validation_invalid_no_at
PASSED test_email_validation_invalid_no_domain

=================== 3 passed in 0.12s ===================
```

✓ 所有测试通过

- [ ] **Step 5: 提交**

```bash
git add tests/test_user_validation.py src/models/user.py
git commit -m "feat: add email validation to User model

- Validates email contains @ and domain
- Raises ValueError for invalid formats
- 100% test coverage"
```

---

### 任务 2: 在注册端点使用验证

**Files:**
- Modify: `src/api/auth.py:123-130`
- Modify: `tests/test_auth_api.py`

- [ ] **Step 1: 写失败的测试**

Add to `tests/test_auth_api.py`:

```python
def test_register_invalid_email():
    """Registration with invalid email should return 400"""
    response = client.post('/auth/register', json={
        'email': 'invalid-email',
        'password': 'password123',
        'name': 'Test'
    })
    assert response.status_code == 400
    assert 'Email must contain @' in response.json()['error']
```

- [ ] **Step 2: 运行测试确认失败**

Run: `pytest tests/test_auth_api.py::test_register_invalid_email -v`

Expected: FAILED (当前返回 200 或 500)

- [ ] **Step 3: 修改注册端点**

Modify `src/api/auth.py`:

```python
@router.post('/register')
def register(email: str, password: str, name: str):
    try:
        user = User(email=email, name=name)  # 会触发验证
        # ... 其余注册逻辑
    except ValueError as e:
        return JSONResponse(
            status_code=400,
            content={'error': str(e)}
        )
```

- [ ] **Step 4: 运行测试确认通过**

Run: `pytest tests/test_auth_api.py::test_register_invalid_email -v`

Expected: PASSED

- [ ] **Step 5: 运行完整测试套件**

Run: `pytest`

Expected: 所有测试通过

- [ ] **Step 6: 提交**

```bash
git add src/api/auth.py tests/test_auth_api.py
git commit -m "feat: integrate email validation in registration

- Returns 400 for invalid email formats
- Provides clear error messages
- All tests passing"
```

---

## 验证清单

完成所有任务后：

- [ ] 所有测试通过: `pytest`
- [ ] Linter 无错误: `ruff check src/`
- [ ] 类型检查通过: `mypy src/`
- [ ] 代码覆盖率 > 90%: `pytest --cov`

## 文档

- [ ] 更新 API 文档说明新的验证规则
- [ ] 更新 README 如果有公共 API 变更
```

#### 示例 2: 复杂功能的文件结构设计

```markdown
# JWT 认证系统实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development

**Goal:** 实现完整的 JWT 认证系统

**Architecture:**
- Token 生成和验证独立服务
- 中间件处理认证检查
- 数据库存储刷新 token

**Tech Stack:** FastAPI, PyJWT, PostgreSQL, Redis (可选)

---

## 文件结构

**按职责分解**（不是按技术层）

### 核心认证模块
```
src/auth/
├── token.py          # Token 生成和验证（JWT 逻辑）
├── middleware.py     # 认证中间件
├── dependencies.py   # FastAPI 依赖注入
└── exceptions.py     # 认证相关异常
```

### 数据模型
```
src/models/
├── user.py          # User 模型（已存在，会修改）
└── refresh_token.py # RefreshToken 模型（新建）
```

### API 端点
```
src/api/
├── auth.py          # 认证端点（login, refresh, logout）
└── protected.py     # 受保护的示例端点
```

### 测试
```
tests/
├── test_token.py           # Token 逻辑测试
├── test_auth_middleware.py # 中间件测试
├── test_auth_api.py        # API 端点测试
└── test_integration.py     # 端到端测试
```

**文件大小目标**:
- 每个文件 < 200 行
- 单一职责
- 清晰的接口

**这种结构的好处**:
- ✅ 每个文件可以独立测试
- ✅ 改变一起的代码放在一起
- ✅ 易于理解和维护
- ✅ 符合 SOLID 原则

---

### 任务 1: Token 生成器

**Files:**
- Create: `src/auth/token.py`
- Create: `src/auth/exceptions.py`
- Create: `tests/test_token.py`

[详细步骤...]

### 任务 2: RefreshToken 模型

**Files:**
- Create: `src/models/refresh_token.py`
- Create: `tests/test_refresh_token.py`

[详细步骤...]

[... 其余任务]
```

#### 示例 3: 重构任务的计划

```markdown
# 大组件重构计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development

**Goal:** 将 450 行的 UserDashboard 组件拆分为多个小组件

**Architecture:** Hook 拆分策略 - 保持组件 API 兼容

**当前问题**:
- UserDashboard.tsx (450 行)
  - 职责: 数据获取 + 状态管理 + UI 渲染 + 业务逻辑
  - 违反单一职责原则
  - 难以测试和维护

**目标结构**:
```
components/
├── UserDashboard.tsx        # 主组件（100 行）- 组装
├── hooks/
│   ├── useUserData.ts      # 数据获取（50 行）
│   ├── useUserStats.ts     # 统计计算（40 行）
│   └── useUserFilters.ts   # 过滤逻辑（30 行）
└── partials/
    ├── UserHeader.tsx      # 头部（60 行）
    ├── UserStats.tsx       # 统计卡片（70 行）
    └── UserTable.tsx       # 数据表格（100 行）
```

**Tech Stack:** React 18+, TypeScript, React Query

---

### 任务 1: 提取数据获取 Hook

**Rationale:** 数据获取是独立关注点，可以单独测试

**Files:**
- Create: `src/hooks/useUserData.ts`
- Create: `tests/hooks/useUserData.test.ts`

- [ ] **Step 1: 写 Hook 的测试**

```typescript
import { renderHook, waitFor } from '@testing-library/react'
import { useUserData } from '@/hooks/useUserData'

describe('useUserData', () => {
  it('fetches user data successfully', async () => {
    const { result } = renderHook(() => useUserData('user-123'))

    await waitFor(() => expect(result.current.isLoading).toBe(false))

    expect(result.current.data).toEqual({
      id: 'user-123',
      name: 'Test User',
      // ...
    })
  })
})
```

- [ ] **Step 2: 实现 Hook**

```typescript
import { useQuery } from '@tanstack/react-query'

export function useUserData(userId: string) {
  return useQuery({
    queryKey: ['user', userId],
    queryFn: () => fetchUser(userId),
  })
}
```

- [ ] **Step 3: 在原组件中替换**

Before:
```typescript
const UserDashboard = ({ userId }) => {
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchUser(userId).then(data => {
      setUser(data)
      setLoading(false)
    })
  }, [userId])

  // ... 400 more lines
}
```

After:
```typescript
const UserDashboard = ({ userId }) => {
  const { data: user, isLoading } = useUserData(userId)

  // ... rest of component
}
```

- [ ] **Step 4: 验证没有破坏功能**

Run: `npm test UserDashboard`
Expected: 所有现有测试仍然通过

- [ ] **Step 5: 提交这一步**

```bash
git add src/hooks/useUserData.ts tests/hooks/useUserData.test.ts src/components/UserDashboard.tsx
git commit -m "refactor: extract useUserData hook

- Separates data fetching concern
- Makes data fetching testable
- Reduces UserDashboard from 450 to 420 lines
- All existing tests still passing"
```

[... 继续其余任务，每次只重构一个部分]
```

### 🎬 计划文档结构

#### 必需的文件头

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [一句话描述目标]

**Architecture:** [2-3 句话描述方法]

**Tech Stack:** [关键技术/库]

---
```

#### 任务结构模板

````markdown
### Task N: [组件名称]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

### ⚠️ 最佳实践

#### ✅ DO

1. **提供确切的文件路径**
   ```
   ✅ src/models/user.py:45-60
   ✅ tests/test_user.py
   ❌ "在 user 文件中"
   ```

2. **包含完整代码**
   ```
   ✅ 完整的函数实现
   ❌ "添加验证逻辑"
   ```

3. **指定确切命令**
   ```
   ✅ pytest tests/test_user.py::test_email -v
   ❌ "运行测试"
   ```

4. **预期输出**
   ```
   ✅ Expected: FAILED with "Email must contain @"
   ❌ Expected: "测试会失败"
   ```

5. **频繁提交**
   ```
   ✅ 每个任务都提交
   ❌ 完成所有任务后再提交
   ```

#### ❌ DON'T

1. **模糊的指令**
   ```
   ❌ "添加一些验证"
   ❌ "修复这个问题"
   ❌ "改进性能"
   ```

2. **省略测试步骤**
   ```
   ❌ 跳过"运行测试验证失败"
   ❌ 假设测试会通过
   ```

3. **大任务**
   ```
   ❌ 一个任务 > 30 分钟
   ✅ 拆分为多个 5 分钟任务
   ```

4. **混合关注点**
   ```
   ❌ 在一个任务中既添加功能又重构
   ✅ 分开为两个任务
   ```

### 📊 计划审查循环

```
编写完整计划
    ↓
调用 plan-document-reviewer 子代理
    ↓
是否有问题？
    ├─ 是 → 修复问题 → 重新审查
    └─ 否 → 批准 → 执行选择
```

**审查指南**：
- 同一个写计划的 agent 修复它（保持上下文）
- 如果循环 > 3 次，向人类寻求指导
- 审查者是建议性的 - 如果你认为反馈不正确可以解释分歧

### 🎯 执行方式选择

计划保存后，提供选择：

```markdown
**Plan complete and saved to `docs/superpowers/plans/<filename>.md`. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?**
```

**如果选择 Subagent-Driven**:
- **REQUIRED SUB-SKILL**: Use superpowers:subagent-driven-development
- 每个任务一个新的 subagent + 两阶段审查

**如果选择 Inline Execution**:
- **REQUIRED SUB-SKILL**: Use superpowers:executing-plans
- 批量执行，设置检查点供审查

### 🔗 相关 Skills

| Skill | 关系 | 用途 |
|-------|------|------|
| **brainstorming** | 之前 | 生成设计文档 |
| **using-git-worktrees** | 开始前 | 创建隔离工作空间 |
| **subagent-driven-development** | 执行时 | 推荐的执行方式 |
| **test-driven-development** | 贯穿 | 每个任务都遵循 TDD |
| **verification-before-completion** | 每步 | 验证每个步骤 |

### ✨ 为什么推荐

1. **降低认知负担** 🧠
   - 执行者不需要思考"下一步做什么"
   - 一切都写清楚了
   - 减少决策疲劳

2. **可预测的进度** 📈
   - 小任务粒度可以准确估算
   - 容易跟踪进度
   - 容易在中途暂停和恢复

3. **质量保证** ✅
   - 每步都有验证
   - TDD 贯穿始终
   - 频繁提交保护进度

4. **知识传递** 📚
   - 计划本身是文档
   - 新人可以跟着学习
   - 保留决策理由

5. **Agent 友好** 🤖
   - 详尽的指令适合 AI 执行
   - checkbox 语法便于跟踪
   - 可以自动化执行

### 🆚 vs 模糊计划

| 维度 | writing-plans | 模糊计划 |
|------|--------------|---------|
| **详细程度** | 完整代码示例 | "添加功能" |
| **执行者理解** | 无需上下文 | 需要大量上下文 |
| **任务粒度** | 2-5 分钟 | 小时级 |
| **可追踪性** | 高（checkbox） | 低 |
| **适合 Agent** | 是 | 否 |
| **返工率** | 低 | 高 |

---

## English

### 📖 Skill Overview

**writing-plans** is an **implementation plan writing skill** that teaches you how to transform design documents into comprehensive, step-by-step implementation plans, assuming the executor has zero context about your codebase.

**Core Philosophy**: Plans should be detailed enough for a skilled engineer who knows nothing about your codebase or domain to execute.

### 🎯 When to Use

See Chinese section above for use cases.

### ⚙️ How It Works

See Chinese section above for the core workflow and key principles.

### 💡 Usage Examples

See Chinese section above for 3 detailed examples:
1. Simple feature plan
2. Complex feature with file structure design
3. Refactoring task plan

### ⚠️ Best Practices

See Chinese section above for DOs and DON'Ts.

### ✨ Why Recommended

1. **Reduce Cognitive Load** 🧠 - Everything is spelled out
2. **Predictable Progress** 📈 - Small tasks, easy tracking
3. **Quality Assurance** ✅ - Verification at every step
4. **Knowledge Transfer** 📚 - Plan itself is documentation
5. **Agent Friendly** 🤖 - Detailed instructions for AI execution

---

**Made with ❤️ for plan-driven developers**
