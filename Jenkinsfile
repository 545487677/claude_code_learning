// Jenkins 流水线配置
// 将此文件保存为 Jenkinsfile

pipeline {
    agent any

    // 定时触发：每周一凌晨2点
    triggers {
        cron('0 2 * * 1')
    }

    // 环境变量
    environment {
        GIT_USER_NAME = 'Jenkins CI'
        GIT_USER_EMAIL = 'jenkins@example.com'
        CLEANUP_SCRIPT = 'scripts/cleanup-branches.sh'
    }

    // 参数化构建
    parameters {
        choice(
            name: 'MODE',
            choices: ['dry-run', 'execute'],
            description: '运行模式：dry-run 只显示，execute 实际删除'
        )
        booleanParam(
            name: 'CLEANUP_REMOTE',
            defaultValue: true,
            description: '是否清理远程分支'
        )
    }

    stages {
        stage('准备') {
            steps {
                script {
                    echo "🚀 开始分支清理流程..."
                    echo "模式: ${params.MODE}"
                    echo "清理远程分支: ${params.CLEANUP_REMOTE}"
                }
            }
        }

        stage('检出代码') {
            steps {
                checkout scm
                sh '''
                    git config user.name "${GIT_USER_NAME}"
                    git config user.email "${GIT_USER_EMAIL}"
                    git fetch --all --prune
                '''
            }
        }

        stage('分析分支') {
            steps {
                script {
                    def localBranches = sh(
                        script: 'git branch | grep -v "main" | wc -l',
                        returnStdout: true
                    ).trim()

                    def remoteBranches = sh(
                        script: 'git branch -r | grep -v "main" | grep -v "HEAD" | wc -l',
                        returnStdout: true
                    ).trim()

                    echo "📊 分支统计："
                    echo "  - 待清理本地分支: ${localBranches}"
                    echo "  - 待清理远程分支: ${remoteBranches}"

                    // 设置环境变量供后续使用
                    env.LOCAL_BRANCH_COUNT = localBranches
                    env.REMOTE_BRANCH_COUNT = remoteBranches
                }
            }
        }

        stage('执行清理') {
            when {
                expression {
                    env.LOCAL_BRANCH_COUNT.toInteger() > 0 ||
                    env.REMOTE_BRANCH_COUNT.toInteger() > 0
                }
            }
            steps {
                script {
                    sh "chmod +x ${CLEANUP_SCRIPT}"

                    if (params.MODE == 'dry-run') {
                        echo "🔍 Dry Run 模式 - 仅显示将要删除的分支"
                        sh '''
                            echo "本地分支:"
                            git branch | grep -v "main" || echo "  (无)"
                            echo ""
                            echo "远程分支:"
                            git branch -r | grep -v "main" | grep -v "HEAD" || echo "  (无)"
                        '''
                    } else {
                        echo "🗑️  执行实际清理..."
                        sh "./${CLEANUP_SCRIPT}"
                    }
                }
            }
        }

        stage('生成报告') {
            steps {
                script {
                    def report = """
                        ╔═══════════════════════════════════════╗
                        ║     分支清理报告                      ║
                        ╚═══════════════════════════════════════╝

                        执行时间: ${new Date()}
                        运行模式: ${params.MODE}
                        触发方式: ${currentBuild.getBuildCauses()[0].shortDescription}

                        清理统计:
                          - 本地分支: ${env.LOCAL_BRANCH_COUNT}
                          - 远程分支: ${env.REMOTE_BRANCH_COUNT}

                        状态: ${currentBuild.result ?: 'SUCCESS'}
                    """

                    echo report

                    // 保存报告为构建产物
                    writeFile file: 'cleanup-report.txt', text: report
                    archiveArtifacts artifacts: 'cleanup-report.txt', fingerprint: true
                }
            }
        }
    }

    post {
        success {
            script {
                echo "✅ 分支清理成功完成！"
                // 可以在这里添加成功通知，如发送邮件或Slack消息
                // emailext (
                //     subject: "✅ 分支清理成功 - ${env.JOB_NAME}",
                //     body: "分支清理任务已成功完成。",
                //     to: "team@example.com"
                // )
            }
        }

        failure {
            script {
                echo "❌ 分支清理失败！"
                // 发送失败通知
                // emailext (
                //     subject: "❌ 分支清理失败 - ${env.JOB_NAME}",
                //     body: "分支清理任务执行失败，请检查构建日志。",
                //     to: "team@example.com"
                // )
            }
        }

        always {
            script {
                // 清理工作区
                cleanWs()
            }
        }
    }
}
