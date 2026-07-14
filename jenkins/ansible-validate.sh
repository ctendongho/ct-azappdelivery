#!/usr/bin/env bash
set -euo pipefail

INVENTORY="ansible/inventory/hosts.ini"
VAULT_FILE="$(mktemp)"

cleanup() {
    rm -f "${VAULT_FILE}"
}
trap cleanup EXIT

printf '%s' "${ANSIBLE_VAULT_PASSWORD}" > "${VAULT_FILE}"
chmod 600 "${VAULT_FILE}"

echo "Validating Ansible inventory..."

ansible-inventory \
  -i "${INVENTORY}" \
  --vault-password-file "${VAULT_FILE}" \
  --graph

echo "Checking deployment playbook syntax..."

ansible-playbook \
  -i "${INVENTORY}" \
  ansible/playbooks/deploy-inventory-portal.yml \
  --syntax-check \
  --vault-password-file "${VAULT_FILE}"

echo "Checking security-header playbook syntax..."

ansible-playbook \
  -i "${INVENTORY}" \
  ansible/playbooks/configure-web-security-headers.yml \
  --syntax-check \
  --vault-password-file "${VAULT_FILE}"

echo "Testing application-server connectivity..."

ansible app_servers \
  -i "${INVENTORY}" \
  -m ansible.windows.win_ping \
  --vault-password-file "${VAULT_FILE}"

echo "Testing SQL-server connectivity..."

ansible sql_servers \
  -i "${INVENTORY}" \
  -m ansible.windows.win_ping \
  --vault-password-file "${VAULT_FILE}"

echo "Ansible validation completed successfully."

mkdir -p pipeline-reports
echo "PASSED" > pipeline-reports/ansible-validation-passed.txt
