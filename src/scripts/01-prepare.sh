#!/bin/bash
set -euo pipefail

echo "========> Начало проверки зависимостей"

# 1. Проверка YC CLI
echo -n "Проверка YC CLI... "
if ! command -v yc &> /dev/null; then
  echo "Не установлен!"
  echo "Установите YC CLI: https://cloud.yandex.ru/docs/cli/quickstart"
  exit 1
else
  yc_version=$(yc --version | awk '{print $2}')
  echo "OK (версия $yc_version)"
fi

# 2. Проверка Terraform
echo -n "Проверка Terraform... "
if ! command -v terraform &> /dev/null; then
  echo "Не установлен!"
  echo "Установите Terraform: https://developer.hashicorp.com/terraform/downloads"
  exit 1
else
  tf_version=$(terraform -v | head -n1 | awk '{print $2}')
  echo "OK (версия $tf_version)"
fi

# 3. Проверка аутентификации в Yandex Cloud
echo -n "Проверка аутентификации в Yandex Cloud... "
if ! yc config list &> /dev/null; then
  echo "Ошибка!"
  echo "Выполните аутентификацию: yc init"
  exit 1
else
  account=$(yc config get account)
  echo "OK (аккаунт: $account)"
fi

# 4. Проверка SSH
echo -n "Проверка SSH... "
if ! command -v ssh &> /dev/null; then
  echo "Не установлен!"
  exit 1
else
  ssh_version=$(ssh -V 2>&1 | awk '{print $1}')
  echo "OK ($ssh_version)"
fi

# 5. Проверка jq
echo -n "Проверка jq... "
if ! command -v jq &> /dev/null; then
  echo "Не установлен!"
  echo "Установите: brew install jq"
  exit 1
else
  jq_version=$(jq --version | awk '{print $3}')
  echo "OK (версия $jq_version)"
fi

# 6. Проверка директории .ssh
echo -n "Проверка директории ~/.ssh... "
if [ ! -d "$HOME/.ssh" ]; then
  echo "Не существует!"
  exit 1
else
  echo "OK"
fi

echo "========> Все проверки успешно пройдены!"