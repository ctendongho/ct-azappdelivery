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

ansible-playbook \
  -i "${INVENTORY}" \
  ansible/playbooks/deploy-inventory-portal.yml \
  --vault-password-file "${VAULT_FILE}"

ansible-playbook \
  -i "${INVENTORY}" \
  ansible/playbooks/configure-web-security-headers.yml \
  --vault-password-file "${VAULT_FILE}"

echo "Application deployment completed successfully."
