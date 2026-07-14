#!/usr/bin/env bash
set -uo pipefail

INVENTORY="ansible/inventory/hosts.ini"
REPORT_DIR="pipeline-reports"
REPORT="${REPORT_DIR}/platform-health-summary.txt"
VAULT_FILE="$(mktemp)"

mkdir -p "${REPORT_DIR}"

cleanup() {
    rm -f "${VAULT_FILE}"
}
trap cleanup EXIT

printf '%s' "${ANSIBLE_VAULT_PASSWORD}" > "${VAULT_FILE}"
chmod 600 "${VAULT_FILE}"

PASS_COUNT=0
FAIL_COUNT=0

print_row() {
    printf "%-34s | %-9s | %s\n" \
      "$1" "$2" "$3" |
    tee -a "${REPORT}"
}

check_component() {
    local component="$1"
    local details="$2"
    shift 2

    if "$@" >/dev/null 2>&1; then
        print_row "${component}" "HEALTHY" "${details}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        print_row "${component}" "FAILED" "${details}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

cat > "${REPORT}" <<EOF2
==========================================================================================
                 CT AZURE APPLICATION DELIVERY - PLATFORM SUMMARY
==========================================================================================
Branch       : ${BRANCH_NAME}
Build        : ${BUILD_NUMBER}
Commit       : ${GIT_COMMIT}
Build URL    : ${BUILD_URL}
==========================================================================================
COMPONENT                          | STATUS    | DETAILS
------------------------------------------------------------------------------------------
EOF2

check_component \
  "Terraform Plan" \
  "Validation and plan completed" \
  test -f pipeline-reports/terraform-plan.txt

check_component \
  "Ansible Validation" \
  "Inventory and playbooks validated" \
  test -f pipeline-reports/ansible-validation-passed.txt

check_component \
  ".NET Application Build" \
  "Release build completed" \
  test -f \
  application/CTInventoryPortal/bin/Release/net8.0/CTInventoryPortal.dll

check_component \
  "SonarQube Quality Gate" \
  "Quality Gate status OK" \
  grep -q '^OK$' \
  pipeline-reports/sonarqube-quality-gate.txt

check_component \
  "Trivy Security Scan" \
  "Security report generated" \
  test -f pipeline-reports/trivy-jenkins-report.txt

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
  -a 'url=http://localhost/health method=GET status_code=200' \
  --vault-password-file "${VAULT_FILE}"

check_component \
  "SQL Server Services" \
  "MSSQLSERVER running on both nodes" \
  ansible sql_servers \
  -i "${INVENTORY}" \
  -m ansible.windows.win_shell \
  -a 'if ((Get-Service MSSQLSERVER).Status -ne "Running") { exit 1 }' \
  --vault-password-file "${VAULT_FILE}"

check_component \
  "SQL Cluster and AG" \
  "Cluster validation passed" \
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
  -a 'if (-not (Test-NetConnection CTInventoryListener.ad.ctinventorytracker.com -Port 14330 -InformationLevel Quiet)) { exit 1 }' \
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
  'curl -sS http://localhost:3000/api/health | grep -q "\"database\": \"ok\""'

check_component \
  "SonarQube Server" \
  "SonarQube status UP" \
  bash -c \
  'curl -sS http://localhost:9000/api/system/status | grep -q "\"status\":\"UP\""'

check_component \
  "Docker Engine" \
  "Docker daemon reachable" \
  docker info

cat >> "${REPORT}" <<EOF2
------------------------------------------------------------------------------------------
Healthy Checks : ${PASS_COUNT}
Failed Checks  : ${FAIL_COUNT}
==========================================================================================
EOF2

if [ "${FAIL_COUNT}" -eq 0 ]; then
    echo "OVERALL PLATFORM STATUS: HEALTHY" |
      tee -a "${REPORT}"
else
    echo "OVERALL PLATFORM STATUS: DEGRADED" |
      tee -a "${REPORT}"
fi

echo "==========================================================================================" |
  tee -a "${REPORT}"

cat "${REPORT}"

test "${FAIL_COUNT}" -eq 0
