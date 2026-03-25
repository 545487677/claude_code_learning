# Deep Research 技能配置与使用指南

## 已有配置

### ✅ 技能本体
- 位置：`.claude/skills/deep-research/SKILL.md`
- 状态：已安装
- 调用：`/deep-research` 或直接说"深度调研..."

### ✅ MCP 服务器（项目级）
当前配置（`.mcp.json`）：
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "当前目录"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {"GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_PERSONAL_ACCESS_TOKEN}"}
    }
  }
}
```

### ⚠️ 缺少的联网工具

技能期望的 MCP 工具优先级：
1. **firecrawl**（网页抓取）- ❌ 未配置
2. **exa**（AI 搜索）- ❌ 未配置
3. WebFetch/WebSearch（内置）- ✅ 可用

---

## 完整配置步骤

### 选项1：使用内置工具（最简单）

**无需额外配置**，技能会降级使用：
- `WebFetch` - 抓取单个网页
- `WebSearch` - 搜索引擎查询

**适用场景**：小规模调研、公开网页内容

### 选项2：配置 Firecrawl（推荐）

Firecrawl 提供企业级网页抓取能力：

```bash
# 1. 安装 Firecrawl MCP 服务器
npm install -g @firecrawl/mcp-server

# 2. 获取 API Key（需要注册 https://firecrawl.dev）
# 免费额度：500 次/月

# 3. 更新 .mcp.json
```

```json
{
  "mcpServers": {
    "filesystem": { ... },
    "github": { ... },
    "firecrawl": {
      "command": "npx",
      "args": ["-y", "@firecrawl/mcp-server"],
      "env": {
        "FIRECRAWL_API_KEY": "fc-你的密钥"
      }
    }
  }
}
```

**可用工具**：
- `mcp__firecrawl__firecrawl_scrape` - 抓取单页
- `mcp__firecrawl__firecrawl_search` - 搜索
- `mcp__firecrawl__firecrawl_crawl` - 递归抓取
- `mcp__firecrawl__firecrawl_extract` - 结构化提取

### 选项3：配置 Exa（可选）

Exa 提供 AI 驱动的语义搜索：

```bash
# 1. 获取 API Key（https://exa.ai）

# 2. 更新 .mcp.json
```

```json
{
  "mcpServers": {
    "exa": {
      "command": "npx",
      "args": ["-y", "@exa-ai/mcp-server"],
      "env": {
        "EXA_API_KEY": "你的密钥"
      }
    }
  }
}
```

---

## 工作流程详解

### 执行模式

```bash
# 主进程（你看到的对话）
你: "深度调研 React 19 新特性"
  ↓
Claude 执行 deep-research 技能
  ↓
摸底：搜索样本 → 拆分子目标 → 等你确认
  ↓
生成调度脚本: .research/20260325-react19-xyz/run_children.sh

# 子进程（后台并行）
run_children.sh:
  for task in task1 task2 task3; do
    claude -p "$(cat prompts/$task.md)" \
      --allowedTools "Read,Write,WebFetch,WebSearch,mcp__firecrawl__*" \
      > child_outputs/$task.md 2>&1 &
  done
  wait
```

### 目录结构

```
.research/20260325-react19-xyz/
├── prompts/              # 子任务提示词
│   ├── task1.md
│   ├── task2.md
│   └── task3.md
├── child_outputs/        # 子任务输出
│   ├── task1.md
│   ├── task2.md
│   └── task3.md
├── logs/                 # 执行日志
│   ├── dispatcher.log
│   └── task1.log
├── raw/                  # 原始数据缓存
│   └── search_results.json
├── run_children.sh       # 调度脚本
└── final_report.md       # 最终报告 ⭐
```

---

## 实际使用示例

### 示例1：简单调研（使用内置工具）

```
你: 深度调研 Claude Code 的所有 Agent 类型

Claude 执行流程:
1. 摸底：搜索 Claude Code 文档，找到 Agent 列表
2. 拆分：50+ Agent → 分成 8 个子目标（按类别）
3. 询问："是否开始执行？"
4. 并行：8 个子进程各自抓取和分析
5. 聚合：整合成结构化报告
6. 精修：按章节润色
7. 交付：.research/xxx/final_report.md + 摘要
```

### 示例2：大规模调研（需要 Firecrawl）

```
你: 分析过去6个月关于 GPT-4 的所有重要论文

摸底阶段可能的发现：
- arXiv: 23 篇相关论文
- Google Scholar: 156 篇引用
- 技术博客: 89 篇深度分析

拆分策略：
- 子目标数: 268 个（23+156+89）
- 执行方式: GNU Parallel，批处理
- 工具需求: firecrawl（PDF 提取）

这种场景下，内置 WebFetch 不够用，需要配置 Firecrawl
```

---

## 联网工具决策树

```
调研任务
  ↓
是否有可复用的 skill？
  ├─ 是 → 使用 skill
  └─ 否 ↓
     是否需要结构化抽取/递归抓取？
       ├─ 是 → 使用 Firecrawl MCP
       └─ 否 ↓
          是否需要语义搜索？
            ├─ 是 → 使用 Exa MCP
            └─ 否 → 使用 WebFetch/WebSearch（内置）
```

---

## 测试你的配置

### 快速测试

```bash
# 测试 MCP 连接
claude --mcp-debug

# 查看可用工具（应该能看到 mcp__firecrawl__* 等）
claude -p "列出所有可用的 MCP 工具"

# 小规模测试
claude -p "用 WebFetch 抓取 https://docs.anthropic.com 首页，提取标题和导航菜单" \
  --allowedTools "WebFetch,Write"
```

### 调试技巧

```bash
# 查看子进程日志
tail -f .research/xxx/logs/task1.log

# 检查调度脚本
cat .research/xxx/run_children.sh

# 验证 prompt 生成
cat .research/xxx/prompts/task1.md
```

---

## 常见问题

### Q1: 子进程超时怎么办？
默认 5 分钟超时。如果任务复杂：
- 主控会自动重试或拆分
- 可在确认阶段要求"延长超时到 15 分钟"

### Q2: 没有 Firecrawl 能用吗？
能用，会降级到 WebFetch/WebSearch，但：
- 无法递归抓取网站
- PDF 提取能力有限
- 并发受限

### Q3: 报告质量不满意？
技能内置"双重质检"：
1. 检查是否分章节整合（非一次性生成）
2. 评估详细程度（素材不足 vs 压缩过度）

如果不满意，会自动补充调研或扩展润色。

### Q4: 子进程看不到进度？
使用监控命令：
```bash
# 实时查看主日志
tail -f .research/xxx/logs/dispatcher.log

# 查看所有子任务状态
ls -lh .research/xxx/child_outputs/
```

---

## 下一步

### 最小配置（立即可用）
```bash
# 无需任何配置，直接使用
/deep-research
# 或
深度调研 XXX 的 YYY
```

### 推荐配置（获得最佳体验）
```bash
# 1. 配置 Firecrawl
npm install -g @firecrawl/mcp-server

# 2. 编辑 .mcp.json 添加 firecrawl 配置

# 3. 重启 Claude Code
```

### 高级配置
- 配置 Exa（语义搜索）
- 创建自定义 skills（特定领域采集）
- 调整并发参数（默认 8 个子进程）

---

## 实战案例

想试试吗？给我一个主题，比如：
- "调研 Rust 异步编程的最佳实践"
- "对比主流 AI Agent 框架的架构设计"
- "分析最近 3 个月 LLM 领域的重要进展"

我会走完整流程，生成一份详实的调研报告 📊
