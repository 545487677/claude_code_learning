#!/bin/bash
set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🧹 开始清理分支...${NC}"

# 1. 确认在main分支
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo -e "${YELLOW}切换到main分支...${NC}"
    git checkout main
fi

# 2. 更新main分支
echo -e "${YELLOW}更新main分支...${NC}"
git pull origin main

# 3. 列出要删除的分支
LOCAL_BRANCHES=$(git branch | grep -v "main" | grep -v "\*" | sed 's/^[ \t]*//' || true)
REMOTE_BRANCHES=$(git branch -r | grep -v "main" | grep -v "HEAD" | sed 's/origin\///' | sed 's/^[ \t]*//' || true)

echo -e "\n${YELLOW}将要删除的本地分支:${NC}"
if [ -n "$LOCAL_BRANCHES" ]; then
    echo "$LOCAL_BRANCHES" | while read -r branch; do
        echo "  - $branch"
    done
else
    echo "  (无)"
fi

echo -e "\n${YELLOW}将要删除的远程分支:${NC}"
if [ -n "$REMOTE_BRANCHES" ]; then
    echo "$REMOTE_BRANCHES" | while read -r branch; do
        echo "  - $branch"
    done
else
    echo "  (无)"
fi

# 4. 删除本地分支
if [ -n "$LOCAL_BRANCHES" ]; then
    echo -e "\n${YELLOW}删除本地分支...${NC}"
    echo "$LOCAL_BRANCHES" | while read -r branch; do
        if [ -n "$branch" ]; then
            git branch -D "$branch" && echo -e "${GREEN}✅ 删除本地分支: $branch${NC}"
        fi
    done
fi

# 5. 删除远程分支
if [ -n "$REMOTE_BRANCHES" ]; then
    echo -e "\n${YELLOW}删除远程分支...${NC}"
    echo "$REMOTE_BRANCHES" | while read -r branch; do
        if [ -n "$branch" ]; then
            git push origin --delete "$branch" && echo -e "${GREEN}✅ 删除远程分支: $branch${NC}" || true
        fi
    done
fi

# 6. 清理引用
echo -e "\n${YELLOW}清理远程引用...${NC}"
git remote prune origin

# 7. 显示结果
echo -e "\n${GREEN}🎉 分支清理完成！${NC}"
echo -e "\n当前分支状态:"
git branch -a
