# deep-research Skill 详解

<div align="center">

**多Agent编排的深度调研工作流**

**Multi-Agent Orchestrated Deep Research**

⭐⭐⭐⭐⭐ 研究者必备 | 官方 Skill

[简体中文](#简体中文)

</div>

---

## 简体中文

### 📖 Skill 简介

**deep-research** 是一个**多Agent编排的深度调研 Skill**，将复杂的调研任务拆解为可并行执行的子任务，协调多个专业 Agent 完成系统化调研。

**核心价值**：把"一个人花3天调研"变成"3个Agent并行1小时完成"。

### 🎯 核心原则

```
深度调研 = 任务分解 + Agent编排 + 结果整合

Task Decomposition → Parallel Execution → Synthesis
任务分解 → 并行执行 → 结果整合

Not:
  Sequential Research → Slow ❌
  顺序调研 → 慢 ❌
```

### ⚙️ 工作原理

```
触发深度调研时:

1. 理解调研目标
   - 明确调研主题
   - 识别关键问题
   - 定义调研范围

2. 任务分解
   - 拆解为独立子任务
   - 每个子任务可独立完成
   - 识别任务依赖关系

3. Agent分配
   research-analyst → 文献综述
   data-scientist → 数据分析
   ml-engineer → 技术实现
   llm-architect → 系统设计
   等等...

4. 并行执行
   - 多个Agent同时工作
   - 独立完成各自任务
   - 实时监控进度

5. 结果整合
   - 收集所有Agent输出
   - 识别关键发现
   - 生成综合报告

6. 输出交付
   - 结构化调研报告
   - 关键发现总结
   - 下一步建议
```

### 💡 使用示例

#### 示例 1: Transformer模型调研

**输入**：
```
深度调研：Transformer架构的最新进展和应用
```

**任务分解**：
```
主任务：Transformer最新进展调研

子任务分解：
├─ 任务1：文献综述（2020-2024）
│  Agent: research-analyst
│  输出：关键论文列表、技术演进
│
├─ 任务2：架构变体分析
│  Agent: llm-architect
│  输出：主流变体对比、优缺点
│
├─ 任务3：应用场景统计
│  Agent: data-scientist
│  输出：应用分布、性能数据
│
└─ 任务4：实现复杂度评估
   Agent: ml-engineer
   输出：实现难度、资源需求
```

**并行执行（示意）**：
```
时间线：
0min  ┌─ research-analyst 启动
      ├─ llm-architect 启动
      ├─ data-scientist 启动
      └─ ml-engineer 启动

20min research-analyst 完成
      → 发现50篇关键论文
      → 识别3大技术方向

25min llm-architect 完成
      → 对比8种主流变体
      → GPT、BERT、T5等

30min data-scientist 完成
      → NLP占60%、Vision占25%
      → 性能提升统计图表

35min ml-engineer 完成
      → 实现难度评分
      → 资源需求估算

40min 整合完成
      → 生成综合报告
```

**最终输出**：
```markdown
# Transformer架构深度调研报告

## 执行摘要

调研时间：40分钟（4个Agent并行）
覆盖文献：50篇（2020-2024）
架构变体：8种主流变体
应用领域：12个

## 关键发现

### 1. 技术演进（research-analyst）

**三大方向**：
1. 效率优化：Linear Attention、Flash Attention
2. 长序列处理：Longformer、BigBird
3. 多模态融合：CLIP、Flamingo

**突破性工作**：
- 2023: LLaMA - 开放权重的高性能模型
- 2023: GPT-4 - 多模态理解
- 2024: Mamba - 状态空间模型挑战Transformer

### 2. 架构对比（llm-architect）

| 变体 | 优势 | 劣势 | 适用场景 |
|------|------|------|---------|
| GPT | 生成强 | 双向弱 | 文本生成 |
| BERT | 理解强 | 生成弱 | 分类、NER |
| T5 | 统一框架 | 计算大 | 多任务 |
| Vision Transformer | 视觉SOTA | 数据需求高 | 图像分类 |

### 3. 应用分布（data-scientist）

应用领域占比：
- NLP: 60% (文本生成、翻译、QA)
- Computer Vision: 25% (分类、检测)
- 多模态: 10% (图文理解)
- 其他: 5%

性能提升：
- 相比RNN：准确率 +15%，速度 +300%
- 相比CNN：图像任务准确率 +5%

### 4. 实现评估（ml-engineer）

实现难度（1-10）：
- 基础Transformer: 6/10
- 预训练大模型: 9/10
- 微调应用: 4/10

资源需求：
- GPT-3级别：需要V100×100，训练1月
- BERT-base：单GPU可训练
- 微调：消费级GPU即可

## 研究机会

基于调研发现的3个研究方向：

1. **高效长序列处理**
   - 当前限制：O(n²)复杂度
   - 机会：线性复杂度的注意力机制
   - 难度：⭐⭐⭐⭐

2. **多模态统一架构**
   - 当前：各模态独立处理
   - 机会：端到端多模态理解
   - 难度：⭐⭐⭐⭐⭐

3. **低资源场景适配**
   - 当前：依赖大规模数据
   - 机会：少样本学习、参数高效微调
   - 难度：⭐⭐⭐

## 下一步建议

1. 深入阅读3篇关键论文（已标注）
2. 复现Flash Attention代码
3. 在小数据集上实验LoRA微调
```

#### 示例 2: 强化学习应用调研

**输入**：
```
深度调研：强化学习在游戏AI中的最新应用
```

**任务分解**：
```
├─ 任务1：经典游戏AI案例分析
│  Agent: research-analyst
│
├─ 任务2：算法对比（DQN、PPO、A3C等）
│  Agent: ml-engineer
│
├─ 任务3：训练效率数据统计
│  Agent: data-scientist
│
└─ 任务4：实际部署案例
   Agent: ai-engineer
```

**输出（节选）**：
```markdown
## 关键发现

### 算法演进
- 2015: DQN（Atari游戏）
- 2017: AlphaGo Zero（无需人类数据）
- 2019: OpenAI Five（Dota 2）
- 2023: AlphaStar（StarCraft II）

### 性能对比
PPO > A3C > DQN（在复杂环境）

### 训练成本
- 简单游戏：数小时（单GPU）
- 复杂策略：数周（100+ GPU）
```

#### 示例 3: 对比传统调研

**传统方式**（一个人）：
```
Day 1: 搜索论文 (8小时)
       ↓
Day 2: 阅读分析 (8小时)
       ↓
Day 3: 整理报告 (8小时)

总计：3天，24小时
```

**deep-research方式**（多Agent）：
```
0-20min: research-analyst 搜索+分析
0-25min: llm-architect 架构对比
0-30min: data-scientist 数据统计
0-35min: ml-engineer 实现评估
35-40min: 整合生成报告

总计：40分钟
效率提升：36倍
```

### 🚨 任务分解策略

#### 1. 独立性分解
```
✅ 好的分解（可并行）：
- 文献综述 ║ 技术对比 ║ 数据分析

❌ 坏的分解（有依赖）：
- 搜索论文 → 阅读论文 → 写总结
```

#### 2. Agent专长匹配
```
research-analyst → 文献、趋势
data-scientist → 统计、可视化
ml-engineer → 算法、实现
llm-architect → 系统、架构
product-manager → 应用、场景
```

#### 3. 任务粒度
```
太粗（不好并行）：
- 调研Transformer所有方面 ❌

太细（管理开销大）：
- 搜索第1篇论文 ❌
- 搜索第2篇论文 ❌

合适（可并行+高效）：
- 文献综述 ✅
- 架构分析 ✅
- 应用统计 ✅
```

### 📋 最佳实践

#### 1. 明确调研目标
```
✅ 具体目标：
"调研Transformer在NLP中的最新进展（2022-2024）"

❌ 模糊目标：
"了解一下Transformer"
```

#### 2. 合理分配Agent
```
文献密集型 → research-analyst
数据分析型 → data-scientist
技术实现型 → ml-engineer
系统设计型 → llm-architect
```

#### 3. 设置时间限制
```
每个Agent：
- 简单任务：5-15分钟
- 中等任务：15-30分钟
- 复杂任务：30-60分钟

避免：
- 无限制调研（永远完成不了）
```

### 🔗 相关 Skills/Agents

| 组件 | 关系 | 用途 |
|------|------|------|
| **paper-analysis** | 配合 | 深入分析单篇论文 |
| **research-analyst** | 使用 | 文献综述子任务 |
| **data-scientist** | 使用 | 数据分析子任务 |
| **brainstorming** | 后续 | 基于调研头脑风暴 |
| **writing-plans** | 后续 | 制定实施计划 |

### ✨ 为什么推荐

1. **效率极高** ⚡
   - 并行执行，36倍提速
   - 多Agent协作
   - 自动化流程

2. **覆盖全面** 📊
   - 多角度分析
   - 专业Agent分工
   - 不遗漏关键点

3. **质量可靠** 🎯
   - 专业Agent输出
   - 多源交叉验证
   - 结构化报告

4. **可复用** 🔄
   - 调研框架可复用
   - Agent编排可复用
   - 报告模板可复用

### 🆚 vs 传统调研

| 维度 | deep-research | 传统调研 |
|------|--------------|---------|
| **时间** | 40分钟 | 3天 |
| **并行度** | 4-6个Agent | 1个人 |
| **覆盖度** | 多角度全面 | 可能遗漏 |
| **一致性** | 结构化输出 | 因人而异 |
| **可复现** | 完全可复现 | 难复现 |

### 📝 触发方式

- "深度调研：[主题]"
- "deep research: [topic]"
- "/deep-research [topic]"
- "帮我系统调研 [主题]"

### ⚠️ 注意事项

1. **任务分解是关键**
   - 必须是可独立完成的子任务
   - 避免强依赖关系

2. **Agent选择要准确**
   - 匹配Agent专长
   - 不要滥用

3. **时间控制**
   - 设置合理时间限制
   - 避免无限调研

4. **结果整合**
   - 识别矛盾信息
   - 交叉验证
   - 综合判断

### 🎯 典型应用场景

#### 场景1：论文选题
```
调研目标：找到值得研究的方向
使用：deep-research
输出：3-5个研究机会 + 可行性分析
```

#### 场景2：技术选型
```
调研目标：选择合适的技术栈
使用：deep-research
输出：技术对比 + 推荐方案
```

#### 场景3：竞品分析
```
调研目标：了解竞品技术
使用：deep-research
输出：竞品对比 + 差异化机会
```

#### 场景4：文献综述
```
调研目标：撰写论文相关工作
使用：deep-research
输出：系统化文献综述
```

---

**Made with ❤️ for efficient researchers**
