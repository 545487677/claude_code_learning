# systematic-debugging Skill 详解

<div align="center">

**科学调试的四阶段方法**

**Four-Phase Scientific Debugging Method**

⭐⭐⭐⭐⭐ 必备 Skill | From: Superpowers

[简体中文](#简体中文) | [English](#english)

</div>

---

## 简体中文

### 📖 Skill 简介

**systematic-debugging** 是一个**系统化调试流程 Skill**，通过严格的四阶段方法，确保你总是先找到根本原因，再尝试修复，而不是随机猜测和打补丁。

**铁律**：没有完成根因调查就不能尝试修复。

### 🎯 何时使用

✅ **必须使用的场景**：
- 测试失败
- 生产环境 Bug
- 意外的行为
- 性能问题
- 构建失败
- 集成问题

**特别是当**：
- 时间紧迫（紧急情况让猜测很诱人）
- "只是快速修复"看起来很明显
- 你已经尝试了多次修复
- 之前的修复没有奏效
- 你并不完全理解问题

**不要跳过**：
- 问题看起来很简单（简单的 bug 也有根因）
- 你很着急（匆忙只会导致返工）
- 经理要求立即修复（系统化比盲目尝试更快）

### ⚙️ 工作原理

#### 四阶段流程

你**必须**完成每个阶段才能进入下一个阶段。

```
阶段 1: 根因调查 🔍
  └─ 仔细阅读错误信息
  └─ 稳定复现问题
  └─ 检查最近的更改
  └─ 收集多组件系统的证据
  └─ 跟踪数据流

阶段 2: 模式分析 🔎
  └─ 找到可工作的示例
  └─ 与参考实现对比
  └─ 识别差异
  └─ 理解依赖关系

阶段 3: 假设和测试 🧪
  └─ 形成单一假设
  └─ 最小化测试
  └─ 验证后再继续
  └─ 不懂时承认不懂

阶段 4: 实施 🛠️
  └─ 创建失败的测试用例
  └─ 实现单一修复
  └─ 验证修复
  └─ 如果 3 次以上修复失败 → 质疑架构
```

#### 关键原则

**原则 1: 证据优先**
```
❌ 错误："我觉得是 X 的问题"
✅ 正确："根据错误日志第 42 行，X 返回了 null"
```

**原则 2: 单变量测试**
```
❌ 错误：同时修改 3 个地方看看能不能解决
✅ 正确：只修改 1 个地方，验证，再继续
```

**原则 3: 测试先行**
```
❌ 错误：修复 bug，然后手动验证
✅ 正确：先写失败的测试，修复，测试通过
```

**原则 4: 3 次失败规则**
```
如果尝试了 3 次修复都失败：
  → 停止！
  → 这不是假设错误，是架构问题
  → 与团队讨论是否需要重构
```

### 💡 使用示例

#### 示例 1: 测试失败调试

```
问题: 测试套件中 1 个测试失败

❌ 错误的做法:
Claude: [看到测试失败]
      "看起来是这里的逻辑有问题，让我改一下"
      [修改代码]
      "应该可以了"

✅ 正确的做法 (systematic-debugging):

阶段 1: 根因调查
-------------------
- [ ] 仔细阅读错误信息
```bash
$ pytest tests/test_user.py -v
FAILED tests/test_user.py::test_login
  AssertionError: assert None is not None
  > user = authenticate(email, password)
  E assert None is not None
```

- [ ] 稳定复现
```bash
$ pytest tests/test_user.py::test_login -v
# 每次都失败，稳定复现 ✓
```

- [ ] 检查最近更改
```bash
$ git log --oneline -5
a1b2c3d Refactor authentication module
# ← 可疑！
```

- [ ] 跟踪数据流
```python
# 在 authenticate() 中添加日志
def authenticate(email, password):
    print(f"DEBUG: email={email}, password={password}")
    user = db.query(User).filter_by(email=email).first()
    print(f"DEBUG: user={user}")  # ← 输出 None！
    ...
```

**根因发现**: db.query 返回 None，因为最近的重构改变了数据库连接方式

阶段 2: 模式分析
-------------------
- [ ] 找到可工作的示例
```python
# 在其他模块找到正确的 db 使用方式
def get_post(id):
    with db.session() as session:  # ← 使用了上下文管理器
        return session.query(Post).get(id)
```

- [ ] 识别差异
```python
# 旧代码（现在的 bug）
user = db.query(User).filter_by(email=email).first()

# 正确的新方式
with db.session() as session:
    user = session.query(User).filter_by(email=email).first()
```

阶段 3: 假设和测试
-------------------
- [ ] 形成假设
```
假设: authenticate() 没有使用新的 session 上下文管理器，
     导致查询在没有 session 的情况下执行，返回 None
```

- [ ] 最小化测试
```python
# 只修改 authenticate() 的数据库查询部分
def authenticate(email, password):
    with db.session() as session:  # ← 唯一的更改
        user = session.query(User).filter_by(email=email).first()
        ...
```

- [ ] 验证
```bash
$ pytest tests/test_user.py::test_login -v
PASSED ✓
```

阶段 4: 实施
-------------------
- [ ] 创建回归测试
```python
def test_authenticate_with_new_session():
    """Regression test for session context manager"""
    user = authenticate("test@example.com", "password123")
    assert user is not None
    assert user.email == "test@example.com"
```

- [ ] 验证测试的红绿循环
```bash
# 还原修复
$ git stash
$ pytest tests/test_user.py::test_authenticate_with_new_session
FAILED ✓ (确认测试会失败)

# 重新应用修复
$ git stash pop
$ pytest tests/test_user.py::test_authenticate_with_new_session
PASSED ✓ (确认测试通过)
```

- [ ] 运行完整测试套件
```bash
$ pytest
=================== 127 passed in 3.42s ===================
✓ 没有破坏其他测试
```

- [ ] 提交
```bash
git add src/auth.py tests/test_user.py
git commit -m "fix: use session context manager in authenticate()

Root cause: Recent db refactor introduced session management,
but authenticate() wasn't updated to use new context manager.

Regression test added to prevent future issues."
```

总耗时: 15 分钟
成功率: 100%
```

#### 示例 2: 多组件系统调试

```
问题: CI 中的签名步骤失败，但本地可以工作

❌ 错误的做法:
"可能是密钥的问题，让我检查一下 secrets"
[修改 secrets 配置]
"应该修好了"
[提交，仍然失败]
"可能是权限问题，让我改一下权限"
[修改权限]
[提交，仍然失败]
"..."

✅ 正确的做法 (systematic-debugging):

阶段 1: 根因调查 - 多组件证据收集
-------------------

系统有多层:
  CI Workflow → Build Script → Signing Script → Actual Signing

在提出修复之前，添加诊断工具:

```yaml
# .github/workflows/build.yml
- name: Debug Layer 1 - Secrets
  run: |
    echo "=== Secrets in workflow ==="
    echo "IDENTITY: ${IDENTITY:+SET}${IDENTITY:-UNSET}"
    echo "P12: ${P12_BASE64:+SET}${P12_BASE64:-UNSET}"

- name: Debug Layer 2 - Build env
  run: |
    cd scripts/
    ./build.sh --debug

- name: Debug Layer 3 - Signing env
  run: |
    cd scripts/
    ./sign.sh --debug
```

```bash
# scripts/sign.sh (添加调试输出)
echo "=== Keychain state ==="
security list-keychains
security find-identity -v

echo "=== Environment ==="
env | grep IDENTITY || echo "IDENTITY not in env"

echo "=== Actual signing ==="
codesign --sign "$IDENTITY" --verbose=4 "$APP"
```

运行一次收集证据:
```
=== Secrets in workflow ===
IDENTITY: SET
P12: SET

=== Environment ===
IDENTITY not in env  ← 发现问题！

=== Keychain state ===
[empty]
```

**根因定位**: secrets 在 workflow 中存在，但没有传递到 build script 环境

阶段 2: 模式分析
-------------------
查找正确的示例:

```yaml
# 其他成功的 workflow
- name: Build
  env:  # ← 正确的方式：显式传递 env
    IDENTITY: ${{ secrets.IDENTITY }}
    P12_BASE64: ${{ secrets.P12_BASE64 }}
  run: ./scripts/build.sh
```

当前的错误方式:
```yaml
- name: Build
  # 缺少 env 块！
  run: ./scripts/build.sh
```

阶段 3: 假设和测试
-------------------
假设: secrets 没有通过 env 传递到 build script

测试:
```yaml
- name: Build
  env:
    IDENTITY: ${{ secrets.IDENTITY }}
    P12_BASE64: ${{ secrets.P12_BASE64 }}
  run: ./scripts/build.sh
```

推送，CI 运行...
```
=== Environment ===
IDENTITY=Apple Development: ...
=== Keychain state ===
1) ABC123... "Apple Development: ..."
=== Actual signing ===
Signing successful ✓
```

阶段 4: 实施
-------------------
修复已验证，提交代码并添加注释:

```yaml
- name: Build and Sign
  env:
    # Required: workflow secrets aren't auto-inherited
    IDENTITY: ${{ secrets.IDENTITY }}
    P12_BASE64: ${{ secrets.P12_BASE64 }}
  run: ./scripts/build.sh
```

总耗时: 30 分钟（包含 2 次 CI 运行）
尝试次数: 1 次（直接成功）
```

#### 示例 3: 3 次失败后质疑架构

```
问题: 用户报告偶尔出现数据不一致

尝试 1: 添加事务锁 → 仍然失败
尝试 2: 增加数据库连接池 → 仍然失败
尝试 3: 修改查询顺序 → 仍然失败

❌ 错误的做法:
"让我再试一次，这次添加更强的锁..."

✅ 正确的做法 (systematic-debugging):

停止！3 次失败意味着架构问题。

分析失败模式:
- 每次修复都揭示新的共享状态问题
- 每次修复需要"大规模重构"才能实现
- 每次修复在其他地方产生新症状

这不是假设错误 - 这是错误的架构。

与团队讨论:
```
问题: 我们的架构是否从根本上有问题？
观察: 数据一致性问题来自多个并发更新点
根因: 我们在多处修改共享状态，没有统一的事务边界

建议:
选项 A: 重构为事件溯源架构（彻底解决）
选项 B: 引入消息队列序列化更新（中间方案）
选项 C: 接受最终一致性，添加对账机制（务实方案）

不建议: 继续打补丁
```

这种情况下不再尝试第 4 个修复。
```

### 🚨 红旗警告

当你发现自己在想这些时，**立即停止**：

```
🚩 "先快速修复，稍后调查"
🚩 "试试改变 X 看看能不能工作"
🚩 "添加多个更改，运行测试"
🚩 "跳过测试，我会手动验证"
🚩 "大概是 X，让我修复那个"
🚩 "我不完全理解但这可能有用"
🚩 "模式说 X 但我会用不同的方式适配"
🚩 "主要问题是: [列出修复而不调查]"
🚩 "再试一次"（已经试了 2 次以上）
🚩 每次修复都在不同地方揭示新问题
```

**所有这些都意味着**：停止，返回阶段 1。

**如果 3 次以上修复失败**：质疑架构（见阶段 4）

### ⚠️ 合理化借口表

| 借口 | 真相 |
|------|------|
| "问题很简单，不需要流程" | 简单问题也有根因，流程对简单 bug 很快 |
| "紧急情况，没时间走流程" | 系统化调试比猜测和瞎试更快 |
| "先试试这个，然后再调查" | 第一次修复设定了模式，从一开始就要做对 |
| "确认修复有效后再写测试" | 未测试的修复不牢固，先测试证明它 |
| "一次多个修复节省时间" | 无法隔离什么有效，会造成新 bug |
| "参考太长，我会适配模式" | 部分理解保证会出 bug，完整阅读它 |
| "我看到问题了，让我修复它" | 看到症状 ≠ 理解根因 |
| "再试一次"（2 次失败后） | 3 次以上失败 = 架构问题，质疑模式，不要再修 |

### 📊 效果对比

#### 使用 systematic-debugging

```
调试过程:
  阶段 1（根因）: 10 分钟
  阶段 2（模式）: 5 分钟
  阶段 3（假设）: 5 分钟
  阶段 4（实施）: 10 分钟
  总计: 30 分钟

结果:
  ✅ 首次修复成功率: 95%
  ✅ 引入新 bug: 接近 0
  ✅ 有回归测试保护
  ✅ 理解了根本原因
```

#### 不使用 systematic-debugging

```
调试过程:
  猜测 1: 15 分钟（失败）
  猜测 2: 20 分钟（失败）
  猜测 3: 25 分钟（部分成功）
  修复新 bug: 30 分钟
  重新返工: 1 小时
  总计: 2.5 小时

结果:
  ❌ 首次修复成功率: 40%
  ❌ 引入新 bug: 常见
  ❌ 没有测试保护
  ❌ 根因仍然未知
```

**时间节省**: 80%
**成功率提升**: 55%

### 🎬 配置说明

```yaml
---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes
---
```

### 🔗 相关 Skills

| Skill | 关系 | 用途 |
|-------|------|------|
| **test-driven-development** | 协作 | 阶段 4 创建失败的测试用例 |
| **verification-before-completion** | 后续 | 验证修复确实有效 |
| **writing-plans** | 配合 | 如果需要大规模重构 |
| **brainstorming** | 架构讨论 | 3 次失败后重新设计 |

### 📚 配套文档

```
systematic-debugging/
├── SKILL.md                    # 主文件
├── root-cause-tracing.md       # 回溯跟踪技术
├── defense-in-depth.md         # 多层验证
└── condition-based-waiting.md  # 条件等待替代超时
```

### ✨ 为什么推荐

1. **更快的调试** ⚡
   - 系统化比盲目尝试快 5 倍
   - 减少返工时间
   - 首次成功率 95%

2. **更少的 Bug** 🐛
   - 修复根因，不是症状
   - 接近 0 的新 bug 引入率
   - 有测试保护

3. **知识积累** 📚
   - 理解为什么会出错
   - 学到调试模式
   - 可以教给团队

4. **强制纪律** 💪
   - 防止"猜测驱动调试"
   - 建立科学思维
   - 提高工程质量

5. **压力下的可靠性** 🏆
   - 紧急情况下更需要系统化
   - 避免恐慌性修复
   - 保持冷静和有效

### 🆚 vs 随机修复

| 维度 | systematic-debugging | 随机修复 |
|------|---------------------|---------|
| **首次成功率** | 95% | 40% |
| **调试时间** | 15-30 分钟 | 2-3 小时 |
| **引入新 bug** | 接近 0 | 常见 |
| **有测试保护** | 总是 | 很少 |
| **理解根因** | 总是 | 几乎不 |
| **可重复性** | 高 | 低 |

---

## English

### 📖 Skill Overview

**systematic-debugging** is a **systematic debugging process skill** that ensures you always find the root cause first before attempting fixes, rather than random guessing and patching.

**Iron Law**: No fixes without root cause investigation first.

### 🎯 When to Use

See Chinese section above for detailed use cases.

### ⚙️ How It Works

See Chinese section above for the four-phase workflow.

### 💡 Usage Examples

See Chinese section above for 3 detailed examples:
1. Test failure debugging
2. Multi-component system debugging
3. Questioning architecture after 3 failures

### 🚨 Red Flags

See Chinese section above for warning signs to stop.

### ✨ Why Recommended

1. **Faster Debugging** ⚡ - 5x faster than trial-and-error
2. **Fewer Bugs** 🐛 - Fix root causes, not symptoms
3. **Knowledge Building** 📚 - Understand why things break
4. **Enforce Discipline** 💪 - Prevent "guess-driven debugging"
5. **Reliability Under Pressure** 🏆 - Systematic is faster in emergencies

### 📊 Impact Metrics

- First-time fix rate: 95% vs 40%
- Debugging time: 15-30 min vs 2-3 hours
- New bugs introduced: Near zero vs common

---

**Made with ❤️ for systematic debuggers**
