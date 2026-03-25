# nlp-engineer Agent 详解

<div align="center">

**自然语言处理工程实现专家**

**NLP Engineering and Implementation Expert**

⭐⭐⭐⭐⭐ NLP 开发必备 | 官方 Agent

[简体中文](#简体中文)

</div>

---

## 简体中文

### 📖 Agent 简介

**nlp-engineer** 是一个**NLP 工程实现 Agent**，擅长构建端到端 NLP Pipeline，从数据处理到模型部署的完整流程。

**核心能力**：
- ✅ 文本预处理 Pipeline
- ✅ 特征工程
- ✅ 模型训练与评估
- ✅ NLP 任务实现（分类、NER、QA等）
- ✅ 模型部署与服务化

### 🎯 核心原则

```
NLP 工程 = 数据处理 + 特征提取 + 模型训练 + 性能优化

Raw Text → Preprocessing → Features → Model → Predictions
原始文本 → 预处理 → 特征 → 模型 → 预测

Not:
  跳过数据清洗 ❌
  忽略特征工程 ❌
  只关注模型不关注工程 ❌
```

### ⚙️ 工作原理

```
构建 NLP 系统时:
1. 数据理解
   - 文本特点分析
   - 数据分布统计
   - 问题定义

2. 预处理 Pipeline
   - 清洗：去噪、标准化
   - 分词：中文/英文分词
   - 标注：词性、实体等

3. 特征工程
   - 传统: TF-IDF, n-gram
   - 深度: Word2Vec, BERT
   - 任务特定特征

4. 模型开发
   - 模型选择
   - 训练优化
   - 评估调优

5. 部署上线
   - API 服务
   - 性能优化
   - 监控告警
```

### 💡 使用示例

#### 示例 1: 文本分类 Pipeline

**输入**：
```
使用 nlp-engineer 构建新闻分类系统
```

**输出**：
```python
import re
import jieba
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import classification_report, confusion_matrix
import pickle

class NewsClassificationPipeline:
    """新闻分类 Pipeline"""

    def __init__(self):
        self.preprocessor = TextPreprocessor()
        self.vectorizer = TfidfVectorizer(
            max_features=5000,
            ngram_range=(1, 2),
            min_df=2
        )
        self.model = MultinomialNB(alpha=0.1)

    # ========== 1. 数据预处理 ==========

    class TextPreprocessor:
        """文本预处理器"""

        def __init__(self):
            # 加载停用词
            self.stopwords = self._load_stopwords()

        def _load_stopwords(self):
            """加载停用词表"""
            stopwords = set()
            # 假设从文件加载
            # with open('stopwords.txt', 'r') as f:
            #     stopwords = set(f.read().split('\n'))
            return stopwords

        def clean_text(self, text):
            """清洗文本"""
            # 去除 HTML 标签
            text = re.sub(r'<[^>]+>', '', text)

            # 去除 URL
            text = re.sub(r'http\S+|www\S+', '', text)

            # 去除邮箱
            text = re.sub(r'\S+@\S+', '', text)

            # 去除多余空白
            text = re.sub(r'\s+', ' ', text).strip()

            return text

        def tokenize(self, text):
            """中文分词"""
            words = jieba.lcut(text)

            # 去除停用词和单字符
            words = [
                w for w in words
                if w not in self.stopwords and len(w) > 1
            ]

            return words

        def preprocess(self, text):
            """完整预处理"""
            # 清洗
            text = self.clean_text(text)

            # 分词
            words = self.tokenize(text)

            # 返回空格分隔的词
            return ' '.join(words)

    # ========== 2. 特征提取 ==========

    def extract_features(self, texts, fit=True):
        """提取 TF-IDF 特征"""
        print("提取 TF-IDF 特征...")

        # 预处理
        processed_texts = [
            self.preprocessor.preprocess(text)
            for text in texts
        ]

        # TF-IDF
        if fit:
            features = self.vectorizer.fit_transform(processed_texts)
            print(f"  特征维度: {features.shape}")
            print(f"  词表大小: {len(self.vectorizer.vocabulary_)}")
        else:
            features = self.vectorizer.transform(processed_texts)

        return features

    # ========== 3. 模型训练 ==========

    def train(self, X_train, y_train):
        """训练模型"""
        print("\n训练模型...")

        # 提取特征
        X_train_features = self.extract_features(X_train, fit=True)

        # 训练
        self.model.fit(X_train_features, y_train)

        print("  训练完成")

    # ========== 4. 评估 ==========

    def evaluate(self, X_test, y_test):
        """评估模型"""
        print("\n评估模型...")

        # 提取特征
        X_test_features = self.extract_features(X_test, fit=False)

        # 预测
        y_pred = self.model.predict(X_test_features)

        # 评估指标
        print("\n分类报告:")
        print(classification_report(y_test, y_pred))

        # 混淆矩阵
        print("\n混淆矩阵:")
        cm = confusion_matrix(y_test, y_pred)
        print(cm)

        # 准确率
        accuracy = (y_pred == y_test).mean()
        print(f"\n准确率: {accuracy:.2%}")

        return accuracy

    # ========== 5. 预测 ==========

    def predict(self, text, return_proba=False):
        """预测单个文本"""
        # 提取特征
        features = self.extract_features([text], fit=False)

        # 预测
        if return_proba:
            proba = self.model.predict_proba(features)[0]
            label = self.model.classes_[np.argmax(proba)]
            confidence = proba.max()
            return label, confidence
        else:
            return self.model.predict(features)[0]

    # ========== 6. 保存/加载 ==========

    def save(self, filepath):
        """保存模型"""
        with open(filepath, 'wb') as f:
            pickle.dump({
                'preprocessor': self.preprocessor,
                'vectorizer': self.vectorizer,
                'model': self.model
            }, f)
        print(f"模型已保存: {filepath}")

    def load(self, filepath):
        """加载模型"""
        with open(filepath, 'rb') as f:
            data = pickle.load(f)
            self.preprocessor = data['preprocessor']
            self.vectorizer = data['vectorizer']
            self.model = data['model']
        print(f"模型已加载: {filepath}")

# ========== 使用示例 ==========

# 1. 准备数据
texts = [
    "中国经济持续增长，GDP增速超预期",
    "人工智能技术取得重大突破",
    "股市今日大涨，上证指数上涨3%",
    "科学家发现新型抗癌药物",
    # ... 更多数据
]
labels = ["经济", "科技", "财经", "医疗", ...]  # 对应标签

# 2. 划分数据集
X_train, X_test, y_train, y_test = train_test_split(
    texts, labels, test_size=0.2, random_state=42
)

# 3. 创建 Pipeline
pipeline = NewsClassificationPipeline()

# 4. 训练
pipeline.train(X_train, y_train)

# 5. 评估
accuracy = pipeline.evaluate(X_test, y_test)

# 6. 预测
new_text = "苹果公司发布最新 iPhone，搭载 A17 芯片"
label, confidence = pipeline.predict(new_text, return_proba=True)
print(f"\n预测: {label} (置信度: {confidence:.2%})")

# 7. 保存
pipeline.save("news_classifier.pkl")

# ========== 特征重要性分析 ==========

def analyze_feature_importance(pipeline, category, top_n=20):
    """分析类别的关键词"""
    # 获取类别索引
    category_idx = list(pipeline.model.classes_).index(category)

    # 获取特征权重
    feature_names = pipeline.vectorizer.get_feature_names_out()
    weights = pipeline.model.feature_log_prob_[category_idx]

    # 排序
    top_indices = np.argsort(weights)[-top_n:][::-1]

    print(f"\n'{category}' 类别的关键词:")
    for idx in top_indices:
        print(f"  {feature_names[idx]}: {weights[idx]:.4f}")

analyze_feature_importance(pipeline, "科技")
```

**特点**：
- ✅ 完整的预处理 Pipeline
- ✅ 中文分词与停用词
- ✅ TF-IDF 特征提取
- ✅ 模型保存与加载
- ✅ 特征重要性分析

#### 示例 2: 命名实体识别 (NER)

**输入**：
```
使用 nlp-engineer 实现 BiLSTM-CRF 命名实体识别
```

**输出**：
```python
import torch
import torch.nn as nn
from torch.utils.data import Dataset, DataLoader
from torchcrf import CRF

class BiLSTM_CRF(nn.Module):
    """BiLSTM-CRF 命名实体识别模型"""

    def __init__(
        self,
        vocab_size,
        embedding_dim=100,
        hidden_dim=128,
        num_tags=None,
        pretrained_embeddings=None
    ):
        super().__init__()

        # Embedding 层
        self.embedding = nn.Embedding(vocab_size, embedding_dim)
        if pretrained_embeddings is not None:
            self.embedding.weight.data.copy_(
                torch.from_numpy(pretrained_embeddings)
            )

        # BiLSTM 层
        self.lstm = nn.LSTM(
            embedding_dim,
            hidden_dim // 2,
            num_layers=2,
            bidirectional=True,
            batch_first=True,
            dropout=0.5
        )

        # 隐藏层到标签
        self.hidden2tag = nn.Linear(hidden_dim, num_tags)

        # CRF 层
        self.crf = CRF(num_tags, batch_first=True)

    def forward(self, x, mask=None):
        """前向传播"""
        # Embedding
        embeds = self.embedding(x)  # (batch, seq_len, embed_dim)

        # BiLSTM
        lstm_out, _ = self.lstm(embeds)  # (batch, seq_len, hidden_dim)

        # 投影到标签空间
        emissions = self.hidden2tag(lstm_out)  # (batch, seq_len, num_tags)

        return emissions

    def loss(self, x, tags, mask):
        """计算 CRF 损失"""
        emissions = self.forward(x)
        loss = -self.crf(emissions, tags, mask=mask, reduction='mean')
        return loss

    def predict(self, x, mask):
        """预测标签序列"""
        emissions = self.forward(x)
        predictions = self.crf.decode(emissions, mask=mask)
        return predictions

class NERDataset(Dataset):
    """NER 数据集"""

    def __init__(self, sentences, tags, word2idx, tag2idx):
        self.sentences = sentences
        self.tags = tags
        self.word2idx = word2idx
        self.tag2idx = tag2idx

    def __len__(self):
        return len(self.sentences)

    def __getitem__(self, idx):
        sentence = self.sentences[idx]
        tag = self.tags[idx]

        # 转换为索引
        word_ids = [
            self.word2idx.get(w, self.word2idx['<UNK>'])
            for w in sentence
        ]
        tag_ids = [self.tag2idx[t] for t in tag]

        return {
            'word_ids': torch.tensor(word_ids, dtype=torch.long),
            'tag_ids': torch.tensor(tag_ids, dtype=torch.long),
            'length': len(word_ids)
        }

def collate_fn(batch):
    """批处理函数（处理变长序列）"""
    # 找到最大长度
    max_len = max(item['length'] for item in batch)

    # Padding
    word_ids = []
    tag_ids = []
    masks = []

    for item in batch:
        length = item['length']
        pad_len = max_len - length

        # Padding word_ids
        padded_words = torch.cat([
            item['word_ids'],
            torch.zeros(pad_len, dtype=torch.long)
        ])
        word_ids.append(padded_words)

        # Padding tag_ids
        padded_tags = torch.cat([
            item['tag_ids'],
            torch.zeros(pad_len, dtype=torch.long)
        ])
        tag_ids.append(padded_tags)

        # Mask (1 for real tokens, 0 for padding)
        mask = torch.cat([
            torch.ones(length, dtype=torch.bool),
            torch.zeros(pad_len, dtype=torch.bool)
        ])
        masks.append(mask)

    return {
        'word_ids': torch.stack(word_ids),
        'tag_ids': torch.stack(tag_ids),
        'mask': torch.stack(masks)
    }

class NERTrainer:
    """NER 训练器"""

    def __init__(self, model, device='cuda'):
        self.model = model.to(device)
        self.device = device
        self.optimizer = torch.optim.Adam(model.parameters(), lr=0.001)

    def train_epoch(self, dataloader):
        """训练一个 epoch"""
        self.model.train()
        total_loss = 0

        for batch in dataloader:
            # 移动到设备
            word_ids = batch['word_ids'].to(self.device)
            tag_ids = batch['tag_ids'].to(self.device)
            mask = batch['mask'].to(self.device)

            # 前向传播
            loss = self.model.loss(word_ids, tag_ids, mask)

            # 反向传播
            self.optimizer.zero_grad()
            loss.backward()
            self.optimizer.step()

            total_loss += loss.item()

        return total_loss / len(dataloader)

    def evaluate(self, dataloader):
        """评估"""
        self.model.eval()
        all_predictions = []
        all_targets = []

        with torch.no_grad():
            for batch in dataloader:
                word_ids = batch['word_ids'].to(self.device)
                tag_ids = batch['tag_ids'].to(self.device)
                mask = batch['mask'].to(self.device)

                # 预测
                predictions = self.model.predict(word_ids, mask)

                # 收集结果（去除 padding）
                for pred, target, m in zip(predictions, tag_ids, mask):
                    length = m.sum().item()
                    all_predictions.extend(pred[:length])
                    all_targets.extend(target[:length].cpu().tolist())

        # 计算 F1
        from seqeval.metrics import classification_report, f1_score
        return f1_score([all_targets], [all_predictions])

    def predict_sentence(self, sentence, word2idx, idx2tag):
        """预测单个句子"""
        self.model.eval()

        # 转换为索引
        word_ids = [word2idx.get(w, word2idx['<UNK>']) for w in sentence]
        word_ids = torch.tensor([word_ids], dtype=torch.long).to(self.device)
        mask = torch.ones_like(word_ids, dtype=torch.bool)

        # 预测
        with torch.no_grad():
            predictions = self.model.predict(word_ids, mask)[0]

        # 转换为标签
        tags = [idx2tag[idx] for idx in predictions]

        # 提取实体
        entities = self._extract_entities(sentence, tags)

        return tags, entities

    def _extract_entities(self, sentence, tags):
        """从 BIO 标签提取实体"""
        entities = []
        entity = []
        entity_type = None

        for word, tag in zip(sentence, tags):
            if tag.startswith('B-'):
                # 开始新实体
                if entity:
                    entities.append((entity_type, ''.join(entity)))
                entity = [word]
                entity_type = tag[2:]
            elif tag.startswith('I-') and entity:
                # 继续当前实体
                entity.append(word)
            else:
                # 结束当前实体
                if entity:
                    entities.append((entity_type, ''.join(entity)))
                    entity = []
                    entity_type = None

        # 最后一个实体
        if entity:
            entities.append((entity_type, ''.join(entity)))

        return entities

# ========== 使用示例 ==========

# 1. 准备数据
sentences = [
    ['乔布斯', '创立', '了', '苹果', '公司'],
    ['马云', '在', '杭州', '创办', '阿里巴巴'],
    # ...
]
tags = [
    ['B-PER', 'O', 'O', 'B-ORG', 'I-ORG'],
    ['B-PER', 'O', 'B-LOC', 'O', 'B-ORG'],
    # ...
]

# 2. 构建词表
word2idx = {'<PAD>': 0, '<UNK>': 1}
tag2idx = {'O': 0}

for sentence in sentences:
    for word in sentence:
        if word not in word2idx:
            word2idx[word] = len(word2idx)

for tag_seq in tags:
    for tag in tag_seq:
        if tag not in tag2idx:
            tag2idx[tag] = len(tag2idx)

idx2tag = {v: k for k, v in tag2idx.items()}

# 3. 创建数据集
dataset = NERDataset(sentences, tags, word2idx, tag2idx)
dataloader = DataLoader(
    dataset, batch_size=32, shuffle=True, collate_fn=collate_fn
)

# 4. 创建模型
model = BiLSTM_CRF(
    vocab_size=len(word2idx),
    embedding_dim=100,
    hidden_dim=128,
    num_tags=len(tag2idx)
)

# 5. 训练
trainer = NERTrainer(model)

for epoch in range(10):
    loss = trainer.train_epoch(dataloader)
    f1 = trainer.evaluate(dataloader)
    print(f"Epoch {epoch+1}: Loss={loss:.4f}, F1={f1:.4f}")

# 6. 预测
test_sentence = ['马化腾', '在', '深圳', '创建', '了', '腾讯']
tags, entities = trainer.predict_sentence(test_sentence, word2idx, idx2tag)

print(f"句子: {''.join(test_sentence)}")
print(f"标签: {tags}")
print(f"实体: {entities}")
# 输出: [('PER', '马化腾'), ('LOC', '深圳'), ('ORG', '腾讯')]
```

#### 示例 3: 文本相似度计算

**输入**：
```
使用 nlp-engineer 实现基于 BERT 的语义相似度计算
```

**输出**：
```python
from transformers import BertModel, BertTokenizer
import torch
import torch.nn as nn
from scipy.spatial.distance import cosine

class SemanticSimilarity:
    """语义相似度计算"""

    def __init__(self, model_name='bert-base-chinese'):
        self.tokenizer = BertTokenizer.from_pretrained(model_name)
        self.model = BertModel.from_pretrained(model_name)
        self.model.eval()

    def get_embedding(self, text):
        """获取文本的 BERT embedding"""
        # Tokenize
        inputs = self.tokenizer(
            text,
            return_tensors='pt',
            padding=True,
            truncation=True,
            max_length=512
        )

        # 前向传播
        with torch.no_grad():
            outputs = self.model(**inputs)

        # [CLS] token 的 embedding
        cls_embedding = outputs.last_hidden_state[:, 0, :].numpy()

        return cls_embedding[0]

    def cosine_similarity(self, text1, text2):
        """余弦相似度"""
        emb1 = self.get_embedding(text1)
        emb2 = self.get_embedding(text2)

        similarity = 1 - cosine(emb1, emb2)
        return similarity

    def batch_similarity(self, query, candidates):
        """批量计算相似度"""
        query_emb = self.get_embedding(query)

        results = []
        for candidate in candidates:
            cand_emb = self.get_embedding(candidate)
            similarity = 1 - cosine(query_emb, cand_emb)
            results.append((candidate, similarity))

        # 按相似度排序
        results.sort(key=lambda x: x[1], reverse=True)

        return results

# 使用
sim_calculator = SemanticSimilarity()

text1 = "今天天气真不错"
text2 = "今日天气非常好"
text3 = "我喜欢吃苹果"

print(f"'{text1}' vs '{text2}': {sim_calculator.cosine_similarity(text1, text2):.4f}")
print(f"'{text1}' vs '{text3}': {sim_calculator.cosine_similarity(text1, text3):.4f}")

# 批量查询
query = "如何学习机器学习？"
candidates = [
    "机器学习入门教程",
    "深度学习基础知识",
    "Python 编程指南",
    "机器学习算法详解"
]

results = sim_calculator.batch_similarity(query, candidates)
for text, score in results:
    print(f"{score:.4f} - {text}")
```

### 🚨 NLP 任务类型

| 任务 | 输入 | 输出 | 典型模型 |
|------|------|------|----------|
| **文本分类** | 文本 | 类别 | BERT, CNN, LSTM |
| **命名实体识别** | 文本 | 实体+类型 | BiLSTM-CRF, BERT-CRF |
| **关系抽取** | 文本+实体 | 关系 | BERT, RE-BERT |
| **问答系统** | 问题+文档 | 答案 | BERT, ALBERT, RoBERTa |
| **文本摘要** | 长文本 | 摘要 | BART, T5, Pegasus |
| **机器翻译** | 源语言 | 目标语言 | Transformer, mBART |
| **情感分析** | 文本 | 情感极性 | BERT, RoBERTa |

### 📋 最佳实践

#### 1. 数据预处理
```python
# 中文文本清洗
def clean_chinese_text(text):
    # 去除特殊字符
    text = re.sub(r'[^\u4e00-\u9fa5a-zA-Z0-9，。！？、；：""（）《》\s]', '', text)
    # 去除多余空格
    text = re.sub(r'\s+', ' ', text)
    return text.strip()
```

#### 2. 模型选择
```
任务复杂度 → 模型选择

简单分类 → Naive Bayes, SVM
中等复杂 → CNN, LSTM
复杂任务 → BERT, RoBERTa
超大规模 → GPT-3, ChatGPT
```

#### 3. 评估指标
```
分类: Accuracy, Precision, Recall, F1
NER: Entity-level F1
QA: Exact Match (EM), F1
生成: BLEU, ROUGE, Perplexity
```

### ✨ 为什么推荐

1. **端到端** 🎯
   - 完整 Pipeline
   - 数据到部署
   - 可直接使用

2. **工程化** 🏗️
   - 模块化设计
   - 易于扩展
   - 生产就绪

3. **最佳实践** 📚
   - 数据处理
   - 特征工程
   - 模型优化

4. **多任务支持** 🔄
   - 分类、NER、QA
   - 传统和深度方法
   - 灵活适配

---

**Made with ❤️ for NLP engineers**
