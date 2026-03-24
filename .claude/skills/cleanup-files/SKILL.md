---
name: cleanup-files
description: 清理项目中的临时文件、测试文件和不需要的文件
trigger: /cleanup-files
model: sonnet
---

# 项目文件清理工具

智能清理项目中的临时文件、测试文件、备份文件和其他不需要的文件。

## 执行步骤

### 1. 扫描项目文件

```bash
# 查找可能需要清理的文件
find . -type f \( \
  -name "*.tmp" -o \
  -name "*.bak" -o \
  -name "*.backup" -o \
  -name "*.old" -o \
  -name "*~" -o \
  -name "test_*.md" -o \
  -name "*.log" -o \
  -name ".DS_Store" -o \
  -name "Thumbs.db" \
\) | grep -v node_modules | grep -v .git
```

### 2. 分类显示

向用户展示找到的文件，按类型分组：

```
🔍 发现以下可清理文件:

临时文件:
  - ./temp.tmp
  - ./backup.bak

测试文件:
  - ./test_demo.md
  - ./test_pr_20260323.md

系统文件:
  - ./.DS_Store
```

### 3. 询问确认

显示文件列表后，询问用户确认：

```
⚠️  即将删除以上文件（共 X 个）

选项:
  1. 全部删除
  2. 逐个确认
  3. 取消操作

请输入选项 (1/2/3):
```

### 4. 执行清理

根据用户选择执行清理：

**选项1: 全部删除**
```bash
# 一次性删除所有文件
find . -type f \( -name "*.tmp" -o -name "*.bak" ... \) \
  | grep -v node_modules | grep -v .git | xargs rm -f

echo "✅ 已删除 X 个文件"
```

**选项2: 逐个确认**
```bash
# 逐个询问
while IFS= read -r file; do
  echo "删除 $file? (y/n)"
  read -r answer
  if [[ $answer == "y" ]]; then
    rm -f "$file"
    echo "✅ 已删除: $file"
  else
    echo "⏭️  跳过: $file"
  fi
done < <(find . -type f ...)
```

### 5. 清理空目录（可选）

```bash
# 查找并删除空目录
find . -type d -empty | grep -v ".git" | while read -r dir; do
  echo "发现空目录: $dir"
  echo "是否删除? (y/n)"
  read -r answer
  [[ $answer == "y" ]] && rmdir "$dir" && echo "✅ 已删除: $dir"
done
```

### 6. 生成清理报告

```
╔═══════════════════════════════════════╗
║  文件清理报告                         ║
╚═══════════════════════════════════════╝

清理统计:
  ✅ 临时文件: 3个
  ✅ 测试文件: 2个
  ✅ 系统文件: 1个
  ✅ 空目录: 1个

释放空间: ~2.5 MB

清理文件列表:
  - temp.tmp
  - backup.bak
  - test_demo.md
  - test_pr_20260323.md
  - .DS_Store
  - empty_folder/

🎉 清理完成！
```

## 文件类型定义

### 临时文件
```bash
*.tmp
*.temp
*.swp
*.swo
*~
*.cache
```

### 备份文件
```bash
*.bak
*.backup
*.old
*.orig
*.BAK
```

### 测试文件
```bash
test_*.md
*_test.txt
demo_*.js
tmp_*.py
```

### 系统文件
```bash
.DS_Store          # macOS
Thumbs.db          # Windows
desktop.ini        # Windows
*.lnk              # Windows快捷方式
```

### 日志文件
```bash
*.log
*.log.*
logs/*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
```

## 安全规则

### 永远不删除的文件
```bash
# Git相关
.git/
.gitignore
.gitattributes

# 配置文件
package.json
tsconfig.json
.env
.env.*

# 文档
README.md
LICENSE
CHANGELOG.md

# 源代码
*.ts (unless test_*.ts)
*.js (unless test_*.js or *.test.js)
*.py (unless test_*.py)
```

### 需要特别确认的
```bash
# 可能包含重要数据
*.db
*.sqlite
*.json (data files)

# 构建产物（可能需要）
dist/
build/
node_modules/
```

## 使用示例

### 基础用法

```
用户: /cleanup-files

Claude:
🔍 正在扫描项目文件...

发现 8 个可清理文件:

【临时文件】(3个)
  - ./temp.tmp (1.2 KB)
  - ./cache.cache (45 KB)
  - ./backup.bak (120 KB)

【测试文件】(3个)
  - ./test_demo.md (2 KB)
  - ./test_pr_20260323.md (1 KB)
  - ./docs/test_skill.md (1.5 KB)

【系统文件】(2个)
  - ./.DS_Store (6 KB)
  - ./Thumbs.db (8 KB)

⚠️  总计: 8个文件, ~185 KB

1️⃣ 全部删除
2️⃣ 逐个确认
3️⃣ 取消操作

请选择 (1/2/3):

用户: 1

Claude:
🗑️  正在删除文件...
✅ 已删除: temp.tmp
✅ 已删除: cache.cache
✅ 已删除: backup.bak
✅ 已删除: test_demo.md
✅ 已删除: test_pr_20260323.md
✅ 已删除: test_skill.md
✅ 已删除: .DS_Store
✅ 已删除: Thumbs.db

🎉 清理完成！共删除 8 个文件，释放 ~185 KB 空间。
```

### 高级选项

```bash
# 只清理特定类型
/cleanup-files --type=temp        # 只清理临时文件
/cleanup-files --type=test        # 只清理测试文件
/cleanup-files --type=system      # 只清理系统文件

# 只扫描，不删除
/cleanup-files --dry-run          # 预览模式

# 清理旧文件（超过N天未修改）
/cleanup-files --older-than=30    # 清理30天前的文件

# 排除某些目录
/cleanup-files --exclude=dist,build
```

## 配置文件（可选）

可以创建 `.cleanuprc.json` 配置清理规则：

```json
{
  "patterns": {
    "temp": ["*.tmp", "*.cache", "*~"],
    "backup": ["*.bak", "*.backup", "*.old"],
    "test": ["test_*.md", "*_test.js"],
    "system": [".DS_Store", "Thumbs.db"]
  },
  "exclude": [
    "node_modules",
    ".git",
    "dist",
    "build"
  ],
  "safePatterns": [
    "*.md",
    "package.json",
    "tsconfig.json"
  ]
}
```

## 注意事项

1. ⚠️ 删除操作**不可逆**，请仔细确认
2. ✅ 建议先使用 `--dry-run` 预览
3. ✅ 重要文件请先提交到 Git
4. ✅ 清理前会显示文件大小和数量
5. ⚠️ 某些系统文件可能由 IDE 自动生成
6. ✅ 可以随时按 Ctrl+C 取消操作

## 集成到工作流

可以在其他 skill 中调用：

```bash
# 在 push-test-merge 前先清理
/cleanup-files --auto-confirm
/push-test-merge
```

或添加到 Git hooks:
```bash
# .git/hooks/pre-commit
/cleanup-files --dry-run
```

## 常见问题

**Q: 如何恢复误删的文件？**
A: 如果文件已提交到 Git，使用 `git checkout <file>`。未提交的文件无法恢复。

**Q: 可以自定义清理规则吗？**
A: 可以，创建 `.cleanuprc.json` 文件配置规则。

**Q: 会删除 node_modules 吗？**
A: 不会，默认排除 node_modules、.git 等重要目录。

**Q: 如何只清理特定目录？**
A: 使用 `/cleanup-files --path=./docs` 指定目录。
