# llm-architect Agent 详解

<div align="center">

**大语言模型架构设计专家**

**LLM System Architecture Expert**

⭐⭐⭐⭐⭐ 算法研究者必备 | 官方 Agent

[简体中文](#简体中文)

</div>

---

## 简体中文

### 📖 Agent 简介

**llm-architect** 是一个**大语言模型系统架构 Agent**，擅长设计生产级 LLM 应用，包括 RAG 系统、微调策略、多模型编排等。

**核心能力**：
- ✅ RAG 系统架构设计
- ✅ LoRA/QLoRA 微调策略
- ✅ Prompt Engineering 最佳实践
- ✅ 多模型编排
- ✅ 向量数据库选型

### 🎯 核心原则

```
LLM 架构 = 知识检索 + 上下文构建 + 模型推理 + 输出优化

RAG → Retrieve → Augment → Generate
检索 → 增强 → 生成

Not:
  直接调用 GPT API ❌
  无结构的 Prompt ❌
```

### ⚙️ 工作原理

```
设计 LLM 系统时:
1. 需求分析
   - 任务类型（QA、生成、分析）
   - 数据规模
   - 响应时间要求
   - 准确性要求

2. 架构选择
   - 纯 Prompt：简单任务
   - RAG：知识密集型
   - Fine-tuning：特定领域
   - 混合方案：复杂场景

3. 组件设计
   - 文档处理 Pipeline
   - 向量数据库
   - 检索策略
   - Prompt 模板
   - 输出解析

4. 优化策略
   - 延迟优化
   - 成本控制
   - 质量保证
```

### 💡 使用示例

#### 示例 1: RAG 文档问答系统

**输入**：
```
使用 llm-architect 设计一个企业文档问答 RAG 系统
```

**输出**：
```python
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Chroma
from langchain.chains import RetrievalQA
from langchain.llms import OpenAI
from langchain.document_loaders import DirectoryLoader, TextLoader
import chromadb

class EnterpriseDocumentQA:
    """企业文档问答 RAG 系统"""

    def __init__(self, documents_path: str, persist_directory: str = "./chroma_db"):
        """
        初始化 RAG 系统

        Args:
            documents_path: 文档目录路径
            persist_directory: 向量数据库持久化路径
        """
        self.documents_path = documents_path
        self.persist_directory = persist_directory

        # 初始化组件
        self.embeddings = OpenAIEmbeddings()
        self.text_splitter = RecursiveCharacterTextSplitter(
            chunk_size=1000,
            chunk_overlap=200,
            separators=["\n\n", "\n", " ", ""]
        )

        self.vectorstore = None
        self.qa_chain = None

    def load_documents(self):
        """加载文档"""
        print("📄 加载文档...")

        # 支持多种文档格式
        loader = DirectoryLoader(
            self.documents_path,
            glob="**/*.txt",
            loader_cls=TextLoader,
            show_progress=True
        )

        documents = loader.load()
        print(f"   加载了 {len(documents)} 个文档")

        return documents

    def split_documents(self, documents):
        """文档分块"""
        print("✂️  文档分块...")

        chunks = self.text_splitter.split_documents(documents)
        print(f"   分成 {len(chunks)} 个块")

        # 打印示例
        print("\n示例块:")
        print(chunks[0].page_content[:200] + "...")

        return chunks

    def create_vectorstore(self, chunks):
        """创建向量数据库"""
        print("\n🔢 创建向量索引...")

        self.vectorstore = Chroma.from_documents(
            documents=chunks,
            embedding=self.embeddings,
            persist_directory=self.persist_directory
        )

        # 持久化
        self.vectorstore.persist()
        print(f"   向量数据库已保存到: {self.persist_directory}")

    def load_existing_vectorstore(self):
        """加载已有向量数据库"""
        print("📂 加载已有向量数据库...")

        self.vectorstore = Chroma(
            persist_directory=self.persist_directory,
            embedding_function=self.embeddings
        )

        print(f"   已加载 {self.vectorstore._collection.count()} 个向量")

    def setup_qa_chain(self):
        """设置问答链"""
        print("\n⛓️  设置问答链...")

        # 检索器配置
        retriever = self.vectorstore.as_retriever(
            search_type="similarity",
            search_kwargs={
                "k": 4  # 返回最相关的 4 个块
            }
        )

        # LLM 配置
        llm = OpenAI(temperature=0.1)  # 低温度保证准确性

        # 问答链
        self.qa_chain = RetrievalQA.from_chain_type(
            llm=llm,
            chain_type="stuff",
            retriever=retriever,
            return_source_documents=True,
            verbose=True
        )

        print("   问答链已就绪")

    def ask(self, question: str):
        """提问"""
        if self.qa_chain is None:
            raise ValueError("请先调用 setup_qa_chain()")

        print(f"\n❓ 问题: {question}")
        print("=" * 60)

        # 执行查询
        result = self.qa_chain({"query": question})

        # 提取答案
        answer = result['result']
        source_docs = result['source_documents']

        print(f"\n💡 答案:")
        print(answer)

        print(f"\n📚 来源文档 ({len(source_docs)} 个):")
        for i, doc in enumerate(source_docs, 1):
            print(f"\n   [{i}] {doc.metadata.get('source', 'Unknown')}")
            print(f"   {doc.page_content[:150]}...")

        return answer, source_docs

    def build(self, force_rebuild: bool = False):
        """构建完整 RAG 系统"""
        import os

        # 检查是否已有向量数据库
        if os.path.exists(self.persist_directory) and not force_rebuild:
            print("✅ 检测到已有向量数据库，直接加载")
            self.load_existing_vectorstore()
        else:
            print("🔨 构建新的向量数据库...")

            # 完整流程
            documents = self.load_documents()
            chunks = self.split_documents(documents)
            self.create_vectorstore(chunks)

        # 设置问答链
        self.setup_qa_chain()

        print("\n" + "=" * 60)
        print("✅ RAG 系统构建完成！可以开始提问了")
        print("=" * 60)

# ========== 使用示例 ==========

# 1. 初始化系统
qa_system = EnterpriseDocumentQA(
    documents_path="./company_docs",
    persist_directory="./company_knowledge_base"
)

# 2. 构建（首次运行）或加载
qa_system.build()

# 3. 提问
qa_system.ask("公司的远程办公政策是什么？")
qa_system.ask("如何申请年假？")
qa_system.ask("差旅报销流程是怎样的？")

# ========== 高级配置 ==========

# 使用不同的检索策略
retriever_mmr = qa_system.vectorstore.as_retriever(
    search_type="mmr",  # Maximum Marginal Relevance
    search_kwargs={
        "k": 6,
        "fetch_k": 20,
        "lambda_mult": 0.5
    }
)

# 自定义 Prompt 模板
from langchain.prompts import PromptTemplate

template = """使用以下上下文信息回答问题。如果不知道答案，就说不知道，不要编造答案。

上下文：
{context}

问题：{question}

详细答案："""

PROMPT = PromptTemplate(
    template=template,
    input_variables=["context", "question"]
)

qa_chain_custom = RetrievalQA.from_chain_type(
    llm=llm,
    chain_type="stuff",
    retriever=retriever,
    chain_type_kwargs={"prompt": PROMPT},
    return_source_documents=True
)
```

**特点**：
- ✅ 完整的 RAG Pipeline
- ✅ 向量数据库持久化
- ✅ 文档来源追踪
- ✅ 自定义检索策略
- ✅ Prompt 模板可配置

#### 示例 2: LoRA 微调实现

**输入**：
```
使用 llm-architect 实现 LoRA 微调 LLaMA 模型
```

**输出**：
```python
from transformers import (
    AutoModelForCausalLM,
    AutoTokenizer,
    TrainingArguments,
    Trainer,
)
from peft import (
    LoraConfig,
    get_peft_model,
    prepare_model_for_kbit_training,
    TaskType
)
from datasets import load_dataset
import torch

class LoRAFineTuner:
    """LoRA 微调器"""

    def __init__(
        self,
        model_name: str = "meta-llama/Llama-2-7b-hf",
        dataset_name: str = "your-dataset",
    ):
        """
        初始化 LoRA 微调器

        Args:
            model_name: 基座模型名称
            dataset_name: 训练数据集
        """
        self.model_name = model_name
        self.dataset_name = dataset_name

        self.model = None
        self.tokenizer = None
        self.dataset = None

    def load_model(self):
        """加载模型"""
        print(f"📦 加载模型: {self.model_name}")

        # 加载 tokenizer
        self.tokenizer = AutoTokenizer.from_pretrained(self.model_name)
        self.tokenizer.pad_token = self.tokenizer.eos_token

        # 加载模型（8-bit 量化）
        self.model = AutoModelForCausalLM.from_pretrained(
            self.model_name,
            load_in_8bit=True,
            device_map="auto",
            torch_dtype=torch.float16
        )

        # 准备模型用于训练
        self.model = prepare_model_for_kbit_training(self.model)

        print(f"   模型加载完成，参数量: {self.model.num_parameters() / 1e9:.2f}B")

    def configure_lora(self):
        """配置 LoRA"""
        print("\n⚙️  配置 LoRA...")

        lora_config = LoraConfig(
            task_type=TaskType.CAUSAL_LM,
            r=16,                    # LoRA rank
            lora_alpha=32,           # LoRA alpha
            lora_dropout=0.05,       # Dropout
            bias="none",
            target_modules=[         # 应用 LoRA 的模块
                "q_proj",
                "k_proj",
                "v_proj",
                "o_proj",
            ]
        )

        # 应用 LoRA
        self.model = get_peft_model(self.model, lora_config)

        # 打印可训练参数
        self.model.print_trainable_parameters()

    def load_dataset(self):
        """加载数据集"""
        print(f"\n📊 加载数据集: {self.dataset_name}")

        # 加载数据集
        dataset = load_dataset(self.dataset_name)

        # 数据预处理
        def preprocess(examples):
            # 将输入输出拼接
            texts = [
                f"### Instruction:\n{inst}\n\n### Response:\n{resp}"
                for inst, resp in zip(
                    examples['instruction'],
                    examples['response']
                )
            ]

            # Tokenize
            tokenized = self.tokenizer(
                texts,
                truncation=True,
                padding="max_length",
                max_length=512,
                return_tensors="pt"
            )

            return tokenized

        self.dataset = dataset.map(
            preprocess,
            batched=True,
            remove_columns=dataset["train"].column_names
        )

        print(f"   训练样本: {len(self.dataset['train'])}")
        print(f"   验证样本: {len(self.dataset['validation'])}")

    def train(self, output_dir: str = "./lora_output"):
        """训练模型"""
        print(f"\n🚀 开始训练，输出目录: {output_dir}")

        # 训练参数
        training_args = TrainingArguments(
            output_dir=output_dir,
            num_train_epochs=3,
            per_device_train_batch_size=4,
            gradient_accumulation_steps=4,
            learning_rate=2e-4,
            fp16=True,
            logging_steps=10,
            save_steps=100,
            eval_steps=100,
            evaluation_strategy="steps",
            save_total_limit=3,
            load_best_model_at_end=True,
            report_to="wandb"  # 可选：使用 W&B 跟踪
        )

        # Trainer
        trainer = Trainer(
            model=self.model,
            args=training_args,
            train_dataset=self.dataset["train"],
            eval_dataset=self.dataset["validation"],
        )

        # 开始训练
        trainer.train()

        # 保存模型
        self.model.save_pretrained(output_dir)
        self.tokenizer.save_pretrained(output_dir)

        print(f"\n✅ 训练完成！模型已保存到: {output_dir}")

    def inference(self, prompt: str):
        """推理"""
        print(f"\n🔮 推理: {prompt}")

        inputs = self.tokenizer(prompt, return_tensors="pt").to(self.model.device)

        with torch.no_grad():
            outputs = self.model.generate(
                **inputs,
                max_new_tokens=256,
                temperature=0.7,
                do_sample=True,
                top_p=0.9
            )

        response = self.tokenizer.decode(outputs[0], skip_special_tokens=True)
        print(f"\n💬 回复:\n{response}")

        return response

# ========== 使用示例 ==========

# 1. 初始化
finetuner = LoRAFineTuner(
    model_name="meta-llama/Llama-2-7b-hf",
    dataset_name="yahma/alpaca-cleaned"
)

# 2. 加载模型
finetuner.load_model()

# 3. 配置 LoRA
finetuner.configure_lora()

# 4. 加载数据
finetuner.load_dataset()

# 5. 训练
finetuner.train(output_dir="./llama2-lora-alpaca")

# 6. 推理测试
finetuner.inference("Write a poem about machine learning.")

# ========== 参数说明 ==========

"""
LoRA 关键参数：

1. r (rank):
   - 低秩矩阵的秩
   - 越大表示能力越强，但参数越多
   - 推荐: 8-64

2. lora_alpha:
   - 缩放因子
   - 一般设为 r 的 2 倍
   - 推荐: 16-128

3. lora_dropout:
   - Dropout 率
   - 防止过拟合
   - 推荐: 0.05-0.1

4. target_modules:
   - 应用 LoRA 的模块
   - LLaMA: q_proj, k_proj, v_proj, o_proj
   - GPT: c_attn, c_proj

资源需求：
- LoRA (r=16): ~1.5GB 显存 (7B 模型)
- Full Fine-tuning: ~28GB 显存 (7B 模型)
- 节省: 18x 显存
"""
```

#### 示例 3: Prompt 工程最佳实践

**输入**：
```
使用 llm-architect 设计一个 Few-shot Prompt 模板
```

**输出**：
```python
from typing import List, Dict
from langchain.prompts import PromptTemplate, FewShotPromptTemplate

class PromptEngineer:
    """Prompt 工程师"""

    @staticmethod
    def create_few_shot_prompt(
        task_description: str,
        examples: List[Dict[str, str]],
        input_variables: List[str]
    ) -> FewShotPromptTemplate:
        """
        创建 Few-shot Prompt

        Args:
            task_description: 任务描述
            examples: 示例列表
            input_variables: 输入变量
        """

        # 示例模板
        example_template = """
Input: {input}
Output: {output}
"""

        example_prompt = PromptTemplate(
            input_variables=["input", "output"],
            template=example_template
        )

        # Few-shot Prompt
        few_shot_prompt = FewShotPromptTemplate(
            examples=examples,
            example_prompt=example_prompt,
            prefix=f"{task_description}\n\nExamples:",
            suffix="\nNow, please complete:\nInput: {{input}}\nOutput:",
            input_variables=input_variables
        )

        return few_shot_prompt

    @staticmethod
    def create_cot_prompt(question: str) -> str:
        """
        创建 Chain-of-Thought Prompt

        Args:
            question: 问题
        """

        template = """Let's solve this step by step:

Question: {question}

Step 1: Understand the problem
[Analyze what is being asked]

Step 2: Identify the approach
[Determine the method to solve it]

Step 3: Execute the solution
[Show the calculation/reasoning]

Step 4: Verify the answer
[Check if the answer makes sense]

Final Answer: [Your answer here]
"""

        return template.format(question=question)

    @staticmethod
    def create_structured_output_prompt(
        task: str,
        output_schema: Dict
    ) -> str:
        """
        创建结构化输出 Prompt

        Args:
            task: 任务描述
            output_schema: 输出 schema
        """

        import json

        template = f"""Task: {task}

Please provide your response in the following JSON format:

{json.dumps(output_schema, indent=2)}

Response:
"""

        return template

# ========== 使用示例 ==========

# 1. Few-shot Learning
engineer = PromptEngineer()

examples = [
    {
        "input": "I love this product!",
        "output": "Positive"
    },
    {
        "input": "This is terrible.",
        "output": "Negative"
    },
    {
        "input": "It's okay, not great.",
        "output": "Neutral"
    }
]

few_shot_prompt = engineer.create_few_shot_prompt(
    task_description="Classify the sentiment of the given text.",
    examples=examples,
    input_variables=["input"]
)

print(few_shot_prompt.format(input="I'm really happy with this!"))

# 2. Chain-of-Thought
cot_prompt = engineer.create_cot_prompt(
    "If a train travels 120 km in 2 hours, what is its average speed?"
)
print(cot_prompt)

# 3. Structured Output
schema = {
    "sentiment": "positive/negative/neutral",
    "confidence": "0-100",
    "key_phrases": ["list", "of", "phrases"],
    "explanation": "brief explanation"
}

structured_prompt = engineer.create_structured_output_prompt(
    task="Analyze the sentiment of the product review",
    output_schema=schema
)
print(structured_prompt)

# ========== Prompt 模式库 ==========

PROMPT_PATTERNS = {
    # 1. 角色设定
    "role_setting": "You are an expert {role} with {years} years of experience...",

    # 2. Few-shot
    "few_shot": "Here are some examples:\n{examples}\n\nNow solve: {question}",

    # 3. Chain-of-Thought
    "cot": "Let's think step by step:\n1. First, {step1}\n2. Then, {step2}...",

    # 4. Self-consistency
    "self_consistency": "Solve this problem 3 different ways and check consistency...",

    # 5. ReAct (Reasoning + Acting)
    "react": "Thought: {reasoning}\nAction: {action}\nObservation: {result}",

    # 6. 约束条件
    "constraints": """Requirements:
- Constraint 1: {c1}
- Constraint 2: {c2}
Output must satisfy all constraints."""
}
```

### 🚨 架构决策树

```
选择 LLM 架构:

┌─ 任务类型？
│
├─ 简单文本生成
│  └─ 使用 Prompt Engineering
│     - Zero-shot / Few-shot
│     - CoT (Chain-of-Thought)
│
├─ 需要外部知识？
│  └─ 使用 RAG
│     ├─ 文档量小 (<1000) → 向量数据库
│     ├─ 文档量大 (>10000) → 混合检索 (BM25 + 向量)
│     └─ 实时更新 → 增量索引
│
├─ 特定领域任务？
│  └─ Fine-tuning
│     ├─ 全参数微调 (Full Fine-tuning)
│     │  - 适用: 数据充足 (>10k)
│     │  - 资源: 大量 GPU
│     │
│     └─ 参数高效微调 (PEFT)
│        ├─ LoRA: 通用任务
│        ├─ Prefix Tuning: 生成任务
│        └─ Adapter: 迁移学习
│
└─ 复杂系统？
   └─ 混合架构
      - RAG + Fine-tuning
      - Multi-Agent 编排
      - 工具调用 (Function Calling)
```

### 📋 最佳实践

#### 1. RAG 系统优化

```python
# 分块策略
RecursiveCharacterTextSplitter(
    chunk_size=1000,        # 不要太大或太小
    chunk_overlap=200,      # 20% 重叠保证连贯性
    separators=["\n\n", "\n", " ", ""]
)

# 检索策略
retriever.search_kwargs = {
    "k": 4,                 # 返回 top-k
    "score_threshold": 0.7  # 相似度阈值
}

# 重排序 (Reranking)
from langchain.retrievers import ContextualCompressionRetriever
from langchain.retrievers.document_compressors import CohereRerank

compressor = CohereRerank()
compression_retriever = ContextualCompressionRetriever(
    base_compressor=compressor,
    base_retriever=retriever
)
```

#### 2. LoRA 参数选择

```
任务类型 → 推荐参数

1. 通用对话:
   r=16, alpha=32, dropout=0.05

2. 代码生成:
   r=32, alpha=64, dropout=0.1

3. 摘要/翻译:
   r=8, alpha=16, dropout=0.05

4. 领域适配:
   r=64, alpha=128, dropout=0.1
```

#### 3. Prompt 优化

```
✅ 好的 Prompt:
- 角色明确
- 任务具体
- 示例充足
- 格式清晰

❌ 坏的 Prompt:
- 模糊不清
- 缺少上下文
- 没有示例
- 格式混乱
```

### 🔗 相关 Agents

| Agent | 关系 | 用途 |
|-------|------|------|
| **prompt-engineer** | 配合 | Prompt 设计与优化 |
| **ml-engineer** | 配合 | 模型训练与部署 |
| **data-scientist** | 配合 | 数据分析与处理 |
| **nlp-engineer** | 配合 | NLP Pipeline 构建 |

### ✨ 为什么推荐

1. **架构清晰** 🎯
   - 模块化设计
   - 可扩展性强
   - 易于维护

2. **性能优化** ⚡
   - 延迟优化
   - 成本控制
   - 质量保证

3. **最佳实践** 📚
   - RAG 设计模式
   - LoRA 微调策略
   - Prompt 工程

4. **生产就绪** 🚀
   - 向量数据库持久化
   - 模型版本管理
   - 监控与日志

### 🆚 方案对比

| 方案 | 成本 | 准确性 | 开发时间 | 适用场景 |
|------|------|--------|----------|----------|
| **Prompt Only** | 低 | 中 | 快 | 简单任务 |
| **RAG** | 中 | 高 | 中 | 知识密集 |
| **Fine-tuning** | 高 | 最高 | 慢 | 特定领域 |
| **混合方案** | 高 | 最高 | 慢 | 复杂系统 |

---

**Made with ❤️ for LLM architects**
