# Базовый образ
FROM python:3.8

# - author contacts
LABEL author="lukianchikova.ei@phystech.edu"
ENV DEBIAN_FRONTEND="noninteractive"
USER root

WORKDIR /home

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем зависимости проекта (если есть)
COPY requirements.txt .

# Устанавливаем зависимости (если есть)
RUN pip install -r requirements.txt

# Клонируем репозиторий danbing-tk
RUN git clone https://github.com/ChaissonLab/danbing-tk.git /app/danbing-tk

# Скачиваем и устанавливаем samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.17/samtools-1.17.tar.bz2 && \
    bunzip2 samtools-1.17.tar.bz2 && \
    tar -xvf samtools-1.17.tar -C /tmp && \
    cd /tmp/samtools-1.17 && \
    ./configure --prefix=/usr/local && \
    make && \
    make install && \
    cd /app && \
    rm -rf /tmp/samtools-1.17*

# Копируем Makefile и другие необходимые файлы (если есть)
# COPY ./my_makefile /app/danbing-tk/Makefile

# Копируем все файлы из текущего каталога в рабочую директорию контейнера
# (если нужно, например, для данных или конфигурации)
COPY . .

# Собираем danbing-tk
# # RUN cd /app/danbing-tk && make -j $(nproc)

# Устанавливаем danbing-tk (необязательно, если он уже доступен в PATH)
# # RUN install -m 755 bin/* /usr/local/bin/

# Определяем команду для запуска danbing
CMD ["danbing"]

