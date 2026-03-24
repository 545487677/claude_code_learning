import Anthropic from '@anthropic-ai/sdk';
import { execSync } from 'child_process';
import * as fs from 'fs';

const client = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
});

interface BranchAnalysis {
  safe_to_delete: string[];
  keep: string[];
  reason: string;
}

async function analyzeAndCleanup() {
  console.log('🤖 使用 Claude API 进行智能分支清理...\n');

  try {
    // 1. 获取分支信息
    console.log('📊 收集分支信息...');
    const branches = execSync('git branch -a').toString();
    const branchDetails = execSync(
      'git for-each-ref --sort=-committerdate refs/heads/ --format="%(refname:short)|%(committerdate:relative)|%(authorname)"'
    ).toString();

    // 2. 让 Claude 分析哪些分支可以安全删除
    console.log('🧠 正在分析分支...\n');

    const message = await client.messages.create({
      model: 'claude-sonnet-4-6',
      max_tokens: 2000,
      messages: [
        {
          role: 'user',
          content: `你是一个 Git 分支管理专家。分析以下 Git 分支列表，识别可以安全删除的分支。

分支列表：
${branches}

分支详细信息（格式: 分支名|最后提交时间|作者）：
${branchDetails}

安全删除的标准：
1. 已经很久没有更新的分支（超过3个月）
2. 明显的测试分支（包含 test, tmp, demo 等关键词）
3. 已经合并到 main 的特性分支
4. 个人实验分支

必须保留的分支：
1. main 或 master 主分支
2. develop 开发分支
3. release 发布分支
4. 最近活跃的分支（1周内有提交）

请以JSON格式返回分析结果，只返回JSON，不要其他文字：
{
  "safe_to_delete": ["branch1", "branch2"],
  "keep": ["main", "develop"],
  "reason": "简要说明删除和保留的原因"
}`,
        },
      ],
    });

    const responseText = message.content[0].text;
    console.log('Claude 分析结果：');
    console.log(responseText);
    console.log('');

    // 3. 解析 JSON 响应
    const jsonMatch = responseText.match(/\{[\s\S]*\}/);
    if (!jsonMatch) {
      throw new Error('无法解析 Claude 的响应');
    }

    const analysis: BranchAnalysis = JSON.parse(jsonMatch[0]);

    // 4. 显示分析结果
    console.log('═══════════════════════════════════════');
    console.log('📋 分支分析报告');
    console.log('═══════════════════════════════════════\n');

    console.log(`💡 分析原因：${analysis.reason}\n`);

    console.log('🗑️  建议删除的分支：');
    if (analysis.safe_to_delete.length === 0) {
      console.log('  (无)');
    } else {
      analysis.safe_to_delete.forEach((branch) => {
        console.log(`  - ${branch}`);
      });
    }

    console.log('\n✅ 建议保留的分支：');
    analysis.keep.forEach((branch) => {
      console.log(`  - ${branch}`);
    });

    // 5. 执行清理（需要确认）
    if (analysis.safe_to_delete.length > 0) {
      console.log('\n⚠️  即将删除以上分支...');

      // 在 CI/CD 环境中，可以通过环境变量控制是否自动执行
      const autoExecute = process.env.AUTO_EXECUTE === 'true';

      if (autoExecute) {
        console.log('🤖 自动执行模式已启用\n');
        executeDeletion(analysis.safe_to_delete);
      } else {
        console.log(
          '💡 提示: 设置环境变量 AUTO_EXECUTE=true 可自动执行删除'
        );
        console.log('当前为预览模式，不会实际删除分支');
      }
    } else {
      console.log('\n✨ 没有需要清理的分支！');
    }

    // 6. 保存报告
    const report = {
      timestamp: new Date().toISOString(),
      analysis,
      executed: process.env.AUTO_EXECUTE === 'true',
    };

    fs.writeFileSync(
      'branch-cleanup-report.json',
      JSON.stringify(report, null, 2)
    );
    console.log('\n📄 报告已保存到: branch-cleanup-report.json');
  } catch (error) {
    console.error('❌ 错误:', error);
    process.exit(1);
  }
}

function executeDeletion(branches: string[]) {
  console.log('开始执行删除...\n');

  let successCount = 0;
  let failCount = 0;

  for (const branch of branches) {
    try {
      // 删除本地分支
      execSync(`git branch -D ${branch}`, { stdio: 'inherit' });
      console.log(`✅ 已删除本地分支: ${branch}`);

      // 尝试删除远程分支（如果存在）
      try {
        execSync(`git push origin --delete ${branch}`, { stdio: 'inherit' });
        console.log(`✅ 已删除远程分支: ${branch}`);
      } catch (e) {
        // 远程分支可能不存在，忽略错误
      }

      successCount++;
    } catch (error) {
      console.error(`❌ 无法删除分支: ${branch}`);
      console.error(error);
      failCount++;
    }
  }

  console.log('\n═══════════════════════════════════════');
  console.log('📊 清理统计');
  console.log('═══════════════════════════════════════');
  console.log(`✅ 成功: ${successCount}`);
  console.log(`❌ 失败: ${failCount}`);
  console.log(`📝 总计: ${branches.length}`);
}

// 执行主函数
analyzeAndCleanup().catch((error) => {
  console.error('Fatal error:', error);
  process.exit(1);
});
