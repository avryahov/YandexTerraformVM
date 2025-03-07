#!/bin/bash
set -euo pipefail

SSH_DIR="${SSH_DIR:-$HOME/.ssh}"
KEY_NAME="${SSH_KEY_NAME:-yandex_avryahov}"
COMMENT="avryahov@yandex.cloud"
SSH_KEY_PATH="$SSH_DIR/$KEY_NAME"

echo "========> Проверка существования SSH-ключей"
if [ -f "$SSH_KEY_PATH" ]; then
  echo "========> Ключи уже существуют: $SSH_KEY_PATH"
  exit 0
fi

echo -n "========> Введите парольную фразу для приватного ключа (оставьте пустым для безпарольного доступа): "
read -s passphrase
echo

echo "========> Генерация SSH-ключей (ed25519) для Yandex Cloud"
ssh-keygen -t ed25519 -C "$COMMENT" -f "$SSH_KEY_PATH" -N "$passphrase" -q

echo "========> Проверка наличия ключа в Yandex Cloud"
if yc compute ssh-key list --format=json | jq -e --arg name "$SSH_KEY_NAME" '.[] | select(.name == $name)' >/dev/null; then
  echo "========> Ключ '$KEY_NAME' уже существует в Yandex Cloud. Пропуск добавления."
else
  echo "========> Добавление ключа в Yandex Cloud"
  yc compute ssh-key add --key-file "$SSH_KEY_PATH.pub" --name "$KEY_NAME"
fi

echo "========> Добавление ключа в SSH-агент"
if ssh-add -L | grep -q "$SSH_KEY_PATH"; then
  echo "========> Ключ уже добавлен в SSH-агент"
else
  ssh-add --apple-use-keychain "$SSH_KEY_PATH"
fi

echo "========> Настройка прав доступа"
chmod 700 "$SSH_DIR"
chmod 600 "$SSH_KEY_PATH"
chmod 644 "$SSH_KEY_PATH.pub"

echo "========> Готово! Ключи сгенерированы и настроены."