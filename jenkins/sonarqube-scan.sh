#!/usr/bin/env bash
set -euo pipefail

APP_DIR="application/CTInventoryPortal"
PROJECT="CTInventoryPortal.csproj"
PROJECT_KEY="ct-inventory-portal"
REPORT_DIR="${WORKSPACE}/pipeline-reports"

: "${SONAR_HOST_URL:?SONAR_HOST_URL is not set}"
: "${SONAR_TOKEN:?SONAR_TOKEN is not set}"

mkdir -p "${REPORT_DIR}"

cd "${APP_DIR}"

rm -rf .sonarqube
rm -rf .sonar-tools

dotnet tool install \
  --tool-path .sonar-tools \
  dotnet-sonarscanner

.sonar-tools/dotnet-sonarscanner begin \
  /k:"${PROJECT_KEY}" \
  /d:sonar.host.url="${SONAR_HOST_URL}" \
  /d:sonar.token="${SONAR_TOKEN}"

dotnet build \
  "${PROJECT}" \
  --configuration Release \
  --no-incremental

.sonar-tools/dotnet-sonarscanner end \
  /d:sonar.token="${SONAR_TOKEN}"

QUALITY_STATUS="NONE"

for attempt in $(seq 1 12); do
    sleep 10

    QUALITY_STATUS=$(
        curl \
          --silent \
          --fail \
          --user "${SONAR_TOKEN}:" \
          "${SONAR_HOST_URL}/api/qualitygates/project_status?projectKey=${PROJECT_KEY}" |
        python3 -c \
          "import json,sys; print(json.load(sys.stdin)['projectStatus']['status'])"
    )

    echo "Quality Gate attempt ${attempt}: ${QUALITY_STATUS}"

    if [ "${QUALITY_STATUS}" = "OK" ]; then
        break
    fi
done

echo "${QUALITY_STATUS}" \
  > "${REPORT_DIR}/sonarqube-quality-gate.txt"

if [ "${QUALITY_STATUS}" != "OK" ]; then
    echo "SonarQube Quality Gate did not pass. Status: ${QUALITY_STATUS}"
    exit 1
fi

echo "SonarQube Quality Gate passed."
