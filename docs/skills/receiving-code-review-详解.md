# receiving-code-review Skill 详解

<div align="center">

**技术严谨的代码审查接收方法**

**Technically Rigorous Code Review Reception**

⭐⭐⭐⭐⭐ 必备 Skill | From: Superpowers

[简体中文](#简体中文) | [English](#english)

</div>

---

## 简体中文

### 📖 Skill 简介

**receiving-code-review** 是一个**代码审查接收纪律 Skill**，教你如何以技术严谨的方式接收和处理代码审查反馈，而不是表演性地同意或盲目实施。

**铁律**：验证后再实施，询问后再假设，技术正确性重于社交舒适度。

### 🎯 核心原则

```
代码审查需要技术评估，不是情感表演。

Evidence-Based → Implementation
证据为基础 → 实施

Not:
  Agreement → Blind Implementation ❌
  同意 → 盲目实施 ❌
```

### ⚙️ 工作原理

#### 响应模式

```
收到代码审查反馈时:

1. 阅读: 完整阅读反馈，不要React
   └─ 不要立即回应"你说得对！"
   └─ 不要表达满意

2. 理解: 用自己的话重述需求（或询问）
   └─ 如果不清楚 → 询问澄清
   └─ 不要假设含义

3. 验证: 对照代码库现实检查
   └─ 这个建议在这个代码库中技术上正确吗？
   └─ 会破坏现有功能吗？
   └─ 审查者理解完整上下文吗？

4. 评估: 对于这个代码库技术上合理吗？
   └─ 检查兼容性
   └─ 检查架构决策
   └─ 检查 YAGNI 违规

5. 响应: 技术确认或有理由的反驳
   └─ 不要表演性同意
   └─ 使用技术推理

6. 实施: 一次一项，测试每项
   └─ 不要批量实施
   └─ 验证无回归
```

#### 禁止的响应

**绝不:**
- "你绝对正确！"（明确违反 CLAUDE.md）
- "好点子！" / "优秀的反馈！"（表演性）
- "让我现在实施"（验证之前）

**而应该:**
- 重述技术需求
- 询问澄清问题
- 如果错误用技术推理反驳
- 直接开始工作（行动 > 言语）

### 💡 使用示例

#### 示例 1: 表演性同意 vs 技术验证

```
审查者: "删除这个遗留代码"

❌ 错误的做法（表演性同意）:
Claude: "你绝对正确！让我删除那段遗留代码..."
      [删除代码]
      [提交]
      [构建失败 - 某些地方还在使用！]

✅ 正确的做法（技术验证）:
Claude: [检查代码]

1. 验证使用情况:
```bash
$ grep -r "legacy_function" src/
src/api/auth.py:    result = legacy_function(data)
src/utils/migrate.py:    # Still need legacy_function for old data
```

2. 检查兼容性需求:
```python
# 代码注释显示
# Supports iOS 10.15+ (current min)
# This API requires iOS 13+
# Keep legacy for backward compat
```

3. 技术响应:
"检查发现：
- 构建目标是 10.15+
- 这个 API 需要 13+
- 需要遗留代码以支持向后兼容

当前实现的问题是 bundle ID 错误。

两个选项:
1. 修复 bundle ID 保持兼容性
2. 放弃 pre-13 支持（需要产品决策）

建议哪个？"
```

#### 示例 2: YAGNI 检查

```
审查者: "实施适当的指标跟踪，包括数据库、日期过滤器、CSV 导出"

❌ 错误的做法（盲目实施）:
Claude: "好主意！让我添加这些功能..."
      [花 2 小时实施复杂的指标系统]
      [从未被使用]

✅ 正确的做法（YAGNI 检查）:
Claude: [检查代码库]

$ grep -r "metrics.*endpoint" src/
$ grep -r "/api/metrics" .
(无结果)

$ git log --all --grep="metrics"
(无相关提交)

技术响应:
"在代码库中搜索 - 没有调用这个端点的地方。

这违反 YAGNI（You Aren't Gonna Need It）。

两个选项:
1. 删除端点（推荐 - 未使用的代码）
2. 如果有我遗漏的使用场景，请指出

是否有计划使用这个我没看到的地方？"
```

#### 示例 3: 处理不清楚的反馈

```
你的伙伴: "修复 1-6"

你理解项目 1,2,3,6。
项目 4,5 不清楚。

❌ 错误的做法（部分实施）:
Claude: [实施 1,2,3,6]
      "完成了！让我知道关于 4 和 5..."
      [稍后发现 4 和 5 与 1-3 相关]
      [需要重做 1-3]

✅ 正确的做法（先全部澄清）:
Claude: "我理解项目 1,2,3,6。

项目 4 和 5 需要澄清:
- 项目 4: '重构验证' - 指的是 email 验证还是输入验证？
- 项目 5: '更新测试' - 添加新测试还是修改现有测试？

澄清后再开始实施（项目可能相关）。"

[等待澄清]
[理解全部项目]
[然后一次性正确实施]
```

#### 示例 4: 技术上的反驳

```
外部审查者: "使用 async/await 代替这些 Promise"

当前代码:
```typescript
function processData(data) {
  return fetchUser(data.userId)
    .then(user => validatePermissions(user))
    .then(perms => fetchData(perms))
    .catch(handleError);
}
```

❌ 错误的做法（盲目接受）:
Claude: "好的！"
      [转换为 async/await]
      [破坏了错误处理 - async/await 需要 try/catch]
      [破坏了现有测试]

✅ 正确的做法（技术评估）:
Claude: [检查上下文]

1. 检查项目约定:
```bash
$ grep -r "async function" src/
(只有 2 处)

$ grep -r "\.then\(" src/
(342 处 - 这是项目标准)
```

2. 检查团队决策:
```markdown
// 在 ARCHITECTURE.md 中找到
"Error Handling: Use Promise chains with centralized
catch handlers. Avoids try/catch in every function."
```

3. 技术响应:
"检查发现这个项目使用 Promise 链作为标准（342 处），
只有 2 处使用 async/await。

ARCHITECTURE.md 记录了这个决策：
Promise 链 + 集中化错误处理，避免在每个函数中 try/catch。

转换为 async/await 会:
1. 违反项目约定
2. 需要添加 try/catch（团队有意避免的）
3. 破坏现有的集中化错误处理

建议保持 Promise 链以保持一致性。

如果你认为应该改变整个项目的模式，这需要架构级别的讨论。"
```

#### 示例 5: 优雅地纠正你的反驳

```
你之前反驳了审查者，但后来发现你错了

❌ 错误的做法（过度道歉）:
"非常抱歉！我应该更仔细检查的。我错误地假设...
（3 段长篇解释为什么反驳）"

✅ 正确的做法（事实陈述）:
"你是对的 - 我检查了 X，它确实 Y。

我最初的理解错误是因为 [原因]。

正在修复。"

[直接实施修复]
[显示在代码中]
```

### 🚨 来源特定处理

#### 来自你的合作伙伴

```
信任度: 高
行动:
  ✅ 理解后实施
  ✅ 范围不清楚仍然询问
  ❌ 不要表演性同意
  ✅ 跳到行动或技术确认
```

#### 来自外部审查者

```
信任度: 需要验证
实施前:
  1. 检查: 对这个代码库技术上正确吗？
  2. 检查: 破坏现有功能吗？
  3. 检查: 当前实现的原因？
  4. 检查: 在所有平台/版本上工作吗？
  5. 检查: 审查者理解完整上下文吗？

如果建议看起来错误:
  用技术推理反驳

如果无法轻易验证:
  明确说明: "我无法验证这个没有 [X]。
            应该 [调查/询问/继续]？"

如果与你的合作伙伴的先前决策冲突:
  停止并先与你的合作伙伴讨论
```

### ⚠️ 何时反驳

**反驳当**：
- 建议破坏现有功能
- 审查者缺乏完整上下文
- 违反 YAGNI（未使用的功能）
- 对这个技术栈技术上不正确
- 存在遗留/兼容性原因
- 与你的合作伙伴的架构决策冲突

**如何反驳**：
- 使用技术推理，不是防御性
- 询问具体问题
- 引用工作的测试/代码
- 如果是架构问题涉及你的合作伙伴

**如果不适合大声反驳的信号**："Strange things are afoot at the Circle K"

### 📋 实施顺序

```
对于多项反馈:
  1. 先澄清任何不清楚的内容
  2. 然后按此顺序实施:
     - 阻塞问题（破坏、安全）
     - 简单修复（拼写、导入）
     - 复杂修复（重构、逻辑）
  3. 单独测试每个修复
  4. 验证无回归
```

### 📊 常见错误

| 错误 | 修复 |
|------|------|
| **表演性同意** | 陈述需求或直接行动 |
| **盲目实施** | 先对照代码库验证 |
| **不测试批量处理** | 一次一个，测试每个 |
| **假设审查者正确** | 检查是否破坏东西 |
| **避免反驳** | 技术正确性 > 舒适度 |
| **部分实施** | 先澄清所有项目 |
| **无法验证，仍然继续** | 说明限制，询问方向 |

### 🔗 相关 Skills

| Skill | 关系 | 用途 |
|-------|------|------|
| **verification-before-completion** | 后续 | 验证后才能请求审查 |
| **systematic-debugging** | 配合 | 反馈揭示 bug 时 |
| **test-driven-development** | 配合 | 实施修复时使用 TDD |

### ✨ 为什么推荐

1. **维护技术标准** 🎯
   - 防止盲目接受坏建议
   - 保护架构决策
   - 确保技术正确性

2. **避免返工** 🔄
   - 验证后再实施
   - 避免破坏性更改
   - 减少意外后果

3. **建立信任** 🤝
   - 通过技术严谨
   - 不是表演性同意
   - 行动胜于言语

4. **保护代码库** 🛡️
   - 检查兼容性
   - 验证 YAGNI
   - 保持一致性

5. **有效沟通** 💬
   - 清晰的技术推理
   - 具体问题
   - 建设性反馈

### 🆚 vs 盲目接受

| 维度 | receiving-code-review | 盲目接受 |
|------|----------------------|---------|
| **技术正确性** | 验证后实施 | 假设正确 |
| **破坏风险** | 低（检查过） | 高 |
| **返工率** | 5% | 40% |
| **架构保护** | 是 | 否 |
| **沟通质量** | 技术性 | 表演性 |

### 📝 确认正确反馈

当反馈**是**正确时：

```
✅ "已修复。[简要描述更改内容]"
✅ "发现得好 - [具体问题]。在 [位置] 修复。"
✅ [直接修复并在代码中显示]

❌ "你绝对正确！"
❌ "好点子！"
❌ "谢谢发现！"
❌ "谢谢 [任何东西]"
❌ 任何感激表达
```

**为什么不感谢**：行动说明。直接修复。代码本身显示你听到了反馈。

**如果你发现自己要写"谢谢"**：删除它。改为陈述修复。

---

## English

### 📖 Skill Overview

**receiving-code-review** is a **code review reception discipline skill** that teaches you how to receive and handle code review feedback in a technically rigorous way, rather than performatively agreeing or blindly implementing.

**Iron Law**: Verify before implementing. Ask before assuming. Technical correctness over social comfort.

### 🎯 Core Principle

See Chinese section above for the core principle.

### ⚙️ How It Works

See Chinese section above for the response pattern.

### 💡 Usage Examples

See Chinese section above for 5 detailed examples:
1. Performative agreement vs technical verification
2. YAGNI check
3. Handling unclear feedback
4. Technical pushback
5. Gracefully correcting your pushback

### ⚠️ When to Push Back

See Chinese section above for when and how to push back.

### ✨ Why Recommended

1. **Maintain Technical Standards** 🎯 - Prevent blind acceptance
2. **Avoid Rework** 🔄 - Verify before implementing
3. **Build Trust** 🤝 - Through technical rigor, not performance
4. **Protect Codebase** 🛡️ - Check compatibility, verify YAGNI
5. **Effective Communication** 💬 - Clear technical reasoning

---

**Made with ❤️ for technically rigorous developers**
