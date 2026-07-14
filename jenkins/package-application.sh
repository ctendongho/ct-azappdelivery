#!/usr/bin/env bash
set -euo pipefail

APP_DIR="application/CTInventoryPortal"
PROJECT="CTInventoryPortal.csproj"

cd "${APP_DIR}"

rm -rf publish
rm -f CTInventoryPortal.zip

dotnet publish \
  "${PROJECT}" \
  --configuration Release \
  --no-restore \
  --output publish

cd publish

zip -qr \
  ../CTInventoryPortal.zip \
  .

echo "Application package created successfully."
