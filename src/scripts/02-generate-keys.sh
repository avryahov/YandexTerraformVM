#!/bin/bash
set -e

echo "========> Генерация SSH-ключей для Yandex Cloud"
SSH_DIR="$HOME/.ssh"
KEY_NAME="yandex_avryahov"

if [ -f "$SSH_DIR/$KEY_NAME" ]; then
  echo "========> Ключи уже существуют"
  exit 0;
fi

ssh-keygen -t ed25519 -C "avryahov@yandex.cloud" -f "$SSH_DIR/$KEY_NAME" -N "" -q

echo "========> Добавление ключа в Yandex Cloud"
yc compute ssh-key add --key-file "$SSH_DIR/$KEY_NAME.pub" --name avryahov

echo "========> Добавление ключа в SSH-агент"
ssh-add --apple-use-keychain "$SSH_DIR/$KEY_NAME"

echo "========> Настройка прав доступа"
chmod 600 "$SSH_DIR/$KEY_NAME"
chmod 644 "$SSH_DIR/$KEY_NAME.pub"