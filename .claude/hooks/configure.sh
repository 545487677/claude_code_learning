#!/bin/bash
# Everything Claude Code Hooks 快速配置脚本

set -e

HOOKS_DIR=".claude/hooks"
TARGET_FILE=".claude/settings.json"

echo "🎯 Everything Claude Code Hooks 配置向导"
echo ""
echo "请选择配置级别："
echo ""
echo "1) 最小配置 (推荐初学者)"
echo "   - 只有会话管理 hooks"
echo "   - 最小性能影响"
echo ""
echo "2) 标准配置 (推荐日常使用)"
echo "   - Git push 提醒"
echo "   - 自动格式化"
echo "   - Console.log 检查"
echo "   - 会话管理和成本追踪"
echo ""
echo "3) 完整配置 (高级用户)"
echo "   - 所有质量检查"
echo "   - Tmux 集成"
echo "   - TypeScript 检查"
echo "   - 配置保护"
echo "   - 完整生命周期管理"
echo ""
read -p "请输入选择 (1-3): " choice

case $choice in
  1)
    echo "✓ 使用最小配置..."
    cp .claude/hooks-minimal.json "$TARGET_FILE"
    echo "✓ 已创建 $TARGET_FILE"
    ;;
  2)
    echo "✓ 使用标准配置..."
    cp .claude/hooks-standard.json "$TARGET_FILE"
    echo "✓ 已创建 $TARGET_FILE"
    ;;
  3)
    echo "✓ 使用完整配置..."
    cp .claude/hooks.json "$TARGET_FILE"
    echo "✓ 已创建 $TARGET_FILE"
    ;;
  *)
    echo "❌ 无效选择，退出"
    exit 1
    ;;
esac

echo ""
echo "✅ 配置完成！"
echo ""
echo "📋 下一步："
echo "1. 重启 Claude Code 以加载 hooks"
echo "2. 查看文档: cat $HOOKS_DIR/INSTALL.md"
echo "3. 测试配置: echo '{}' | node $HOOKS_DIR/session-start.js"
echo ""
echo "💡 提示："
echo "- 查看所有 hooks: ls $HOOKS_DIR/"
echo "- 自定义配置: 编辑 $TARGET_FILE"
echo "- 禁用特定 hook: export ECC_DISABLED_HOOKS='hook-id'"
echo ""
echo "🎉 享受自动化的工作流吧！"
