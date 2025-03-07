#!/bin/bash
set -e

echo "========> Проверка ключей Yandex Cloud"
if ! yc compute ssh-key list | grep -q avryahov; then
  echo "========> Ошибка: ключ avryahov не найден"
  exit 1
fi

echo "========> Проверка подключения к SSH-агенту"
if ! ssh-add -L | grep -q yandex_avryahov; then
  echo "========> Ошибка: ключ не добавлен в SSH-агент"
  exit 1
fi

echo "========> Проверка прав доступа"
# sonarqube подключен в IDE
# shellcheck disable=SC2046
if [ $(stat -f%A "$HOME"/.ssh/yandex_avryahov) != "600" ]; then
  echo "========> Ошибка: неправильные права на приватный ключ"
  exit
fi