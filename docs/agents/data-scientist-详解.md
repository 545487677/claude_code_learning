# data-scientist Agent 详解

<div align="center">

**数据科学专业开发代理**

**Professional Data Science Agent**

⭐⭐⭐⭐⭐ 算法研究者必备 | 官方 Agent

[简体中文](#简体中文)

</div>

---

## 简体中文

### 📖 Agent 简介

**data-scientist** 是一个**数据科学专业 Agent**，擅长数据分析、特征工程、统计建模和可视化，帮助你从数据中提取洞察。

**核心能力**：
- ✅ 探索性数据分析（EDA）
- ✅ 特征工程
- ✅ 统计建模
- ✅ 数据可视化
- ✅ A/B测试分析

### 🎯 核心原则

```
数据科学 = 理解数据 + 提取特征 + 建立模型 + 验证假设

Data → Insights → Models → Decisions
数据 → 洞察 → 模型 → 决策
```

### ⚙️ 工作原理

```
分析数据时:
1. 数据理解
   - 查看数据形状、类型
   - 检查缺失值、异常值
   - 描述性统计

2. 探索性分析
   - 分布可视化
   - 相关性分析
   - 特征重要性

3. 特征工程
   - 缺失值处理
   - 类别编码
   - 特征变换
   - 特征选择

4. 建模验证
   - 模型选择
   - 交叉验证
   - 性能评估
```

### 💡 使用示例

#### 示例 1: 探索性数据分析

**输入**：
```
使用 data-scientist agent 分析这个用户行为数据集

数据：user_behavior.csv
- user_id: 用户ID
- age: 年龄
- session_duration: 会话时长(分钟)
- pages_viewed: 浏览页数
- converted: 是否转化(0/1)
```

**输出**：
```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats

# 1. 加载数据
df = pd.read_csv('user_behavior.csv')

print("=" * 50)
print("数据基本信息")
print("=" * 50)
print(f"数据形状: {df.shape}")
print(f"\\n数据类型:\\n{df.dtypes}")
print(f"\\n缺失值:\\n{df.isnull().sum()}")

# 2. 描述性统计
print("\\n" + "=" * 50)
print("描述性统计")
print("=" * 50)
print(df.describe())

# 3. 转化率分析
conversion_rate = df['converted'].mean()
print(f"\\n总体转化率: {conversion_rate:.2%}")

# 按年龄段分组
df['age_group'] = pd.cut(df['age'], bins=[0, 25, 35, 45, 100],
                          labels=['18-25', '26-35', '36-45', '45+'])
conversion_by_age = df.groupby('age_group')['converted'].mean()
print(f"\\n各年龄段转化率:\\n{conversion_by_age}")

# 4. 相关性分析
print("\\n" + "=" * 50)
print("特征相关性")
print("=" * 50)
correlation = df[['age', 'session_duration', 'pages_viewed', 'converted']].corr()
print(correlation)

# 可视化相关性矩阵
plt.figure(figsize=(10, 8))
sns.heatmap(correlation, annot=True, cmap='coolwarm', center=0)
plt.title('Feature Correlation Matrix')
plt.savefig('correlation_matrix.png')

# 5. 分布可视化
fig, axes = plt.subplots(2, 2, figsize=(15, 12))

# 会话时长分布
axes[0, 0].hist(df['session_duration'], bins=50, edgecolor='black')
axes[0, 0].set_title('Session Duration Distribution')
axes[0, 0].set_xlabel('Minutes')

# 浏览页数分布
axes[0, 1].hist(df['pages_viewed'], bins=30, edgecolor='black')
axes[0, 1].set_title('Pages Viewed Distribution')
axes[0, 1].set_xlabel('Pages')

# 转化vs非转化的会话时长对比
df[df['converted']==1]['session_duration'].hist(ax=axes[1, 0], alpha=0.5, label='Converted', bins=30)
df[df['converted']==0]['session_duration'].hist(ax=axes[1, 0], alpha=0.5, label='Not Converted', bins=30)
axes[1, 0].set_title('Session Duration by Conversion')
axes[1, 0].legend()

# 年龄分布（按转化分组）
df.boxplot(column='age', by='converted', ax=axes[1, 1])
axes[1, 1].set_title('Age Distribution by Conversion')

plt.tight_layout()
plt.savefig('eda_visualizations.png')

# 6. 关键发现
print("\\n" + "=" * 50)
print("关键发现")
print("=" * 50)

# 转化用户vs非转化用户对比
converted_users = df[df['converted'] == 1]
non_converted = df[df['converted'] == 0]

print("\\n转化用户 vs 非转化用户:")
print(f"平均会话时长: {converted_users['session_duration'].mean():.1f} min vs {non_converted['session_duration'].mean():.1f} min")
print(f"平均浏览页数: {converted_users['pages_viewed'].mean():.1f} vs {non_converted['pages_viewed'].mean():.1f}")
print(f"平均年龄: {converted_users['age'].mean():.1f} vs {non_converted['age'].mean():.1f}")

# 统计显著性检验
t_stat, p_value = stats.ttest_ind(converted_users['session_duration'],
                                    non_converted['session_duration'])
print(f"\\n会话时长差异显著性: p-value = {p_value:.4f}")
if p_value < 0.05:
    print("✅ 差异具有统计显著性")
else:
    print("❌ 差异不显著")

# 7. 建议
print("\\n" + "=" * 50)
print("数据洞察与建议")
print("=" * 50)
print("""
1. 会话时长与转化强相关 (r=0.65, p<0.001)
   建议：优化用户停留时间，提供更多互动内容

2. 26-35岁年龄段转化率最高 (15.2%)
   建议：针对此年龄段优化营销策略

3. 浏览页数>5时转化率显著提升
   建议：设计引导流程，鼓励多页浏览

4. 数据质量问题：
   - age列有12%缺失值，需要处理
   - session_duration有异常值（>180分钟），考虑清洗
""")
```

**特点**：
- ✅ 系统化的EDA流程
- ✅ 多角度数据可视化
- ✅ 统计显著性检验
- ✅ 可操作的业务建议

#### 示例 2: 特征工程

**输入**：
```
使用 data-scientist 进行特征工程，准备建模

数据集：customer_churn.csv
目标：预测客户流失
```

**输出**：
```python
import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.feature_selection import SelectKBest, f_classif

class FeatureEngineer:
    def __init__(self, df, target_col):
        self.df = df.copy()
        self.target = target_col
        self.feature_importance = {}

    def handle_missing_values(self):
        """处理缺失值"""
        print("处理缺失值...")

        # 数值型：用中位数填充
        numeric_cols = self.df.select_dtypes(include=[np.number]).columns
        for col in numeric_cols:
            if self.df[col].isnull().sum() > 0:
                median = self.df[col].median()
                self.df[col].fillna(median, inplace=True)
                print(f"  {col}: 填充中位数 {median:.2f}")

        # 类别型：用众数填充
        categorical_cols = self.df.select_dtypes(include=['object']).columns
        for col in categorical_cols:
            if col != self.target and self.df[col].isnull().sum() > 0:
                mode = self.df[col].mode()[0]
                self.df[col].fillna(mode, inplace=True)
                print(f"  {col}: 填充众数 {mode}")

        return self

    def encode_categorical(self):
        """编码类别变量"""
        print("\\n编码类别变量...")

        categorical_cols = self.df.select_dtypes(include=['object']).columns
        categorical_cols = [col for col in categorical_cols if col != self.target]

        for col in categorical_cols:
            n_unique = self.df[col].nunique()

            # 低基数：One-Hot编码
            if n_unique <= 5:
                dummies = pd.get_dummies(self.df[col], prefix=col, drop_first=True)
                self.df = pd.concat([self.df, dummies], axis=1)
                self.df.drop(col, axis=1, inplace=True)
                print(f"  {col}: One-Hot编码 ({n_unique}类)")

            # 高基数：Label编码
            else:
                le = LabelEncoder()
                self.df[col + '_encoded'] = le.fit_transform(self.df[col])
                self.df.drop(col, axis=1, inplace=True)
                print(f"  {col}: Label编码 ({n_unique}类)")

        return self

    def create_features(self):
        """创建新特征"""
        print("\\n创建新特征...")

        # 示例：创建交互特征
        if 'tenure' in self.df.columns and 'monthly_charges' in self.df.columns:
            self.df['total_spend'] = self.df['tenure'] * self.df['monthly_charges']
            print("  创建: total_spend = tenure × monthly_charges")

        # 示例：创建比率特征
        if 'monthly_charges' in self.df.columns and 'total_charges' in self.df.columns:
            self.df['charge_ratio'] = self.df['monthly_charges'] / (self.df['total_charges'] + 1)
            print("  创建: charge_ratio = monthly_charges / total_charges")

        # 示例：创建分箱特征
        if 'tenure' in self.df.columns:
            self.df['tenure_group'] = pd.cut(self.df['tenure'],
                                              bins=[0, 12, 24, 48, 100],
                                              labels=['0-1年', '1-2年', '2-4年', '4年+'])
            # 转换为数值
            tenure_mapping = {'0-1年': 0, '1-2年': 1, '2-4年': 2, '4年+': 3}
            self.df['tenure_group'] = self.df['tenure_group'].map(tenure_mapping)
            print("  创建: tenure_group (分箱)")

        return self

    def scale_features(self):
        """特征标准化"""
        print("\\n标准化数值特征...")

        # 分离特征和目标
        X = self.df.drop(self.target, axis=1)
        y = self.df[self.target]

        # 只标准化数值特征
        numeric_cols = X.select_dtypes(include=[np.number]).columns

        scaler = StandardScaler()
        X[numeric_cols] = scaler.fit_transform(X[numeric_cols])

        print(f"  标准化了 {len(numeric_cols)} 个数值特征")

        self.df = pd.concat([X, y], axis=1)
        return self

    def select_features(self, k=10):
        """特征选择"""
        print(f"\\n选择Top {k}个重要特征...")

        X = self.df.drop(self.target, axis=1)
        y = self.df[self.target]

        # 使用F检验选择特征
        selector = SelectKBest(f_classif, k=k)
        X_selected = selector.fit_transform(X, y)

        # 获取选中的特征
        selected_features = X.columns[selector.get_support()].tolist()

        print("  选中的特征:")
        for i, feat in enumerate(selected_features, 1):
            score = selector.scores_[X.columns.get_loc(feat)]
            print(f"    {i}. {feat} (score: {score:.2f})")

        self.selected_features = selected_features
        return self

    def get_processed_data(self):
        """获取处理后的数据"""
        return self.df

# 使用示例
df = pd.read_csv('customer_churn.csv')

engineer = FeatureEngineer(df, target_col='churn')

# 执行完整流程
processed_df = (engineer
                .handle_missing_values()
                .encode_categorical()
                .create_features()
                .scale_features()
                .select_features(k=15)
                .get_processed_data())

print("\\n" + "=" * 50)
print("特征工程完成")
print("=" * 50)
print(f"原始特征数: {len(df.columns) - 1}")
print(f"工程后特征数: {len(processed_df.columns) - 1}")
print(f"推荐使用特征数: {len(engineer.selected_features)}")

# 保存处理后的数据
processed_df.to_csv('customer_churn_processed.csv', index=False)
print("\\n已保存: customer_churn_processed.csv")
```

#### 示例 3: A/B测试分析

**输入**：
```
使用 data-scientist 分析A/B测试结果

测试：新版UI vs 旧版UI
指标：转化率
```

**输出**：
```python
import pandas as pd
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt

def analyze_ab_test(control_data, treatment_data, metric='conversion'):
    """
    A/B测试分析

    Parameters:
    - control_data: 对照组数据
    - treatment_data: 实验组数据
    - metric: 评估指标
    """

    print("=" * 60)
    print("A/B测试分析报告")
    print("=" * 60)

    # 1. 基本统计
    control_conv = control_data[metric]
    treatment_conv = treatment_data[metric]

    n_control = len(control_conv)
    n_treatment = len(treatment_conv)

    rate_control = control_conv.mean()
    rate_treatment = treatment_conv.mean()

    print("\\n1. 样本统计")
    print("-" * 60)
    print(f"对照组 (旧版UI):")
    print(f"  样本量: {n_control}")
    print(f"  转化率: {rate_control:.2%}")

    print(f"\\n实验组 (新版UI):")
    print(f"  样本量: {n_treatment}")
    print(f"  转化率: {rate_treatment:.2%}")

    # 2. 效果计算
    lift = (rate_treatment - rate_control) / rate_control
    print(f"\\n2. 效果提升")
    print("-" * 60)
    print(f"绝对提升: {(rate_treatment - rate_control):.2%}")
    print(f"相对提升: {lift:.2%}")

    # 3. 统计显著性检验
    print(f"\\n3. 统计显著性检验")
    print("-" * 60)

    # 使用Z检验（大样本）
    z_stat, p_value = stats.proportions_ztest(
        [treatment_conv.sum(), control_conv.sum()],
        [n_treatment, n_control]
    )

    print(f"Z统计量: {z_stat:.4f}")
    print(f"P值: {p_value:.4f}")

    alpha = 0.05
    if p_value < alpha:
        print(f"✅ 结果显著 (p < {alpha})")
        conclusion = "新版UI显著优于旧版"
    else:
        print(f"❌ 结果不显著 (p >= {alpha})")
        conclusion = "新版UI无显著差异"

    # 4. 置信区间
    from statsmodels.stats.proportion import proportion_confint

    ci_control = proportion_confint(
        control_conv.sum(), n_control, alpha=0.05, method='wilson'
    )
    ci_treatment = proportion_confint(
        treatment_conv.sum(), n_treatment, alpha=0.05, method='wilson'
    )

    print(f"\\n4. 95%置信区间")
    print("-" * 60)
    print(f"对照组: [{ci_control[0]:.2%}, {ci_control[1]:.2%}]")
    print(f"实验组: [{ci_treatment[0]:.2%}, {ci_treatment[1]:.2%}]")

    # 5. 功效分析
    from statsmodels.stats.power import zt_ind_solve_power

    effect_size = (rate_treatment - rate_control) / np.sqrt(rate_control * (1 - rate_control))
    power = zt_ind_solve_power(
        effect_size=effect_size,
        nobs1=n_treatment,
        alpha=0.05,
        ratio=n_control/n_treatment
    )

    print(f"\\n5. 功效分析")
    print("-" * 60)
    print(f"效应量: {effect_size:.4f}")
    print(f"检验功效: {power:.2%}")

    if power < 0.8:
        print("⚠️  功效不足，建议增加样本量")
    else:
        print("✅ 功效充足")

    # 6. 可视化
    fig, axes = plt.subplots(1, 2, figsize=(14, 5))

    # 转化率对比
    groups = ['对照组\\n(旧版)', '实验组\\n(新版)']
    rates = [rate_control, rate_treatment]
    colors = ['#3498db', '#2ecc71']

    axes[0].bar(groups, rates, color=colors, alpha=0.7, edgecolor='black')
    axes[0].set_ylabel('转化率')
    axes[0].set_title('转化率对比')
    axes[0].set_ylim([0, max(rates) * 1.2])

    for i, (group, rate) in enumerate(zip(groups, rates)):
        axes[0].text(i, rate + 0.005, f'{rate:.2%}',
                    ha='center', va='bottom', fontweight='bold')

    # 置信区间对比
    axes[1].errorbar([0], [rate_control],
                     yerr=[[rate_control - ci_control[0]], [ci_control[1] - rate_control]],
                     fmt='o', markersize=10, capsize=5, label='对照组', color='#3498db')
    axes[1].errorbar([1], [rate_treatment],
                     yerr=[[rate_treatment - ci_treatment[0]], [ci_treatment[1] - rate_treatment]],
                     fmt='o', markersize=10, capsize=5, label='实验组', color='#2ecc71')

    axes[1].set_xticks([0, 1])
    axes[1].set_xticklabels(['对照组', '实验组'])
    axes[1].set_ylabel('转化率')
    axes[1].set_title('95%置信区间')
    axes[1].legend()
    axes[1].grid(True, alpha=0.3)

    plt.tight_layout()
    plt.savefig('ab_test_results.png', dpi=300)
    print("\\n可视化已保存: ab_test_results.png")

    # 7. 最终结论
    print("\\n" + "=" * 60)
    print("最终结论与建议")
    print("=" * 60)
    print(f"\\n{conclusion}")

    if p_value < alpha and power >= 0.8:
        print(f"\\n建议：")
        print(f"✅ 全量上线新版UI")
        print(f"✅ 预期可提升转化率 {lift:.2%}")
    elif p_value < alpha and power < 0.8:
        print(f"\\n建议：")
        print(f"⚠️  继续收集数据以提高置信度")
        print(f"⚠️  当前效果提升 {lift:.2%}，但功效不足")
    else:
        print(f"\\n建议：")
        print(f"❌ 不建议上线新版UI")
        print(f"❌ 效果提升不显著")

    return {
        'control_rate': rate_control,
        'treatment_rate': rate_treatment,
        'lift': lift,
        'p_value': p_value,
        'power': power,
        'significant': p_value < alpha
    }

# 使用示例
control = pd.DataFrame({'conversion': np.random.binomial(1, 0.10, 5000)})
treatment = pd.DataFrame({'conversion': np.random.binomial(1, 0.12, 5000)})

results = analyze_ab_test(control, treatment)
```

### 🔗 相关 Agents

| Agent | 关系 | 用途 |
|-------|------|------|
| **ml-engineer** | 配合 | 模型训练和部署 |
| **python-pro** | 配合 | 代码实现 |
| **research-analyst** | 配合 | 数据调研 |

### ✨ 为什么推荐

1. **系统化分析** 📊
   - EDA标准流程
   - 统计检验
   - 可视化呈现

2. **特征工程专业** 🛠️
   - 缺失值处理
   - 编码策略
   - 特征选择

3. **统计严谨** 📐
   - 显著性检验
   - 置信区间
   - 功效分析

4. **业务导向** 💼
   - 可操作建议
   - ROI分析
   - 决策支持

---

**Made with ❤️ for data-driven researchers**
