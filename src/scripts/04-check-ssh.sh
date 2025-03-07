#!/bin/bash
set -euo pipefail

SSH_KEY_NAME="avryahov"
SSH_KEY_PATH="$HOME/.ssh/yandex_avryahov"

echo "========> Проверка ключа '$SSH_KEY_NAME' в Yandex Cloud"
if ! yc compute ssh-key list --format=json | jq -e --arg name "$SSH_KEY_NAME" '.[] | select(.name == $name)' >/dev/null; then
  echo "========> Ошибка: ключ '$SSH_KEY_NAME' не найден в Yandex Cloud"
  exit 1
fi

echo "========> Проверка подключения ключа к SSH-агенту"
if ! ssh-add -L | grep -q "$(ssh-keygen -lf "$SSH_KEY_PATH.pub" | awk '{print $2}')"; then
  echo "========> Ошибка: ключ '$SSH_KEY_NAME' не добавлен в SSH-агент"
  exit 1
fi

echo "========> Проверка прав доступа на приватный ключ"
if [ ! -f "$SSH_KEY_PATH" ]; then
  echo "========> Ошибка: файл '$SSH_KEY_PATH' не существует"
  exit 1
fi

if [ "$(stat -f%A "$SSH_KEY_PATH")" != "600" ]; then
  echo "========> Ошибка: права на '$SSH_KEY_PATH' должны быть 600 (текущие: $(stat -f%A "$SSH_KEY_PATH"))"
  exit 1
fi

echo "========> Все проверки пройдены успешно!"