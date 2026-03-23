---
name: test
description: 自动检测并运行项目测试
trigger: /test
model: sonnet
---

# 项目测试自动化

自动检测项目类型并运行相应的测试命令。

## 执行步骤

### 1. 检测项目类型

检查项目中的特征文件：
- `package.json` → Node.js项目
- `pytest.ini` / `setup.py` → Python项目
- `go.mod` → Go项目
- `Cargo.toml` → Rust项目
- `composer.json` → PHP项目

### 2. 运行测试

根据项目类型执行测试：

**Node.js**:
```bash
# 检查package.json中的test脚本
if grep -q '"test"' package.json; then
  npm test
fi
```

**Python**:
```bash
# 使用pytest
pytest -v
```

**Go**:
```bash
go test -v ./...
```

**Rust**:
```bash
cargo test
```

**自定义测试脚本**:
```bash
# 检查是否有自定义测试脚本
if [ -f "scripts/test.sh" ]; then
  ./scripts/test.sh
fi
```

### 3. 报告结果

显示测试结果摘要：
```
╔═══════════════════════════════════════╗
║  测试执行报告                         ║
╚═══════════════════════════════════════╝

项目类型: Node.js
测试命令: npm test
执行时间: 2.5s

结果:
  ✅ 通过: 15
  ❌ 失败: 0
  ⏭️  跳过: 2

总计: 17 tests
状态: ✅ 所有测试通过
```

### 4. 错误处理

如果测试失败：
1. 显示失败的测试用例
2. 显示错误日志
3. 提供修复建议

## 使用示例

```
用户: /test

Claude:
🔍 检测到 Node.js 项目
📦 找到测试脚本: npm test
🚀 开始运行测试...

[测试输出]

✅ 测试完成！15/15 通过
```

## 参数选项

```
/test --watch       # 监视模式
/test --coverage    # 显示覆盖率
/test --verbose     # 详细输出
```
