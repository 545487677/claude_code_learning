# prompt-engineer Agent 详解

<div align="center">

**Prompt 工程与优化专家**

**Prompt Engineering and Optimization Expert**

⭐⭐⭐⭐⭐ LLM 开发必备 | 官方 Agent

[简体中文](#简体中文)

</div>

---

## 简体中文

### 📖 Agent 简介

**prompt-engineer** 是一个**Prompt 工程专业 Agent**，擅长设计、优化和测试高质量 Prompt，提升 LLM 应用性能。

**核心能力**：
- ✅ Prompt 模式设计
- ✅ Few-shot 学习策略
- ✅ Chain-of-Thought 推理
- ✅ 系统化 Prompt 测试
- ✅ 性能优化与迭代

### 🎯 核心原则

```
Prompt 工程 = 明确任务 + 提供上下文 + 结构化输出 + 迭代优化

Clear Task → Context → Examples → Iterate
明确任务 → 上下文 → 示例 → 迭代

Not:
  模糊指令 ❌
  无示例直接使用 ❌
  不测试直接上线 ❌
```

### ⚙️ 工作原理

```
设计 Prompt 时:
1. 任务定义
   - 明确目标
   - 定义输入输出
   - 设定约束条件

2. 模式选择
   - Zero-shot: 简单任务
   - Few-shot: 需要示例
   - CoT: 需要推理
   - ReAct: 需要工具调用

3. 模板构建
   - 角色设定
   - 任务描述
   - 示例提供
   - 输出格式

4. 测试优化
   - 多样化测试用例
   - 边界情况处理
   - 性能指标评估
   - 迭代改进
```

### 💡 使用示例

#### 示例 1: 从零构建高质量 Prompt

**输入**：
```
使用 prompt-engineer 为情感分类任务设计 Prompt
```

**输出 - 迭代过程**：

**版本 1: 基础版本（❌ 效果差）**
```
分析这段文本的情感

文本: {text}
```

**问题**:
- 太模糊
- 无示例
- 无输出格式

**版本 2: 改进版本（⚠️ 一般）**
```
分析以下文本的情感，回答是正面、负面还是中性。

文本: {text}

情感:
```

**问题**:
- 缺少示例
- 可能产生不一致输出
- 无置信度

**版本 3: Few-shot 版本（✅ 较好）**
```
你是一个情感分析专家。请分析文本的情感倾向。

示例:

文本: "这个产品太棒了，我非常喜欢！"
情感: 正面
置信度: 95%

文本: "质量一般，不太满意。"
情感: 负面
置信度: 80%

文本: "还行吧，没什么特别的。"
情感: 中性
置信度: 70%

现在，请分析:

文本: {text}

请按以下格式回答:
情感: [正面/负面/中性]
置信度: [0-100]%
理由: [简短说明]
```

**改进**:
- ✅ 角色设定
- ✅ 提供示例
- ✅ 明确格式
- ✅ 要求置信度和理由

**版本 4: 生产级版本（⭐ 最佳）**
```python
SENTIMENT_ANALYSIS_PROMPT = """你是一个专业的情感分析AI助手，具有以下能力:
- 准确识别文本的情感倾向
- 理解上下文和隐含情感
- 处理混合情感和讽刺

任务: 分析给定文本的整体情感倾向

分类标准:
- 正面: 表达积极、满意、喜悦等正向情绪
- 负面: 表达消极、不满、失望等负向情绪
- 中性: 客观陈述或情感不明显

示例:

输入: "这个产品太棒了，超出预期！客服态度也很好。"
输出:
{
  "sentiment": "正面",
  "confidence": 95,
  "key_phrases": ["太棒了", "超出预期", "态度很好"],
  "reasoning": "多处正面表达，整体情感明显积极"
}

输入: "价格贵，质量也就那样，有点后悔买了。"
输出:
{
  "sentiment": "负面",
  "confidence": 90,
  "key_phrases": ["价格贵", "质量也就那样", "后悔"],
  "reasoning": "价格和质量双重不满，表达明确负面情绪"
}

输入: "今天天气不错，适合出门散步。"
输出:
{
  "sentiment": "中性",
  "confidence": 85,
  "key_phrases": ["天气不错", "适合散步"],
  "reasoning": "客观描述天气，无明显情感倾向"
}

输入: "哇，真是'太好'了，又要加班。"
输出:
{
  "sentiment": "负面",
  "confidence": 88,
  "key_phrases": ["'太好'", "又要加班"],
  "reasoning": "引号表示讽刺，实际表达对加班的不满"
}

现在，请分析以下文本:

输入: {text}

输出格式: JSON
要求:
1. sentiment 必须是"正面"、"负面"或"中性"之一
2. confidence 必须是 0-100 的整数
3. key_phrases 列出 2-5 个关键短语
4. reasoning 用一句话说明判断依据
"""

# 使用示例
def analyze_sentiment(text):
    prompt = SENTIMENT_ANALYSIS_PROMPT.format(text=text)
    response = llm.complete(prompt)
    return json.loads(response)

# 测试
result = analyze_sentiment("虽然有些小瑕疵，但整体还是很满意的。")
print(result)
# {
#   "sentiment": "正面",
#   "confidence": 75,
#   "key_phrases": ["有些小瑕疵", "整体还是很满意"],
#   "reasoning": "虽有负面因素，但'整体满意'表明主导情感为正面"
# }
```

**版本 4 特点**:
- ✅ 清晰的角色和能力描述
- ✅ 明确的分类标准
- ✅ 多样化示例（包括边界情况）
- ✅ 结构化 JSON 输出
- ✅ 处理讽刺等复杂情况

#### 示例 2: Chain-of-Thought 推理

**输入**：
```
使用 prompt-engineer 设计数学推理 Prompt
```

**输出**：
```python
MATH_REASONING_PROMPT = """你是一个数学专家，擅长逐步分析和解决数学问题。

解题要求:
1. 仔细理解题意
2. 列出已知条件
3. 确定解题思路
4. 分步骤求解
5. 验证答案合理性

示例:

问题: 一个水池有两个进水管和一个排水管。甲管每小时注水8吨，乙管每小时注水12吨，丙管每小时排水5吨。如果三管同时开放，6小时能注满水池。如果单独开甲管，需要多少小时注满？

解答步骤:

**第1步: 理解题意**
- 甲管: +8吨/小时
- 乙管: +12吨/小时
- 丙管: -5吨/小时
- 三管同开6小时注满
- 求: 甲管单独开需要多少小时？

**第2步: 计算三管同开速度**
总速度 = 甲 + 乙 - 丙
       = 8 + 12 - 5
       = 15吨/小时

**第3步: 计算水池容量**
容量 = 速度 × 时间
     = 15吨/小时 × 6小时
     = 90吨

**第4步: 计算甲管单独时间**
时间 = 容量 ÷ 甲管速度
     = 90吨 ÷ 8吨/小时
     = 11.25小时

**第5步: 验证**
检查: 11.25小时 × 8吨/小时 = 90吨 ✓

**最终答案: 11.25小时 (或 11小时15分钟)**

---

现在，请用相同的方法解决以下问题:

问题: {question}

请按照以下格式回答:
**第1步: 理解题意**
[列出已知条件和求解目标]

**第2步: [确定解题思路]**
[说明解题方法]

**第3步: [计算过程]**
[逐步计算]

...

**最终答案: [你的答案]**
"""

# 使用
def solve_math_problem(question):
    prompt = MATH_REASONING_PROMPT.format(question=question)
    return llm.complete(prompt)

# 测试
question = "张三骑车从A地到B地，速度15km/h，用了3小时。回程提速到20km/h，用了多少小时？"
print(solve_math_problem(question))
```

**CoT 关键要素**:
- ✅ 明确"逐步推理"要求
- ✅ 提供详细推理示例
- ✅ 分步骤格式化
- ✅ 包含验证步骤

#### 示例 3: 结构化数据提取

**输入**：
```
使用 prompt-engineer 设计简历解析 Prompt
```

**输出**：
```python
RESUME_PARSING_PROMPT = """你是一个专业的简历解析AI，能够从非结构化简历文本中准确提取关键信息。

提取字段:
1. 基本信息: 姓名、电话、邮箱、地址
2. 教育背景: 学校、学位、专业、时间、GPA
3. 工作经历: 公司、职位、时间、职责、成就
4. 技能: 编程语言、工具、证书
5. 项目经验: 项目名、角色、技术栈、成果

输出格式: JSON

示例:

输入简历:
\"\"\"
张伟
电话: 13800138000 | 邮箱: zhangwei@email.com
地址: 北京市海淀区

教育背景:
北京大学 计算机科学与技术 本科 2015-2019 GPA: 3.8/4.0

工作经历:
字节跳动 高级算法工程师 2019.07 - 2023.06
- 负责推荐系统算法优化，CTR提升15%
- 主导A/B测试平台建设，支持100+实验并行
- 发表顶会论文2篇 (RecSys 2021, KDD 2022)

技能:
- 编程: Python, C++, Go
- 框架: PyTorch, TensorFlow
- 工具: Spark, Flink
\"\"\"

输出:
```json
{
  "basic_info": {
    "name": "张伟",
    "phone": "13800138000",
    "email": "zhangwei@email.com",
    "location": "北京市海淀区"
  },
  "education": [
    {
      "school": "北京大学",
      "degree": "本科",
      "major": "计算机科学与技术",
      "start_date": "2015",
      "end_date": "2019",
      "gpa": "3.8/4.0"
    }
  ],
  "work_experience": [
    {
      "company": "字节跳动",
      "title": "高级算法工程师",
      "start_date": "2019-07",
      "end_date": "2023-06",
      "responsibilities": [
        "负责推荐系统算法优化，CTR提升15%",
        "主导A/B测试平台建设，支持100+实验并行",
        "发表顶会论文2篇 (RecSys 2021, KDD 2022)"
      ]
    }
  ],
  "skills": {
    "programming_languages": ["Python", "C++", "Go"],
    "frameworks": ["PyTorch", "TensorFlow"],
    "tools": ["Spark", "Flink"]
  }
}
```

注意事项:
1. 如果某字段缺失，使用 null
2. 时间格式统一为 YYYY-MM
3. 工作经历按时间倒序
4. 提取所有量化成果（数字、百分比等）

现在，请解析以下简历:

{resume_text}

输出JSON:
"""

# 使用
def parse_resume(resume_text):
    prompt = RESUME_PARSING_PROMPT.format(resume_text=resume_text)
    response = llm.complete(prompt)
    return json.loads(response)
```

#### 示例 4: Prompt 测试框架

**输入**：
```
使用 prompt-engineer 构建 Prompt 测试系统
```

**输出**：
```python
from typing import List, Dict, Callable
import json

class PromptTester:
    """Prompt 测试框架"""

    def __init__(self, llm):
        self.llm = llm
        self.test_cases = []
        self.results = []

    def add_test_case(
        self,
        name: str,
        prompt_template: str,
        inputs: Dict,
        expected_output: any,
        evaluation_fn: Callable = None
    ):
        """添加测试用例"""
        self.test_cases.append({
            "name": name,
            "prompt_template": prompt_template,
            "inputs": inputs,
            "expected": expected_output,
            "eval_fn": evaluation_fn or self._default_eval
        })

    def _default_eval(self, actual, expected):
        """默认评估函数"""
        return actual == expected

    def run_tests(self):
        """运行所有测试"""
        print("=" * 60)
        print("Prompt 测试报告")
        print("=" * 60)

        for i, test in enumerate(self.test_cases, 1):
            print(f"\n[测试 {i}] {test['name']}")
            print("-" * 60)

            # 生成 Prompt
            prompt = test['prompt_template'].format(**test['inputs'])
            print(f"Prompt 预览: {prompt[:200]}...")

            # 调用 LLM
            actual = self.llm.complete(prompt)
            print(f"\n实际输出: {actual}")
            print(f"期望输出: {test['expected']}")

            # 评估
            passed = test['eval_fn'](actual, test['expected'])
            status = "✅ PASS" if passed else "❌ FAIL"
            print(f"\n结果: {status}")

            # 记录结果
            self.results.append({
                "name": test['name'],
                "passed": passed,
                "actual": actual,
                "expected": test['expected']
            })

        # 汇总
        total = len(self.results)
        passed = sum(1 for r in self.results if r['passed'])
        print("\n" + "=" * 60)
        print(f"测试完成: {passed}/{total} 通过 ({passed/total*100:.1f}%)")
        print("=" * 60)

        return self.results

    def benchmark_latency(self, prompt: str, n_runs: int = 10):
        """性能基准测试"""
        import time

        latencies = []
        for _ in range(n_runs):
            start = time.time()
            self.llm.complete(prompt)
            latency = time.time() - start
            latencies.append(latency)

        avg_latency = sum(latencies) / len(latencies)
        p95_latency = sorted(latencies)[int(0.95 * len(latencies))]

        print(f"平均延迟: {avg_latency:.3f}s")
        print(f"P95 延迟: {p95_latency:.3f}s")

        return {
            "avg": avg_latency,
            "p95": p95_latency,
            "all": latencies
        }

# ========== 使用示例 ==========

# 1. 创建测试器
tester = PromptTester(llm=your_llm)

# 2. 添加测试用例
tester.add_test_case(
    name="简单数学",
    prompt_template="计算: {expression}",
    inputs={"expression": "23 + 45"},
    expected_output="68"
)

tester.add_test_case(
    name="情感分类 - 正面",
    prompt_template=SENTIMENT_ANALYSIS_PROMPT,
    inputs={"text": "太棒了！"},
    expected_output=None,  # 会用自定义评估
    evaluation_fn=lambda actual, expected: "正面" in actual
)

tester.add_test_case(
    name="边界情况 - 空输入",
    prompt_template="分析: {text}",
    inputs={"text": ""},
    expected_output=None,
    evaluation_fn=lambda actual, expected: "无法" in actual or "请提供" in actual
)

# 3. 运行测试
results = tester.run_tests()

# 4. 性能测试
tester.benchmark_latency(SENTIMENT_ANALYSIS_PROMPT.format(text="测试文本"))
```

### 🚨 Prompt 设计模式

#### 模式 1: Zero-Shot
```
任务: 简单直接的任务

模板:
[任务描述]

输入: {input}
输出:
```

#### 模式 2: Few-Shot
```
任务: 需要示例引导

模板:
[任务描述]

示例1: [input] → [output]
示例2: [input] → [output]
示例3: [input] → [output]

输入: {input}
输出:
```

#### 模式 3: Chain-of-Thought
```
任务: 需要推理的复杂问题

模板:
让我们一步步思考:

问题: {question}

步骤1: [分析]
步骤2: [推理]
步骤3: [计算]

答案:
```

#### 模式 4: ReAct (Reasoning + Acting)
```
任务: 需要工具调用的任务

模板:
问题: {question}

Thought 1: [我需要...]
Action 1: [使用工具X]
Observation 1: [工具返回]

Thought 2: [基于结果，我...]
Action 2: [使用工具Y]
Observation 2: [工具返回]

Final Answer: [最终答案]
```

#### 模式 5: Self-Consistency
```
任务: 需要高置信度的答案

模板:
请用3种不同方法解决问题:

问题: {question}

方法1:
[推理过程1] → 答案: X

方法2:
[推理过程2] → 答案: X

方法3:
[推理过程3] → 答案: Y

分析: 2/3 得出答案 X
最终答案: X (置信度: 66%)
```

### 📋 Prompt 优化检查清单

#### ✅ 结构清晰
- [ ] 有明确的角色设定
- [ ] 任务描述清楚
- [ ] 输入输出格式明确
- [ ] 分段合理，易读

#### ✅ 上下文充分
- [ ] 提供足够背景信息
- [ ] 示例覆盖多种情况
- [ ] 包含边界情况示例
- [ ] 说明约束条件

#### ✅ 输出可控
- [ ] 指定输出格式（JSON/Text）
- [ ] 定义输出结构
- [ ] 要求解释/理由
- [ ] 包含置信度

#### ✅ 测试完备
- [ ] 正常情况测试
- [ ] 边界情况测试
- [ ] 错误输入测试
- [ ] 性能测试

### 🔗 相关 Agents

| Agent | 关系 | 用途 |
|-------|------|------|
| **llm-architect** | 配合 | LLM 系统架构设计 |
| **nlp-engineer** | 配合 | NLP Pipeline 实现 |
| **data-scientist** | 配合 | Prompt 效果评估 |

### ✨ 为什么推荐

1. **系统化方法** 🎯
   - 多种设计模式
   - 迭代优化流程
   - 完整测试框架

2. **实战导向** 💼
   - 生产级示例
   - 边界情况处理
   - 性能优化技巧

3. **质量保证** ✅
   - 测试驱动开发
   - 评估指标明确
   - 持续改进机制

4. **可复用性** 🔄
   - 模式库积累
   - 模板化设计
   - 最佳实践沉淀

---

**Made with ❤️ for prompt engineers**
