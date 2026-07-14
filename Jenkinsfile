pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(
            logRotator(
                daysToKeepStr: '14',
                numToKeepStr: '20'
            )
        )
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm

                sh '''
                    echo "Branch: ${BRANCH_NAME}"
                    echo "Commit: ${GIT_COMMIT}"
                    echo "Build:  ${BUILD_NUMBER}"

                    mkdir -p pipeline-reports
                '''
            }
        }

        stage('Validate Branch') {
            steps {
                script {
                    if (!(env.BRANCH_NAME in ['dev', 'main'])) {
                        error "Unsupported branch: ${env.BRANCH_NAME}"
                    }
                }
            }
        }

        stage('Terraform Validate and Plan') {
            when {
                branch 'dev'
            }

            steps {
                withCredentials([
                    string(
                        credentialsId: 'azure-client-id',
                        variable: 'ARM_CLIENT_ID'
                    ),
                    string(
                        credentialsId: 'azure-client-secret',
                        variable: 'ARM_CLIENT_SECRET'
                    ),
                    string(
                        credentialsId: 'azure-tenant-id',
                        variable: 'ARM_TENANT_ID'
                    ),
                    string(
                        credentialsId: 'azure-subscription-id',
                        variable: 'ARM_SUBSCRIPTION_ID'
                    )
                ]) {
                    sh './jenkins/terraform-validate.sh'
                }
            }

            post {
                always {
                    archiveArtifacts(
                        artifacts: 'pipeline-reports/terraform-plan.txt',
                        allowEmptyArchive: true,
                        fingerprint: true
                    )
                }
            }
        }

        stage('Ansible Validate') {
            when {
                branch 'dev'
            }

            steps {
                withCredentials([
                    string(
                        credentialsId: 'ansible-vault-password',
                        variable: 'ANSIBLE_VAULT_PASSWORD'
                    )
                ]) {
                    sh './jenkins/ansible-validate.sh'
                }
            }
        }

        stage('Build Application') {
            steps {
                sh './jenkins/build-application.sh'
            }
        }

        stage('SonarQube Analysis') {
    when {
        branch 'dev'
    }

    steps {
        withCredentials([
            string(
                credentialsId: 'sonarqube-token',
                variable: 'SONAR_AUTH_TOKEN'
            )
        ]) {
            withSonarQubeEnv('SonarQube') {
                sh './jenkins/sonarqube-scan.sh'
            }
        }
    }

    post {
        always {
            archiveArtifacts(
                artifacts: 'pipeline-reports/sonarqube-quality-gate.txt',
                allowEmptyArchive: true,
                fingerprint: true
            )
        }
    }
}

        stage('Trivy Security Scan') {
            when {
                branch 'dev'
            }

            steps {
                sh './jenkins/trivy-scan.sh'
            }

            post {
                always {
                    archiveArtifacts(
                        artifacts:
                            'pipeline-reports/trivy-jenkins-report.txt',
                        allowEmptyArchive: true,
                        fingerprint: true
                    )
                }
            }
        }

        stage('Package Application') {
            when {
                branch 'dev'
            }

            steps {
                sh './jenkins/package-application.sh'
            }

            post {
                success {
                    archiveArtifacts(
                        artifacts:
                            'application/CTInventoryPortal/' +
                            'CTInventoryPortal.zip',
                        fingerprint: true
                    )
                }
            }
        }

        stage('Deploy Application') {
            when {
                branch 'dev'
            }

            steps {
                withCredentials([
                    string(
                        credentialsId: 'ansible-vault-password',
                        variable: 'ANSIBLE_VAULT_PASSWORD'
                    ),
                    string(
                        credentialsId: 'appinsights-connection-string',
                        variable: 'APPINSIGHTS_CONNECTION_STRING'
                    )
                ]) {
                    sh './jenkins/deploy-application.sh'
                }
            }
        }

        stage('Platform Health Summary') {
            when {
                branch 'dev'
            }

            steps {
                withCredentials([
                    string(
                        credentialsId: 'ansible-vault-password',
                        variable: 'ANSIBLE_VAULT_PASSWORD'
                    )
                ]) {
                    sh './jenkins/platform-health.sh'
                }
            }

            post {
                always {
                    archiveArtifacts(
                        artifacts:
                            'pipeline-reports/platform-health-summary.txt',
                        allowEmptyArchive: true,
                        fingerprint: true
                    )
                }
            }
        }

        stage('Main Branch Summary') {
            when {
                branch 'main'
            }

            steps {
                sh '''
                    mkdir -p pipeline-reports

                    cat > pipeline-reports/platform-health-summary.txt <<REPORT
================================================================================
                  CT AZURE APPLICATION DELIVERY - BUILD SUMMARY
================================================================================
Branch                  : ${BRANCH_NAME}
Build Number            : ${BUILD_NUMBER}
Git Commit              : ${GIT_COMMIT}
.NET Build              : PASSED
Terraform Validation    : NOT RUN
Ansible Validation      : NOT RUN
SonarQube               : NOT RUN
Trivy                   : NOT RUN
Deployment              : NOT RUN
Platform Health Checks  : NOT RUN
================================================================================
MAIN BRANCH BUILD STATUS: SUCCESS
================================================================================
REPORT

                    cat pipeline-reports/platform-health-summary.txt
                '''
            }

            post {
                always {
                    archiveArtifacts(
                        artifacts:
                            'pipeline-reports/platform-health-summary.txt',
                        allowEmptyArchive: true,
                        fingerprint: true
                    )
                }
            }
        }
    }

    post {
        success {
            echo """
================================================================================
PIPELINE RESULT: SUCCESS
Branch: ${BRANCH_NAME}
Build:  ${BUILD_NUMBER}
URL:    ${BUILD_URL}
================================================================================
"""
        }

        failure {
            echo """
================================================================================
PIPELINE RESULT: FAILED
Branch: ${BRANCH_NAME}
Build:  ${BUILD_NUMBER}
URL:    ${BUILD_URL}
================================================================================
"""
        }

        always {
            deleteDir()
        }
    }
}
