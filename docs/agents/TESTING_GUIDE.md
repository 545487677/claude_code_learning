# Agents 测试指南

> 完整的 Agents 测试方法和实践指南

## 📋 目录

1. [测试准备](#测试准备)
2. [按领域测试](#按领域测试)
3. [高级测试](#高级测试)
4. [所有 Agents 测试清单](#所有-agents-测试清单)
5. [Agent 编排测试](#agent-编排测试)
6. [问题排查](#问题排查)

## 测试准备

### 环境检查

```bash
# 1. 查看所有 Agents
ls .claude/agents/

# 2. 统计 Agent 数量
ls .claude/agents/*.md | wc -l

# 3. 查看 Agent 分类
ls .claude/agents/ | grep -E "(pro|expert|specialist|developer|engineer)" | sort
```

### Agent 分类

Agents 按后缀分类：
- **-pro**: 专业级开发（python-pro, typescript-pro）
- **-expert**: 专家级（docker-expert, rust-expert）
- **-specialist**: 专项专家（react-specialist, kubernetes-specialist）
- **-developer**: 开发者（frontend-developer, backend-developer）
- **-engineer**: 工程师（ml-engineer, data-engineer）
- **-architect**: 架构师（java-architect, cloud-architect）
- **-analyst**: 分析师（data-analyst, research-analyst）
- **-manager**: 管理者（product-manager, project-manager）

## 按领域测试

### 1. 编程语言类 Agents

#### python-pro

**测试目的**：验证 Python 专业开发能力

**测试1：类型安全代码**
```
使用 python-pro agent 帮我写一个类型安全的 API 客户端
```

**预期输出**：
```python
from typing import Dict, List, Optional, Any
from dataclasses import dataclass
import httpx
import asyncio

@dataclass
class APIResponse:
    status: int
    data: Dict[str, Any]
    headers: Dict[str, str]

class APIClient:
    def __init__(self, base_url: str, api_key: str) -> None:
        self.base_url = base_url
        self.api_key = api_key
        self.client = httpx.AsyncClient(
            headers={"Authorization": f"Bearer {api_key}"}
        )

    async def get(self, endpoint: str) -> APIResponse:
        response = await self.client.get(f"{self.base_url}/{endpoint}")
        return APIResponse(
            status=response.status_code,
            data=response.json(),
            headers=dict(response.headers)
        )
```

**评分标准**：
- ✅ 使用类型注解（typing）
- ✅ 使用 dataclass 或 pydantic
- ✅ 异步支持（async/await）
- ✅ 错误处理
- ✅ 文档字符串

**测试2：现代异步模式**
```
使用 python-pro 优化这段同步代码为异步：

def fetch_users(user_ids):
    results = []
    for user_id in user_ids:
        response = requests.get(f"/api/users/{user_id}")
        results.append(response.json())
    return results
```

**预期输出**：
```python
import asyncio
import httpx
from typing import List, Dict, Any

async def fetch_user(client: httpx.AsyncClient, user_id: int) -> Dict[str, Any]:
    response = await client.get(f"/api/users/{user_id}")
    response.raise_for_status()
    return response.json()

async def fetch_users(user_ids: List[int]) -> List[Dict[str, Any]]:
    async with httpx.AsyncClient() as client:
        tasks = [fetch_user(client, user_id) for user_id in user_ids]
        return await asyncio.gather(*tasks)
```

#### typescript-pro

**测试**：
```
使用 typescript-pro agent 创建一个类型安全的 React Hook
```

**预期输出**：
```typescript
import { useState, useEffect, useCallback } from 'react';

interface UseFetchOptions {
  immediate?: boolean;
}

interface UseFetchReturn<T> {
  data: T | null;
  loading: boolean;
  error: Error | null;
  refetch: () => Promise<void>;
}

function useFetch<T>(
  url: string,
  options: UseFetchOptions = {}
): UseFetchReturn<T> {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<Error | null>(null);

  const fetchData = useCallback(async () => {
    setLoading(true);
    try {
      const response = await fetch(url);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const json = await response.json();
      setData(json);
    } catch (e) {
      setError(e as Error);
    } finally {
      setLoading(false);
    }
  }, [url]);

  useEffect(() => {
    if (options.immediate !== false) {
      fetchData();
    }
  }, [fetchData, options.immediate]);

  return { data, loading, error, refetch: fetchData };
}

export default useFetch;
```

#### javascript-pro

**测试**：
```
使用 javascript-pro 实现一个事件总线
```

#### golang-pro

**测试**：
```
使用 golang-pro 实现一个并发安全的缓存
```

**预期输出**：
```go
package cache

import (
    "sync"
    "time"
)

type item struct {
    value      interface{}
    expiration int64
}

type Cache struct {
    mu    sync.RWMutex
    items map[string]item
}

func New() *Cache {
    return &Cache{
        items: make(map[string]item),
    }
}

func (c *Cache) Set(key string, value interface{}, duration time.Duration) {
    c.mu.Lock()
    defer c.mu.Unlock()

    var expiration int64
    if duration > 0 {
        expiration = time.Now().Add(duration).UnixNano()
    }

    c.items[key] = item{
        value:      value,
        expiration: expiration,
    }
}

func (c *Cache) Get(key string) (interface{}, bool) {
    c.mu.RLock()
    defer c.mu.RUnlock()

    item, found := c.items[key]
    if !found {
        return nil, false
    }

    if item.expiration > 0 && time.Now().UnixNano() > item.expiration {
        return nil, false
    }

    return item.value, true
}
```

#### rust-engineer

**测试**：
```
使用 rust-engineer 实现一个内存安全的链表
```

### 2. 框架类 Agents

#### react-specialist

**测试1：性能优化**
```
使用 react-specialist 优化这个组件的性能：

function UserList({ users }) {
  return (
    <div>
      {users.map(user => (
        <div key={user.id}>
          <h3>{user.name}</h3>
          <p>{user.email}</p>
        </div>
      ))}
    </div>
  );
}
```

**预期优化**：
- useMemo 优化列表
- React.memo 包装组件
- 虚拟滚动（如果列表很长）
- key 优化

**测试2：状态管理**
```
使用 react-specialist 设计一个全局状态管理方案
```

#### vue-expert

**测试**：
```
使用 vue-expert 创建一个 Composition API 组件
```

#### nextjs-developer

**测试**：
```
使用 nextjs-developer 实现一个 SSR 页面
```

#### angular-architect

**测试**：
```
使用 angular-architect 设计一个大型应用架构
```

### 3. 后端类 Agents

#### backend-developer

**测试**：
```
使用 backend-developer 设计一个 RESTful API
```

#### fastapi-developer

**测试**：
```
使用 fastapi-developer 创建一个异步 API 服务
```

#### django-developer

**测试**：
```
使用 django-developer 实现一个 Django REST Framework API
```

#### spring-boot-engineer

**测试**：
```
使用 spring-boot-engineer 创建一个微服务
```

### 4. 数据库类 Agents

#### database-administrator

**测试**：
```
使用 database-administrator 优化这个 SQL 查询
```

#### postgres-pro

**测试**：
```
使用 postgres-pro 设计一个高性能的数据库架构
```

#### sql-pro

**测试**：
```
使用 sql-pro 编写复杂的分析查询
```

### 5. DevOps/基础设施类 Agents

#### devops-engineer

**测试**：
```
使用 devops-engineer 设计 CI/CD 流程
```

#### kubernetes-specialist

**测试**：
```
使用 kubernetes-specialist 部署一个微服务应用
```

**预期输出**：
```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
  labels:
    app: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: myapp:1.0.0
        ports:
        - containerPort: 8080
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
---
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  selector:
    app: myapp
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
  type: LoadBalancer
```

#### docker-expert

**测试**：
```
使用 docker-expert 优化这个 Dockerfile
```

#### terraform-engineer

**测试**：
```
使用 terraform-engineer 创建 AWS 基础设施
```

### 6. AI/ML 类 Agents

#### ml-engineer

**测试**：
```
使用 ml-engineer 构建一个机器学习训练流程
```

#### data-scientist

**测试**：
```
使用 data-scientist 分析这个数据集并建立预测模型
```

#### nlp-engineer

**测试**：
```
使用 nlp-engineer 实现一个文本分类系统
```

### 7. 分析/研究类 Agents

#### research-analyst

**测试**：
```
使用 research-analyst 调研最新的 LLM 技术趋势
```

**预期输出**：
- 系统化的研究报告
- 多个可信来源
- 趋势分析
- 未来预测

#### data-analyst

**测试**：
```
使用 data-analyst 分析用户行为数据
```

#### competitive-analyst

**测试**：
```
使用 competitive-analyst 分析竞争对手
```

### 8. 管理类 Agents

#### product-manager

**测试**：
```
使用 product-manager 制定产品路线图
```

#### project-manager

**测试**：
```
使用 project-manager 规划项目计划
```

#### scrum-master

**测试**：
```
使用 scrum-master 组织 Sprint 规划会议
```

## 高级测试

### Multi-Agent 协作测试

#### 场景1：全栈应用开发

```
1. 使用 product-manager 定义需求
2. 使用 backend-developer 设计 API
3. 使用 frontend-developer 实现前端
4. 使用 devops-engineer 配置部署
5. 使用 security-engineer 安全审计
```

#### 场景2：机器学习项目

```
1. 使用 data-scientist 分析数据
2. 使用 ml-engineer 训练模型
3. 使用 mlops-engineer 部署模型
4. 使用 data-engineer 构建数据管道
```

#### 场景3：大型重构项目

```
1. 使用 code-reviewer 审查现有代码
2. 使用 refactoring-specialist 规划重构
3. 使用 [language]-pro 实现重构
4. 使用 test-driven-development 编写测试
```

## 所有 Agents 测试清单

### 编程语言 (20+)

| Agent | 测试状态 | 评分 | 备注 |
|-------|---------|------|------|
| python-pro | ✅ | 9/10 | 类型安全、异步支持优秀 |
| typescript-pro | ✅ | 9/10 | 类型系统运用出色 |
| javascript-pro | ⬜ | - | 待测试 |
| golang-pro | ⬜ | - | 待测试 |
| rust-engineer | ⬜ | - | 待测试 |
| java-architect | ⬜ | - | 待测试 |
| csharp-developer | ⬜ | - | 待测试 |
| cpp-pro | ⬜ | - | 待测试 |
| kotlin-specialist | ⬜ | - | 待测试 |
| swift-expert | ⬜ | - | 待测试 |
| php-pro | ⬜ | - | 待测试 |
| elixir-expert | ⬜ | - | 待测试 |

### 框架 (15+)

| Agent | 测试状态 | 评分 | 备注 |
|-------|---------|------|------|
| react-specialist | ⬜ | - | 待测试 |
| vue-expert | ⬜ | - | 待测试 |
| angular-architect | ⬜ | - | 待测试 |
| nextjs-developer | ⬜ | - | 待测试 |
| django-developer | ⬜ | - | 待测试 |
| fastapi-developer | ⬜ | - | 待测试 |
| spring-boot-engineer | ⬜ | - | 待测试 |
| rails-expert | ⬜ | - | 待测试 |
| laravel-specialist | ⬜ | - | 待测试 |
| flutter-expert | ⬜ | - | 待测试 |

### DevOps/基础设施 (20+)

| Agent | 测试状态 | 评分 | 备注 |
|-------|---------|------|------|
| devops-engineer | ⬜ | - | 待测试 |
| kubernetes-specialist | ⬜ | - | 待测试 |
| docker-expert | ⬜ | - | 待测试 |
| terraform-engineer | ⬜ | - | 待测试 |
| cloud-architect | ⬜ | - | 待测试 |
| sre-engineer | ⬜ | - | 待测试 |
| platform-engineer | ⬜ | - | 待测试 |
| network-engineer | ⬜ | - | 待测试 |

### AI/ML (10+)

| Agent | 测试状态 | 评分 | 备注 |
|-------|---------|------|------|
| ml-engineer | ⬜ | - | 待测试 |
| data-scientist | ⬜ | - | 待测试 |
| mlops-engineer | ⬜ | - | 待测试 |
| nlp-engineer | ⬜ | - | 待测试 |
| ai-engineer | ⬜ | - | 待测试 |

## Agent 编排测试

### 编排模式

#### 顺序编排

```
使用以下 Agents 顺序完成任务：
1. product-manager - 需求分析
2. backend-developer - API 设计
3. frontend-developer - UI 实现
4. devops-engineer - 部署配置
```

#### 并行编排

```
并行使用以下 Agents：
- backend-developer - 后端开发
- frontend-developer - 前端开发
- data-engineer - 数据管道
```

#### 层级编排

```
项目总负责：project-manager

后端团队：
- backend-developer
- database-administrator
- api-designer

前端团队：
- frontend-developer
- ui-designer
- ux-researcher
```

## 问题排查

### 问题1：Agent 调用失败

**症状**：明确调用 Agent 但没有生效

**排查**：
```bash
# 检查 Agent 是否存在
ls .claude/agents/[agent-name].md

# 查看 Agent 定义
head -50 .claude/agents/[agent-name].md
```

### 问题2：Agent 输出质量不佳

**症状**：Agent 输出不符合预期专业水平

**可能原因**：
- 上下文不足
- 任务描述不清晰
- Agent 不适合当前任务

**解决方案**：
- 提供更多上下文
- 明确任务目标和约束
- 选择更合适的 Agent

### 问题3：多 Agent 协作混乱

**症状**：多个 Agent 同时工作导致混乱

**解决方案**：
- 使用明确的 Agent 名称
- 分阶段调用
- 使用 agent-organizer 协调

## 测试报告模板

```markdown
# [Agent 名称] 测试报告

**测试日期**：2026-03-25
**Agent 类型**：[类型]
**专业领域**：[领域]

## 测试场景

### 场景1：[场景名称]
**任务描述**：[描述]
**输入**：[输入]
**输出质量**：8/10
**符合规范**：✅
**改进建议**：[建议]

### 场景2：[场景名称]
...

## 总体评价

| 维度 | 评分 |
|------|------|
| 专业度 | 9/10 |
| 代码质量 | 8/10 |
| 响应速度 | 9/10 |
| 文档完善 | 7/10 |

**总分**：33/40 (82.5%)

## 推荐场景
- [适用场景1]
- [适用场景2]

## 不推荐场景
- [不适用场景1]
```

## 最佳实践

1. **选择正确的 Agent**
   - 根据任务类型选择
   - 考虑专业领域匹配度

2. **提供充分上下文**
   - 说明项目背景
   - 明确技术栈
   - 描述约束条件

3. **验证输出质量**
   - 代码可运行性
   - 符合最佳实践
   - 安全性检查

4. **组合使用**
   - 多 Agent 协作
   - 发挥各自专长
   - 系统化完成任务

---

**下一步**：测试所有 Agents，完成测试清单 ✓
