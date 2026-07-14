#!/usr/bin/env bash
set -euo pipefail

REPORT_DIR="pipeline-reports"
REPORT="${REPORT_DIR}/trivy-jenkins-report.txt"

mkdir -p "${REPORT_DIR}"

trivy fs \
  --scanners vuln,secret,misconfig \
  --severity HIGH,CRITICAL \
  --skip-dirs .git \
  --skip-dirs application/CTInventoryPortal/bin \
  --skip-dirs application/CTInventoryPortal/obj \
  --skip-dirs application/CTInventoryPortal/publish \
  --skip-dirs application/CTInventoryPortal/.sonarqube \
  --skip-dirs application/CTInventoryPortal/.sonar-tools \
  --skip-files terraform/terraform.tfstate \
  --skip-files terraform/terraform.tfstate.backup \
  --skip-files terraform/terraform.tfstate.before-destroy \
  --skip-files terraform/terraform.tfstate.backup.before-destroy \
  --format table \
  --output "${REPORT}" \
  .

echo "Trivy report created: ${REPORT}"
