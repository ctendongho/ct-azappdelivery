#!/usr/bin/env bash
set -euo pipefail

APP_DIR="application/CTInventoryPortal"
PROJECT="CTInventoryPortal.csproj"

cd "${APP_DIR}"

dotnet restore "${PROJECT}"

dotnet build \
  "${PROJECT}" \
  --configuration Release \
  --no-restore \
  --no-incremental

echo "Application build completed successfully."
