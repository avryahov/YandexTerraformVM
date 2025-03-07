#!/bin/bash
set -e

echo "========> Генерация IAM-токена в Yandex Cloud"
IAM_TOKEN=$(yc iam create-token)

echo "========> Экспорт конфигурации в .env"
cat <<EOF > ../.env
YC_IAM_TOKEN=${IAM_TOKEN}
YC_CLOUD_ID=$(yc config get cloud-id)
YC_FOLDER_ID=$(yc config get folder-id)
EOF