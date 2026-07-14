#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="/home/charlo/ct-azappdelivery/terraform"
WORK_DIR="${WORKSPACE}/terraform"
REPORT_DIR="${WORKSPACE}/pipeline-reports"

mkdir -p "${REPORT_DIR}"

cleanup() {
    rm -f "${WORK_DIR}/terraform.tfvars"
    rm -f "${WORK_DIR}/terraform.tfstate"
    rm -f "${WORK_DIR}/tfplan"
}
trap cleanup EXIT

cp "${SOURCE_DIR}/terraform.tfvars" \
   "${WORK_DIR}/terraform.tfvars"

cp "${SOURCE_DIR}/terraform.tfstate" \
   "${WORK_DIR}/terraform.tfstate"

cd "${WORK_DIR}"

echo "Running Terraform format check..."
terraform fmt -check -recursive

echo "Initializing Terraform..."
terraform init \
  -backend=false \
  -input=false

echo "Validating Terraform..."
terraform validate

echo "Creating read-only Terraform plan..."
terraform plan \
  -input=false \
  -refresh=false \
  -out=tfplan

terraform show \
  -no-color \
  tfplan \
  > "${REPORT_DIR}/terraform-plan.txt"

echo "Terraform validation and plan completed successfully."
