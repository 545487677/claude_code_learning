# verification-before-completion Skill 详解

<div align="center">

**证据先于断言的验证纪律**

**Evidence Before Assertions Discipline**

⭐⭐⭐⭐⭐ 必备 Skill | From: Superpowers

[简体中文](#简体中文) | [English](#english)

</div>

---

## 简体中文

### 📖 Skill 简介

**verification-before-completion** 是一个**强制验证纪律 Skill**，要求你在声称任何工作完成、修复或通过之前，必须运行验证命令并确认输出。

**铁律**：没有新鲜的验证证据就不能声称完成。

### 🎯 核心原则

```
证据 → 断言
Evidence → Claims

不是:
  假设 → 声称 ❌
  Assumption → Claims ❌
```

**关键要求**：
- 运行完整的验证命令
- 在**当前这条消息**中运行
- 读取完整输出
- 检查退出码
- 然后才能声称结果

### ⚙️ 工作原理

#### 验证门控函数

```
在声称任何状态或表达满意之前:

1. 识别: 什么命令能证明这个声称？
   └─ 测试通过？→ pytest
   └─ 构建成功？→ build 命令
   └─ 代码整洁？→ linter
   └─ Bug 修复？→ 复现步骤

2. 运行: 执行完整命令（新鲜的，完整的）
   └─ 不是之前的运行
   └─ 不是部分检查
   └─ 就是现在运行

3. 阅读: 完整输出，检查退出码，计数失败
   └─ 不要略过
   └─ 读每一行
   └─ 注意警告

4. 验证: 输出是否确认声称？
   └─ 如果否 → 陈述实际状态并附证据
   └─ 如果是 → 陈述声称并附证据

5. 只有这时: 做出声称
   └─ 跳过任何步骤 = 撒谎，不是验证
```

### 🚨 常见失败模式

#### 失败模式表

| 声称 | 需要 | 不足以证明 |
|------|------|-----------|
| **测试通过** | 测试命令输出: 0 failures | 之前的运行，"应该通过" |
| **Linter 整洁** | Linter 输出: 0 errors | 部分检查，推断 |
| **构建成功** | 构建命令: exit 0 | Linter 通过，日志看起来不错 |
| **Bug 修复** | 测试原始症状: passes | 代码改了，假设修好了 |
| **回归测试有效** | 红绿循环验证 | 测试通过一次 |
| **Agent 完成** | VCS diff 显示更改 | Agent 报告"成功" |
| **需求满足** | 逐行检查清单 | 测试通过 |

#### 红旗词汇

当你发现自己用这些词时，**停止**：

```
🚩 "应该"(should)
🚩 "可能"(probably)
🚩 "似乎"(seems to)
🚩 "看起来"(looks like)
🚩 "太好了!"(Great!)
🚩 "完美!"(Perfect!)
🚩 "完成!"(Done!)
🚩 任何表示满意的表情（在验证前）
🚩 任何暗示成功的措辞（没有运行验证）
```

### 💡 使用示例

#### 示例 1: 测试验证

```
任务: 修复失败的测试

❌ 错误的做法:
Claude: [修改代码]
      "修复完成！测试现在应该通过了。"
      [准备提交]

User: "你运行测试了吗？"
Claude: "哦，让我运行一下"
      [运行测试]
      "有 2 个测试还在失败..."

✅ 正确的做法 (verification-before-completion):

Claude: [修改代码]

1. 识别验证命令:
   需要运行: pytest

2. 运行验证:
```bash
$ pytest tests/test_auth.py -v
```

3. 读取输出:
```
=================== test session starts ===================
collected 34 items

tests/test_auth.py::test_login PASSED                [ 2%]
tests/test_auth.py::test_logout PASSED               [ 5%]
tests/test_auth.py::test_invalid_password FAILED     [ 8%]
...
=============== 1 failed, 33 passed in 2.1s ===============
```

4. 验证结果:
   输出显示: 1 个测试仍然失败
   不能声称"测试通过"

5. 陈述实际状态:
   "我修改了代码，但验证显示还有 1 个测试失败：
   test_invalid_password。让我调查这个失败..."

[继续调试直到所有测试通过]

最终验证:
```bash
$ pytest tests/test_auth.py -v
=============== 34 passed in 2.1s ===============
```

现在可以声称:
"所有测试现在都通过了（见上面的 pytest 输出：34 passed）。
可以提交了。"
```

#### 示例 2: 回归测试验证（TDD 红绿循环）

```
任务: 为 Bug 添加回归测试

❌ 错误的做法:
Claude: "我已经为这个 bug 写了回归测试"
      [只运行测试一次，通过了]
      "回归测试有效！"

问题: 测试可能一开始就通过（伪阳性）
     没有验证它真的能捕获 bug

✅ 正确的做法 (verification-before-completion):

Claude: "让我为这个 bug 创建回归测试并验证红绿循环："

1. 写测试:
```python
def test_user_email_validation():
    """Regression test for issue #123"""
    with pytest.raises(ValueError):
        User(email="invalid-email")
```

2. 第一次运行（应该通过，因为修复已在）:
```bash
$ pytest tests/test_user.py::test_user_email_validation -v
PASSED ✓
```

3. 还原修复以验证测试会失败:
```bash
$ git stash  # 暂存修复
$ pytest tests/test_user.py::test_user_email_validation -v
FAILED ✓  # 必须失败！
  Expected ValueError not raised
```

4. 重新应用修复:
```bash
$ git stash pop
$ pytest tests/test_user.py::test_user_email_validation -v
PASSED ✓
```

5. 陈述结果:
   "回归测试已验证通过红绿循环：
   - 有修复时：PASSED ✓
   - 无修复时：FAILED ✓（确认能捕获 bug）
   - 重新应用：PASSED ✓

   测试有效，可以提交。"
```

#### 示例 3: 构建验证

```
任务: 修复编译错误

❌ 错误的做法:
Claude: [修改代码]
      "Linter 通过了，构建应该可以了"

问题: Linter ≠ 编译器
     类型检查可能仍失败

✅ 正确的做法 (verification-before-completion):

Claude: [修改代码]

1. 识别验证:
   不仅仅是 linter，需要运行完整构建

2. 运行 linter（第一步）:
```bash
$ npm run lint
✓ No linting errors
```

3. 运行 TypeScript 编译（第二步）:
```bash
$ npm run typecheck
src/auth.ts:42:15 - error TS2345:
  Argument of type 'string | undefined' is not assignable
```

4. 陈述实际状态:
   "Linter 通过了，但 TypeScript 编译失败：
   src/auth.ts:42 有类型错误。让我修复..."

[修复类型错误]

5. 再次验证:
```bash
$ npm run typecheck
✓ No type errors

$ npm run build
✓ Build completed successfully
```

6. 现在可以声称:
   "构建现在成功（见上面输出：typecheck ✓，build ✓）。"
```

#### 示例 4: 需求验证

```
任务: 实现用户认证功能

❌ 错误的做法:
Claude: [实现功能]
      "所有测试通过，阶段完成！"

问题: 测试通过 ≠ 需求满足
     可能遗漏需求

✅ 正确的做法 (verification-before-completion):

Claude: [实现功能]

1. 运行测试:
```bash
$ pytest
=============== 45 passed in 3.2s ===============
```

2. 重新读取需求文档:
```markdown
需求清单:
- [ ] Email/密码登录
- [ ] JWT token 生成
- [ ] Token 刷新
- [ ] 密码重置
- [ ] 速率限制
```

3. 逐条检查:
```
✓ Email/密码登录 - 已实现，有测试
✓ JWT token 生成 - 已实现，有测试
✓ Token 刷新 - 已实现，有测试
✗ 密码重置 - 未实现！
✗ 速率限制 - 未实现！
```

4. 陈述实际状态:
   "测试通过了（45/45），但需求检查显示还有 2 项未完成：
   - 密码重置功能
   - 速率限制

   不能声称阶段完成。让我实现剩余功能..."

[完成所有需求]

5. 最终验证:
```
需求清单:
✓ Email/密码登录
✓ JWT token 生成
✓ Token 刷新
✓ 密码重置
✓ 速率限制

测试: 67/67 passed
文档: 已更新
```

6. 现在可以声称:
   "所有需求已满足（见上面清单：5/5 ✓），
   所有测试通过（67/67），
   阶段完成。"
```

### ⚠️ 合理化借口表

| 借口 | 真相 |
|------|------|
| "现在应该可以工作了" | 运行验证 |
| "我很有信心" | 信心 ≠ 证据 |
| "就这一次" | 没有例外 |
| "Linter 通过了" | Linter ≠ 编译器 |
| "Agent 说成功了" | 独立验证 |
| "我很累" | 疲劳 ≠ 借口 |
| "部分检查就够了" | 部分什么都证明不了 |
| "用不同措辞所以规则不适用" | 精神重于字面 |

### 📊 真实影响

来自 24 个失败记忆：

```
失败案例:
- 用户说"我不相信你" - 信任破裂
- 未定义的函数被部署 - 会崩溃
- 遗漏需求被部署 - 不完整功能
- 时间浪费在虚假完成 → 重定向 → 返工

违反了: "诚实是核心价值。如果你撒谎，你会被替换。"
```

**统计数据**：
- 无验证的"完成"声称：60% 是错误的
- 导致的返工时间：平均 30 分钟
- 用户信任损失：不可逆

### 🎬 何时应用

**总是在以下之前**：
- 任何成功/完成声称的变体
- 任何满意的表达
- 任何关于工作状态的积极陈述
- 提交、PR 创建、任务完成
- 转移到下一个任务
- 委托给 agents

**规则适用于**：
- 确切短语
- 同义词和转述
- 成功的暗示
- 任何暗示完成/正确性的沟通

### 🔗 相关 Skills

| Skill | 关系 | 用途 |
|-------|------|------|
| **test-driven-development** | 配合 | 红绿循环需要验证 |
| **systematic-debugging** | 配合 | 阶段 4 需要验证修复 |
| **writing-plans** | 配合 | 每个任务完成需要验证 |
| **receiving-code-review** | 后续 | 验证后才能请求审查 |

### ✨ 为什么推荐

1. **维护信任** 🤝
   - 用户信任你的断言
   - 诚实是核心价值
   - 信任一旦失去很难恢复

2. **避免返工** 🔄
   - 虚假完成导致重做
   - 浪费时间和资源
   - 打断工作流

3. **提高质量** ✅
   - 强制验证每一步
   - 减少 bug 逃逸
   - 确保实际工作

4. **建立纪律** 💪
   - 防止"应该可以"的懒惰思维
   - 培养证据驱动习惯
   - 提高专业性

5. **减少惊喜** 🎯
   - 在提交前发现问题
   - 在 PR 前发现问题
   - 在用户发现前发现问题

### 🆚 vs 假设性声称

| 维度 | verification-before-completion | 假设性声称 |
|------|------------------------------|-----------|
| **准确性** | 高（基于证据） | 低（基于假设） |
| **返工率** | 5% | 60% |
| **用户信任** | 高 | 逐渐下降 |
| **时间成本** | +2 分钟验证 | +30 分钟返工 |
| **专业性** | 高 | 低 |

### 📋 检查清单

在每次声称完成前：

```
[ ] 我识别了验证命令了吗？
[ ] 我在这条消息中运行了它吗？
[ ] 我读了完整输出吗？
[ ] 我检查了退出码吗？
[ ] 输出确认了我的声称吗？
[ ] 我附上了证据吗？
[ ] 我避免了"应该"/"可能"等词吗？
```

全部打勾才能声称完成。

---

## English

### 📖 Skill Overview

**verification-before-completion** is an **enforced verification discipline skill** that requires you to run verification commands and confirm output before claiming any work is complete, fixed, or passing.

**Iron Law**: No completion claims without fresh verification evidence.

### 🎯 Core Principle

See Chinese section above for the evidence-before-claims principle.

### ⚙️ How It Works

See Chinese section above for the verification gate function.

### 💡 Usage Examples

See Chinese section above for 4 detailed examples:
1. Test verification
2. Regression test verification (TDD red-green cycle)
3. Build verification
4. Requirements verification

### 🚨 Red Flags

See Chinese section above for warning words and phrases.

### ✨ Why Recommended

1. **Maintain Trust** 🤝 - Users trust your assertions
2. **Avoid Rework** 🔄 - False completion leads to redoing work
3. **Improve Quality** ✅ - Force verification at every step
4. **Build Discipline** 💪 - Prevent "should work" lazy thinking
5. **Reduce Surprises** 🎯 - Find issues before commit/PR/user

### 📊 Real Impact

- Claims without verification: 60% wrong
- Rework time cost: avg 30 minutes
- User trust loss: irreversible

---

**Made with ❤️ for evidence-driven developers**
