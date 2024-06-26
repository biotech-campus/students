# Используем базовый образ с Python
FROM python:3.9-slim

# - author contacts
LABEL author="lukianchikova.ei@phystech.edu"
ENV DEBIAN_FRONTEND="noninteractive"
USER root

WORKDIR /home

# Устанавливаем необходимые зависимости для сборки
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Клонируем репозиторий adVNTR
RUN git clone https://github.com/mehrdadbakhtiari/adVNTR.git /adVNTR

# Устанавливаем рабочую директорию
WORKDIR /adVNTR

# Устанавливаем зависимости Python
RUN pip install --no-cache-dir -r requirements.txt

# Компилируем проект
RUN make

# Устанавливаем путь к исполняемому файлу
ENV PATH="/adVNTR:${PATH}"

# Команда по умолчанию для запуска контейнера
CMD ["adVNTR"]