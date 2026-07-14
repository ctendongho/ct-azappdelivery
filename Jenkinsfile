pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
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
                    echo "Commit: ${GIT_COMMIT:-$(git rev-parse --short HEAD 2>/dev/null || echo unknown)}"
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
                        variable: 'SONAR_TOKEN'
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
                        artifacts:
                            'pipeline-reports/sonarqube-quality-gate.txt',
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
                anyOf {
                    branch 'dev'
                    branch 'main'
                }
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

        stage('Approve Dev Deployment') {
            when {
                branch 'dev'
            }

            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    script {
                        env.APPROVED_BY = input(
                            message:
                                'Deploy this validated dev build to the Azure application servers?',
                            ok: 'Proceed with deployment',
                            submitterParameter: 'APPROVED_BY'
                        )
                    }
                }

                echo "Development deployment approved by ${env.APPROVED_BY}"
            }
        }

        stage('Deploy Application') {
            when {
                anyOf {
                    branch 'dev'
                    branch 'main'
                }
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

        stage('Dev Platform Health Summary') {
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

        stage('Main Production Health Summary') {
            when {
                branch 'main'
            }

            steps {
                withCredentials([
                    string(
                        credentialsId: 'ansible-vault-password',
                        variable: 'ANSIBLE_VAULT_PASSWORD'
                    )
                ]) {
                    sh '''#!/usr/bin/env bash

                        set +x
                        set -uo pipefail

                        mkdir -p pipeline-reports

                        REPORT="pipeline-reports/platform-health-summary.txt"
                        INVENTORY="ansible/inventory/hosts.ini"
                        VAULT_FILE="$(mktemp)"

                        cleanup() {
                            rm -f "${VAULT_FILE}"
                        }

                        trap cleanup EXIT

                        printf '%s' "${ANSIBLE_VAULT_PASSWORD}" \
                          > "${VAULT_FILE}"

                        chmod 600 "${VAULT_FILE}"

                        PASS_COUNT=0
                        FAIL_COUNT=0

                        print_row() {
                            printf "%-34s | %-9s | %s\\n" \
                              "$1" "$2" "$3" |
                            tee -a "${REPORT}"
                        }

                        check_component() {
                            COMPONENT="$1"
                            DETAILS="$2"
                            shift 2

                            if "$@" >/dev/null 2>&1; then
                                print_row \
                                  "${COMPONENT}" \
                                  "HEALTHY" \
                                  "${DETAILS}"

                                PASS_COUNT=$((PASS_COUNT + 1))
                            else
                                print_row \
                                  "${COMPONENT}" \
                                  "FAILED" \
                                  "${DETAILS}"

                                FAIL_COUNT=$((FAIL_COUNT + 1))
                            fi
                        }

                        cat > "${REPORT}" <<REPORT_HEADER
==========================================================================================
                 CT AZURE APPLICATION DELIVERY - PRODUCTION SUMMARY
==========================================================================================
Branch       : ${BRANCH_NAME}
Build        : ${BUILD_NUMBER}
Commit       : ${GIT_COMMIT:-$(git rev-parse --short HEAD 2>/dev/null || echo unknown)}
Build URL    : ${BUILD_URL}
==========================================================================================
COMPONENT                          | STATUS    | DETAILS
------------------------------------------------------------------------------------------
REPORT_HEADER

                        check_component \
                          ".NET Application Build" \
                          "Release build completed" \
                          test -f \
                          application/CTInventoryPortal/bin/Release/net8.0/CTInventoryPortal.dll

                        check_component \
                          "Application Package" \
                          "Deployment package generated" \
                          test -f \
                          application/CTInventoryPortal/CTInventoryPortal.zip

                        check_component \
                          "Inventory Website" \
                          "Public HTTPS returned 200" \
                          bash -c \
                          'test "$(curl -sS -o /dev/null -w "%{http_code}" https://ctinventorytracker.com)" = "200"'

                        check_component \
                          "Inventory Health Endpoint" \
                          "Public /health returned 200" \
                          bash -c \
                          'test "$(curl -sS -o /dev/null -w "%{http_code}" https://ctinventorytracker.com/health)" = "200"'

                        check_component \
                          "VMSS Application Servers" \
                          "Both IIS applications responded" \
                          ansible app_servers \
                          -i "${INVENTORY}" \
                          -m ansible.windows.win_uri \
                          -a \
                          'url=http://localhost/health method=GET status_code=200' \
                          --vault-password-file "${VAULT_FILE}"

                        check_component \
                          "SQL Server Services" \
                          "MSSQLSERVER running on both nodes" \
                          ansible sql_servers \
                          -i "${INVENTORY}" \
                          -m ansible.windows.win_shell \
                          -a \
                          'if ((Get-Service MSSQLSERVER).Status -ne "Running") { exit 1 }' \
                          --vault-password-file "${VAULT_FILE}"

                        check_component \
                          "SQL Cluster and AG" \
                          "Cluster and Availability Group healthy" \
                          ansible-playbook \
                          -i "${INVENTORY}" \
                          ansible/playbooks/validate-cluster.yml \
                          --vault-password-file "${VAULT_FILE}"

                        check_component \
                          "DNN SQL Listener" \
                          "Listener port 14330 reachable" \
                          ansible app_servers \
                          -i "${INVENTORY}" \
                          -m ansible.windows.win_shell \
                          -a \
                          'if (-not (Test-NetConnection CTInventoryListener.ad.ctinventorytracker.com -Port 14330 -InformationLevel Quiet)) { exit 1 }' \
                          --vault-password-file "${VAULT_FILE}"

                        check_component \
                          "Prometheus" \
                          "Health endpoint returned 200" \
                          bash -c \
                          'test "$(curl -sS -o /dev/null -w "%{http_code}" http://localhost:9090/-/healthy)" = "200"'

                        check_component \
                          "Grafana" \
                          "Grafana database status OK" \
                          bash -c \
                          'curl -sS http://localhost:3000/api/health | grep -q "\\"database\\": \\"ok\\""'

                        check_component \
                          "SonarQube Server" \
                          "SonarQube status UP" \
                          bash -c \
                          'curl -sS http://localhost:9000/api/system/status | grep -q "\\"status\\":\\"UP\\""'

                        check_component \
                          "Docker Engine" \
                          "Docker daemon reachable" \
                          docker info

                        cat >> "${REPORT}" <<REPORT_TOTALS
------------------------------------------------------------------------------------------
Healthy Checks : ${PASS_COUNT}
Failed Checks  : ${FAIL_COUNT}
==========================================================================================
REPORT_TOTALS

                        if [ "${FAIL_COUNT}" -eq 0 ]; then
                            echo \
                              "OVERALL PRODUCTION STATUS: HEALTHY" |
                              tee -a "${REPORT}"
                        else
                            echo \
                              "OVERALL PRODUCTION STATUS: DEGRADED" |
                              tee -a "${REPORT}"
                        fi

                        echo \
                          "==========================================================================================" |
                          tee -a "${REPORT}"

                        cat "${REPORT}"

                        test "${FAIL_COUNT}" -eq 0
                    '''
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

        aborted {
            echo """
================================================================================
PIPELINE RESULT: ABORTED
Branch: ${BRANCH_NAME}
Build:  ${BUILD_NUMBER}
The deployment was not approved or the approval timed out.
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
