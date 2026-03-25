# Skills 测试指南

> 完整的 Skills 测试方法和实践指南

## 📋 目录

1. [测试准备](#测试准备)
2. [基础测试](#基础测试)
3. [高级测试](#高级测试)
4. [所有 Skills 测试清单](#所有-skills-测试清单)
5. [创建自定义 Skill](#创建自定义-skill)
6. [问题排查](#问题排查)

## 测试准备

### 环境检查

```bash
# 1. 检查 Skills 目录
ls -la .claude/skills/

# 2. 查看 Skill 列表
find .claude/skills/ -name "SKILL.md"

# 3. 验证 Skill 结构
cat .claude/skills/paper-analysis/SKILL.md | head -20
```

### 预期输出

```yaml
---
name: paper-analysis
description: 深度分析学术论文...
triggerWords:
  - 分析论文
  - paper analysis
---
```

## 基础测试

### 1. paper-analysis（论文分析）

#### 测试目的
验证学术论文的系统化分析功能

#### 测试步骤

**测试1：基础分析**
```
分析这篇论文：

标题：Attention Is All You Need
摘要：The dominant sequence transduction models are based on
complex recurrent or convolutional neural networks that include
an encoder and a decoder. The best performing models also connect
the encoder and decoder through an attention mechanism.
[可以加入更多论文内容]
```

**预期输出**：
- ✅ 6 个维度的分析（Task、Challenge、Insight & Novelty、Potential Flaw、Motivation、关键公式）
- ✅ Markdown 格式
- ✅ 公式用文本表示
- ✅ 逻辑清晰、层次分明

**测试2：保存功能**
```
分析这篇论文并保存到文件

[论文内容]
```

**预期行为**：
- ✅ 完成分析
- ✅ 询问保存路径
- ✅ 使用 Write 工具保存
- ✅ 文件名格式：`[标题]_analysis_[日期].md`

**测试3：研究笔记生成**
```
深度分析论文，生成研究笔记

[论文内容]
```

**预期输出**：
- ✅ 6 维度分析
- ✅ 个人思考
- ✅ 相关工作
- ✅ 未来方向
- ✅ 实验想法

#### 评分标准

| 项目 | 权重 | 评分 |
|------|------|------|
| 触发准确性 | 20% | /10 |
| 分析完整性 | 30% | /10 |
| 格式正确性 | 20% | /10 |
| 保存功能 | 15% | /10 |
| 笔记生成 | 15% | /10 |

### 2. test（自动化测试）

#### 测试目的
验证自动检测和运行测试的能力

#### 测试步骤

**测试1：自动检测**
```
运行项目测试
```

或

```
/test
```

**预期行为**：
- ✅ 自动检测测试框架（pytest, jest, go test等）
- ✅ 找到测试文件
- ✅ 运行测试命令
- ✅ 报告测试结果

**测试2：指定测试文件**
```
运行 test_api.py 的测试
```

**预期行为**：
- ✅ 运行指定文件
- ✅ 显示测试输出
- ✅ 报告成功/失败

**测试3：失败处理**
```
在没有测试的项目中运行测试
```

**预期行为**：
- ✅ 提示未找到测试
- ✅ 建议创建测试
- ✅ 不应该报错

#### 测试项目准备

创建测试项目：

```python
# test_example.py
def test_addition():
    assert 1 + 1 == 2

def test_subtraction():
    assert 5 - 3 == 2
```

### 3. cleanup-branches（分支清理）

#### 测试目的
验证 Git 分支清理功能

#### 测试步骤

**准备工作**：
```bash
# 创建测试分支
git checkout -b feature/test-1
git checkout -b feature/test-2
git checkout -b bugfix/test-3
git checkout main
```

**测试1：列出分支**
```
清理所有分支
```

或

```
/cleanup-branches
```

**预期行为**：
- ✅ 列出所有非主分支
- ✅ 询问确认
- ✅ 等待用户响应

**测试2：执行清理**
```
清理所有分支（确认后）
```

**预期行为**：
- ✅ 删除非主分支
- ✅ 保留 main 分支
- ✅ 显示清理结果

**测试3：安全检查**
```
在有未合并提交的分支上测试清理
```

**预期行为**：
- ✅ 检测未合并提交
- ✅ 警告用户
- ✅ 要求二次确认

### 4. cleanup-files（文件清理）

#### 测试步骤

**准备工作**：
```bash
# 创建临时文件
touch test.tmp
touch debug.log
mkdir -p __pycache__
```

**测试**：
```
清理项目中的临时文件
```

或

```
/cleanup-files
```

**预期行为**：
- ✅ 识别临时文件（.tmp, .log, __pycache__等）
- ✅ 列出将删除的文件
- ✅ 询问确认
- ✅ 执行删除

### 5. push-test-merge（完整流程）

#### 测试步骤

**测试完整 CI/CD 流程**：
```
推送代码、运行测试、创建并合并 PR
```

或

```
/push-test-merge
```

**预期流程**：
1. ✅ 检查 Git 状态
2. ✅ 推送到远程
3. ✅ 运行测试
4. ✅ 创建 Pull Request
5. ✅ 等待 CI 通过
6. ✅ 合并 PR

### 6. merge（合并 PR）

#### 测试步骤

**测试**：
```
合并 Pull Request #123
```

或

```
/merge 123
```

**预期行为**：
- ✅ 获取 PR 信息
- ✅ 检查 CI 状态
- ✅ 合并 PR
- ✅ 删除分支（可选）

### 7. systematic-debugging（系统调试）

#### 测试步骤

**测试1：错误诊断**
```
帮我调试这个错误：

Traceback (most recent call last):
  File "app.py", line 10, in <module>
    result = divide(10, 0)
  File "app.py", line 5, in divide
    return a / b
ZeroDivisionError: division by zero
```

**预期行为**：
- ✅ 系统化分析错误
- ✅ 识别根本原因
- ✅ 提供多个解决方案
- ✅ 给出最佳实践建议

**测试2：复杂问题**
```
我的应用启动后立即崩溃，没有明显错误信息
```

**预期行为**：
- ✅ 引导诊断流程
- ✅ 收集更多信息
- ✅ 系统化排查
- ✅ 提供解决路径

### 8. test-driven-development（TDD）

#### 测试步骤

**测试**：
```
使用 TDD 实现一个计算器类
```

**预期行为**：
1. ✅ 先写测试
2. ✅ 运行测试（失败）
3. ✅ 实现代码
4. ✅ 运行测试（通过）
5. ✅ 重构代码

### 9. verification-before-completion（完成前验证）

#### 测试步骤

**测试**：
```
验证代码完成情况
```

**预期行为**：
- ✅ 检查所有任务完成
- ✅ 运行测试
- ✅ 验证代码质量
- ✅ 生成完成报告

### 10. writing-plans（编写计划）

#### 测试步骤

**测试**：
```
为"实现用户认证系统"编写详细计划
```

**预期输出**：
- ✅ 问题分析
- ✅ 技术选型
- ✅ 实现步骤
- ✅ 测试计划
- ✅ 部署策略

## 高级测试

### 多 Skill 组合测试

#### 场景1：完整研究工作流

```
1. 分析这篇论文：[论文内容]
   → paper-analysis

2. 为论文创建实现计划
   → writing-plans

3. 使用 TDD 实现核心算法
   → test-driven-development

4. 验证完成情况
   → verification-before-completion
```

#### 场景2：代码质量保证流程

```
1. 系统调试发现的问题
   → systematic-debugging

2. 运行所有测试
   → test

3. 清理临时文件
   → cleanup-files

4. 推送并创建 PR
   → push-test-merge
```

### 自定义 Skill 测试

#### 测试你创建的 Skill

**步骤**：
1. 创建 Skill
2. 定义触发词
3. 测试触发
4. 验证输出
5. 测试边界情况

**示例**：

```
创建一个代码格式化 Skill

名称：format-code
触发词：格式化代码、format code
功能：自动格式化 Python/JavaScript 代码
```

## 所有 Skills 测试清单

### 内置 Skills

| Skill 名称 | 触发测试 | 功能测试 | 边界测试 | 性能测试 | 状态 |
|-----------|---------|---------|---------|---------|------|
| paper-analysis | ✅ | ✅ | ⬜ | ⬜ | 已测试 |
| test | ✅ | ✅ | ⬜ | ⬜ | 已测试 |
| cleanup-branches | ✅ | ✅ | ⬜ | ⬜ | 已测试 |
| cleanup-files | ✅ | ✅ | ⬜ | ⬜ | 已测试 |
| push-test-merge | ⬜ | ⬜ | ⬜ | ⬜ | 待测试 |
| merge | ⬜ | ⬜ | ⬜ | ⬜ | 待测试 |
| systematic-debugging | ⬜ | ⬜ | ⬜ | ⬜ | 待测试 |
| test-driven-development | ⬜ | ⬜ | ⬜ | ⬜ | 待测试 |
| verification-before-completion | ⬜ | ⬜ | ⬜ | ⬜ | 待测试 |
| writing-plans | ⬜ | ⬜ | ⬜ | ⬜ | 待测试 |
| autonomous-skill | ⬜ | ⬜ | ⬜ | ⬜ | 待测试 |
| brainstorming | ⬜ | ⬜ | ⬜ | ⬜ | 待测试 |
| deep-research | ⬜ | ⬜ | ⬜ | ⬜ | 待测试 |
| github-review-pr | ⬜ | ⬜ | ⬜ | ⬜ | 待测试 |
| kiro-skill | ⬜ | ⬜ | ⬜ | ⬜ | 待测试 |
| receiving-code-review | ⬜ | ⬜ | ⬜ | ⬜ | 待测试 |
| reflection | ⬜ | ⬜ | ⬜ | ⬜ | 待测试 |
| skill-creator | ⬜ | ⬜ | ⬜ | ⬜ | 待测试 |
| spec-kit-skill | ⬜ | ⬜ | ⬜ | ⬜ | 待测试 |
| subagent-driven-development | ⬜ | ⬜ | ⬜ | ⬜ | 待测试 |
| using-git-worktrees | ⬜ | ⬜ | ⬜ | ⬜ | 待测试 |

### 测试进度追踪

```bash
# 创建测试记录文件
touch docs/skills/TEST_RESULTS.md

# 记录每次测试
echo "## $(date): paper-analysis 测试" >> docs/skills/TEST_RESULTS.md
echo "- 触发测试：✅ 通过" >> docs/skills/TEST_RESULTS.md
echo "- 功能测试：✅ 通过" >> docs/skills/TEST_RESULTS.md
```

## 创建自定义 Skill

### 简单 Skill 示例

```markdown
---
name: hello-world
description: 简单的问候 Skill
triggerWords:
  - say hello
  - 打招呼
---

当用户触发此 Skill 时，用友好的方式打招呼。

# 指令

1. 检测用户的语言（中文/英文）
2. 使用对应语言问候
3. 询问如何帮助用户
```

### Multi-file Skill 示例

```bash
.claude/skills/code-formatter/
├── SKILL.md          # 主指令
├── examples.md       # 示例
├── reference.md      # 参考文档
└── scripts/
    └── format.sh     # 格式化脚本
```

**SKILL.md**:
```markdown
---
name: code-formatter
description: 自动格式化代码
triggerWords:
  - format code
  - 格式化代码
---

# 功能

自动检测代码语言并应用对应的格式化工具。

# 支持的语言

- Python: black, autopep8
- JavaScript: prettier
- Go: gofmt
- Rust: rustfmt

# 使用方法

参见 examples.md
```

## 问题排查

### 问题1：Skill 不触发

**症状**：说了触发词，但 Skill 没有运行

**排查步骤**：

```bash
# 1. 检查 Skill 是否存在
ls .claude/skills/[skill-name]/

# 2. 检查 SKILL.md
cat .claude/skills/[skill-name]/SKILL.md | head -20

# 3. 验证 YAML frontmatter
python3 -c "
import yaml
with open('.claude/skills/[skill-name]/SKILL.md') as f:
    content = f.read()
    if content.startswith('---'):
        parts = content.split('---')
        metadata = yaml.safe_load(parts[1])
        print(metadata)
"
```

**解决方案**：
- 检查触发词拼写
- 验证 YAML 格式
- 尝试显式调用：`使用 [skill-name]`

### 问题2：Skill 执行错误

**症状**：Skill 触发了但执行失败

**排查步骤**：

```bash
# 检查日志
tail -f .claude/logs/session.log

# 检查权限
ls -la .claude/skills/[skill-name]/scripts/
```

**解决方案**：
- 查看错误信息
- 检查脚本权限
- 验证依赖是否安装

### 问题3：输出格式错误

**症状**：Skill 输出格式不符合预期

**排查**：
- 检查 SKILL.md 中的格式要求
- 查看 examples.md 中的示例
- 对比实际输出与预期输出

**解决方案**：
- 更新 SKILL.md 指令
- 添加更明确的格式要求
- 使用代码块示例

### 问题4：Skill 权限不足

**症状**：Skill 需要执行某些操作但被拒绝

**解决方案**：

```json
// settings.json
{
  "permissions": {
    "skills": {
      "[skill-name]": {
        "allowedTools": ["Bash", "Write", "Read"]
      }
    }
  }
}
```

## 测试报告模板

### 单个 Skill 测试报告

```markdown
# [Skill 名称] 测试报告

**测试日期**：2026-03-25
**测试人员**：[你的名字]
**Skill 版本**：[版本号]

## 测试环境
- OS: Linux
- Claude Code 版本: [版本]
- 测试项目: [项目名称]

## 测试结果

### 触发测试
- ✅ 通过 / ❌ 失败
- 测试用例：[触发词]
- 问题描述：[如有问题]

### 功能测试
- ✅ 通过 / ❌ 失败
- 测试场景：[描述]
- 实际结果：[描述]
- 预期结果：[描述]

### 边界测试
- ✅ 通过 / ❌ 失败
- 测试用例：[极端情况]
- 结果：[描述]

## 总体评分
- 触发准确性：9/10
- 功能完整性：8/10
- 错误处理：7/10
- 文档完善度：9/10

**总分**：33/40 (82.5%)

## 改进建议
1. [建议1]
2. [建议2]
```

## 最佳实践

### 1. 系统化测试

```markdown
测试阶段：
1. 单元测试 - 每个功能单独测试
2. 集成测试 - 多个功能组合测试
3. 场景测试 - 真实使用场景测试
4. 压力测试 - 边界和极端情况测试
```

### 2. 记录测试结果

```bash
# 创建测试日志
mkdir -p docs/skills/test-logs/

# 记录测试
echo "$(date): 测试 paper-analysis - 通过" >> docs/skills/test-logs/$(date +%Y-%m-%d).log
```

### 3. 持续改进

- 每次测试后更新文档
- 发现问题立即修复
- 补充边界测试用例
- 优化 Skill 性能

## 参考资源

- [Skills 详细文档](./README.md)
- [创建 Skills 指南](../../.claude/skills/README.md)
- [Skills 示例](./examples/)

---

**下一步**：测试所有内置 Skills，完成测试清单 ✓
