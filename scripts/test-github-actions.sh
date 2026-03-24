#!/bin/bash
# GitHub Actions API 测试脚本

# 配置（需要设置 GitHub Personal Access Token）
GITHUB_TOKEN="${GITHUB_TOKEN:-your_github_token_here}"
REPO_OWNER="545487677"
REPO_NAME="claude_code_learning"
WORKFLOW_FILE="branch-cleanup.yml"

# 颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 GitHub Actions CI/CD 测试工具${NC}\n"

# 1. 触发工作流
trigger_workflow() {
    echo -e "${YELLOW}📤 触发工作流...${NC}"

    response=$(curl -s -X POST \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/actions/workflows/$WORKFLOW_FILE/dispatches" \
        -d '{"ref":"main","inputs":{"dry_run":"true"}}')

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ 工作流已触发${NC}\n"
    else
        echo -e "❌ 触发失败: $response"
        exit 1
    fi
}

# 2. 查看最近的运行
list_runs() {
    echo -e "${YELLOW}📋 查看最近的运行记录...${NC}\n"

    runs=$(curl -s \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/actions/workflows/$WORKFLOW_FILE/runs?per_page=3")

    # 使用 jq 解析 JSON（如果安装了）
    if command -v jq &> /dev/null; then
        echo "$runs" | jq -r '.workflow_runs[] | "\(.status) - \(.conclusion // "running") - \(.created_at) - \(.html_url)"'
    else
        echo "$runs"
    fi
}

# 3. 查看工作流详情
view_workflow() {
    echo -e "\n${YELLOW}📊 工作流信息:${NC}"
    echo "  仓库: https://github.com/$REPO_OWNER/$REPO_NAME"
    echo "  工作流: $WORKFLOW_FILE"
    echo "  Actions: https://github.com/$REPO_OWNER/$REPO_NAME/actions"
    echo ""
}

# 主菜单
case "${1:-menu}" in
    trigger)
        trigger_workflow
        ;;
    list)
        list_runs
        ;;
    view)
        view_workflow
        ;;
    *)
        view_workflow
        echo -e "${BLUE}使用方法:${NC}"
        echo "  $0 trigger  - 触发工作流"
        echo "  $0 list     - 查看运行记录"
        echo "  $0 view     - 查看工作流信息"
        echo ""
        echo -e "${YELLOW}提示:${NC} 请先设置 GITHUB_TOKEN 环境变量"
        echo "  export GITHUB_TOKEN='your_token_here'"
        ;;
esac
