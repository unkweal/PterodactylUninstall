#!/bin/bash

# Очистка экрана
clear

# Функция для вывода сообщений на русском языке
function rus {
    echo "Вы уверены, что хотите удалить Pterodactyl Panel? (y/n)"
}

# Функция для вывода сообщений на английском языке
function eng {
    echo "Are you sure you want to remove Pterodactyl Panel? (y/n)"
}

# Выбор языка
echo "Выберите язык / Choose your language:"
echo "1) Русский"
echo "2) English"
read -p "Введите номер языка / Enter language number: " lang_choice

if [ "$lang_choice" -eq 1 ]; then
    language="rus"
elif [ "$lang_choice" -eq 2 ]; then
    language="eng"
else
    echo "Неверный выбор языка / Invalid language choice."
    exit 1
fi

# Подтверждение удаления
if [ "$language" == "rus" ]; then
    rus
else
    eng
fi

read -p "Введите ваш ответ: " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Удаление отменено."
    exit 0
fi

# Удаление пользователей Pterodactyl
echo "Удаление пользователей Pterodactyl..."
mysql -u root -p -e "DROP USER 'pterodactyl'@'127.0.0.1';" || { echo "Ошибка при удалении пользователя 'pterodactyl'@'127.0.0.1'."; exit 1; }
mysql -u root -p -e "DROP USER 'pterodactyl'@'localhost';" || { echo "Ошибка при удалении пользователя 'pterodactyl'@'localhost'."; exit 1; }

# Удаление базы данных Pterodactyl
echo "Удаление базы данных Pterodactyl..."
mysql -u root -p -e "DROP DATABASE IF EXISTS pterodactyl;" || { echo "Ошибка при удалении базы данных."; exit 1; }

# Удаление файлов Pterodactyl
echo "Удаление файлов Pterodactyl..."
rm -rf /var/www/pterodactyl || { echo "Ошибка при удалении файлов."; exit 1; }

# Удаление зависимостей
echo "Удаление зависимостей Pterodactyl..."
apt-get remove --purge -y <пакеты_зависимостей> || { echo "Ошибка при удалении зависимостей."; exit 1; }

echo "Pterodactyl успешно удален!"
