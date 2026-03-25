# typescript-pro Agent 详解

<div align="center">

**TypeScript 专业开发代理**

**Professional TypeScript Development Agent**

⭐⭐⭐⭐⭐ 前端必备 | 官方 Agent

[简体中文](#简体中文) | [English](#english)

</div>

---

## 简体中文

### 📖 Agent 简介

**typescript-pro** 是一个**TypeScript 专业开发 Agent**，专注于类型安全、现代化模式和生产就绪的 TypeScript 代码。

**核心能力**：
- ✅ 高级类型系统运用
- ✅ 泛型编程
- ✅ 类型安全的 React 开发
- ✅ 严格模式代码
- ✅ 性能优化

### 🎯 核心原则

```
TypeScript = 类型安全 + 现代特性 + 最佳实践

Type-Safe → Maintainable → Scalable
类型安全 → 可维护 → 可扩展

Not:
  JavaScript + Type Annotations ❌
  JavaScript + 类型注解 ❌
```

### ⚙️ 工作原理

```
生成代码时:
1. 严格类型注解
   - 所有参数和返回值类型化
   - 使用 TypeScript 高级特性

2. 现代化模式
   - async/await
   - 可选链 ?.
   - 空值合并 ??

3. React 集成
   - 类型安全的 hooks
   - Props 接口定义
   - 泛型组件

4. 最佳实践
   - 单一职责
   - 不可变数据
   - 错误处理
```

### 💡 使用示例

#### 示例 1: 类型安全的 React Hook

**输入**：
```
使用 typescript-pro agent 创建一个类型安全的 useFetch Hook
```

**输出**：
```typescript
import { useState, useEffect, useCallback } from 'react';

interface UseFetchOptions {
  immediate?: boolean;
  headers?: Record<string, string>;
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
    setError(null);

    try {
      const response = await fetch(url, {
        headers: options.headers,
      });

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
  }, [url, options.headers]);

  useEffect(() => {
    if (options.immediate !== false) {
      fetchData();
    }
  }, [fetchData, options.immediate]);

  return { data, loading, error, refetch: fetchData };
}

export default useFetch;

// 使用示例
interface User {
  id: number;
  name: string;
  email: string;
}

function UserProfile() {
  const { data, loading, error } = useFetch<User>(
    '/api/user/123',
    { immediate: true }
  );

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;
  if (!data) return null;

  return (
    <div>
      <h1>{data.name}</h1>
      <p>{data.email}</p>
    </div>
  );
}
```

**特点**：
- ✅ 泛型 `<T>` 支持任意数据类型
- ✅ 接口定义清晰
- ✅ 完整的类型注解
- ✅ 错误处理类型安全
- ✅ React hooks 正确使用

#### 示例 2: 高级类型系统

**输入**：
```
使用 typescript-pro 创建一个类型安全的表单验证库
```

**输出**：
```typescript
// 定义验证规则类型
type ValidationRule<T> = {
  validate: (value: T) => boolean;
  message: string;
};

// 表单字段配置
type FieldConfig<T> = {
  value: T;
  rules: ValidationRule<T>[];
};

// 表单配置类型（映射类型）
type FormConfig<T> = {
  [K in keyof T]: FieldConfig<T[K]>;
};

// 验证结果类型
type ValidationErrors<T> = Partial<Record<keyof T, string>>;

// 表单验证类
class FormValidator<T extends Record<string, any>> {
  private config: FormConfig<T>;

  constructor(config: FormConfig<T>) {
    this.config = config;
  }

  validate(): ValidationErrors<T> {
    const errors: ValidationErrors<T> = {};

    for (const key in this.config) {
      const field = this.config[key];

      for (const rule of field.rules) {
        if (!rule.validate(field.value)) {
          errors[key] = rule.message;
          break;
        }
      }
    }

    return errors;
  }

  isValid(): boolean {
    return Object.keys(this.validate()).length === 0;
  }

  getValues(): T {
    const values = {} as T;
    for (const key in this.config) {
      values[key] = this.config[key].value;
    }
    return values;
  }
}

// 使用示例
interface UserForm {
  email: string;
  password: string;
  age: number;
}

const formValidator = new FormValidator<UserForm>({
  email: {
    value: 'user@example.com',
    rules: [
      {
        validate: (v) => v.includes('@'),
        message: 'Email must contain @'
      },
      {
        validate: (v) => v.length > 5,
        message: 'Email must be longer than 5 characters'
      }
    ]
  },
  password: {
    value: '12345678',
    rules: [
      {
        validate: (v) => v.length >= 8,
        message: 'Password must be at least 8 characters'
      }
    ]
  },
  age: {
    value: 25,
    rules: [
      {
        validate: (v) => v >= 18,
        message: 'Must be 18 or older'
      }
    ]
  }
});

// 类型安全的验证
const errors = formValidator.validate();
// errors 类型是 Partial<Record<"email" | "password" | "age", string>>

if (formValidator.isValid()) {
  const values = formValidator.getValues();
  // values 类型是 UserForm
  console.log(values.email); // 类型安全
}
```

**特点**：
- ✅ 泛型类 `<T>`
- ✅ 映射类型 `[K in keyof T]`
- ✅ 条件类型
- ✅ 完整的类型推断
- ✅ 类型安全的访问

#### 示例 3: API 客户端

**输入**：
```
使用 typescript-pro 创建一个类型安全的 REST API 客户端
```

**输出**：
```typescript
type HttpMethod = 'GET' | 'POST' | 'PUT' | 'DELETE';

interface RequestConfig {
  headers?: Record<string, string>;
  timeout?: number;
}

interface ApiResponse<T> {
  data: T;
  status: number;
  headers: Record<string, string>;
}

class ApiClient {
  private baseURL: string;
  private defaultHeaders: Record<string, string>;

  constructor(baseURL: string, headers: Record<string, string> = {}) {
    this.baseURL = baseURL;
    this.defaultHeaders = headers;
  }

  private async request<T>(
    method: HttpMethod,
    endpoint: string,
    body?: any,
    config?: RequestConfig
  ): Promise<ApiResponse<T>> {
    const url = `${this.baseURL}${endpoint}`;
    const headers = {
      ...this.defaultHeaders,
      ...config?.headers,
      'Content-Type': 'application/json',
    };

    const controller = new AbortController();
    const timeoutId = config?.timeout
      ? setTimeout(() => controller.abort(), config.timeout)
      : null;

    try {
      const response = await fetch(url, {
        method,
        headers,
        body: body ? JSON.stringify(body) : undefined,
        signal: controller.signal,
      });

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }

      const data = await response.json();

      return {
        data,
        status: response.status,
        headers: Object.fromEntries(response.headers.entries()),
      };
    } finally {
      if (timeoutId) clearTimeout(timeoutId);
    }
  }

  async get<T>(endpoint: string, config?: RequestConfig): Promise<ApiResponse<T>> {
    return this.request<T>('GET', endpoint, undefined, config);
  }

  async post<T, D = any>(
    endpoint: string,
    data: D,
    config?: RequestConfig
  ): Promise<ApiResponse<T>> {
    return this.request<T>('POST', endpoint, data, config);
  }

  async put<T, D = any>(
    endpoint: string,
    data: D,
    config?: RequestConfig
  ): Promise<ApiResponse<T>> {
    return this.request<T>('PUT', endpoint, data, config);
  }

  async delete<T>(endpoint: string, config?: RequestConfig): Promise<ApiResponse<T>> {
    return this.request<T>('DELETE', endpoint, undefined, config);
  }
}

// 使用示例
interface User {
  id: number;
  name: string;
  email: string;
}

interface CreateUserDto {
  name: string;
  email: string;
}

const api = new ApiClient('https://api.example.com', {
  'Authorization': 'Bearer token123'
});

// 类型安全的 API 调用
async function example() {
  // GET - 类型推断返回 User
  const { data: user } = await api.get<User>('/users/1');
  console.log(user.name); // 类型安全

  // POST - 类型安全的请求和响应
  const { data: newUser } = await api.post<User, CreateUserDto>(
    '/users',
    { name: 'John', email: 'john@example.com' }
  );

  // PUT
  await api.put<User, Partial<User>>(
    `/users/${user.id}`,
    { name: 'Jane' }
  );

  // DELETE
  await api.delete<void>(`/users/${user.id}`);
}
```

### 🚨 关键特性

| 特性 | 说明 | 示例 |
|------|------|------|
| **泛型** | 类型参数化 | `<T>`, `<K extends keyof T>` |
| **映射类型** | 类型转换 | `[K in keyof T]: T[K]` |
| **条件类型** | 类型判断 | `T extends U ? X : Y` |
| **工具类型** | 内置类型 | `Partial<T>`, `Record<K, T>` |
| **类型守卫** | 运行时检查 | `if (typeof x === 'string')` |

### 📋 最佳实践

#### 1. 严格模式
```typescript
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true
  }
}
```

#### 2. 接口 vs 类型
```typescript
// 接口 - 用于对象形状
interface User {
  id: number;
  name: string;
}

// 类型 - 用于联合、交叉等
type Status = 'pending' | 'approved' | 'rejected';
type ApiResult = Success | Error;
```

#### 3. 避免 any
```typescript
❌ 错误：
function process(data: any) {
  return data.value;
}

✅ 正确：
function process<T extends { value: string }>(data: T) {
  return data.value;
}
```

### 🔗 相关 Agents

| Agent | 关系 | 用途 |
|-------|------|------|
| **react-specialist** | 配合 | React 组件开发 |
| **frontend-developer** | 配合 | 前端架构 |
| **nextjs-developer** | 配合 | Next.js 开发 |

### ✨ 为什么推荐

1. **类型安全** 🎯
   - 编译时捕获错误
   - IDE 智能提示
   - 重构更安全

2. **代码质量** 📊
   - 自文档化
   - 减少运行时错误
   - 更好的可维护性

3. **开发效率** ⚡
   - 智能补全
   - 类型推断
   - 重构工具

4. **团队协作** 👥
   - 清晰的接口定义
   - 减少沟通成本
   - 统一代码风格

### 🆚 vs JavaScript

| 维度 | TypeScript | JavaScript |
|------|-----------|------------|
| **类型安全** | 编译时检查 | 运行时错误 |
| **IDE 支持** | 优秀 | 基础 |
| **重构** | 安全 | 危险 |
| **学习曲线** | 较陡 | 平缓 |
| **适用场景** | 大型项目 | 小型脚本 |

---

## English

### 📖 Agent Overview

**typescript-pro** is a **professional TypeScript development agent** focused on type-safe, modern patterns, and production-ready code.

### ✨ Why Recommended

1. **Type Safety** 🎯 - Catch errors at compile time
2. **Code Quality** 📊 - Self-documenting, maintainable
3. **Development Efficiency** ⚡ - Smart completion, type inference
4. **Team Collaboration** 👥 - Clear interfaces, unified style

---

**Made with ❤️ for TypeScript developers**
