TIDEHUNTER_VERSION="1.5.4"
#установка зависимостей и программы 
git clone --recursive https://github.com/yangao07/TideHunter.git
cd TideHunter
make
conda install -c bioconda tidehunter
# запуск
TideHunter pathtofastafile > cons.fa
#через docker 
git clone https://github.com/biotech-campus/students.git
cd students/tel_tools
docker build -t tidehunter-image .

docker run -it --rm -v /mnt/data/common_private/platinum/Reads:/data tidehunter-image TideHunter -u --unit-seq -c /config.txt /pathtofile
# запуск через docker
TideHunter pathtofastafile > cons.fa
Flags for STR: 
- `-h` или `--help`: Выводит справку о доступных опциях и флагах.
- `-i <путь_к_входному_файлу>`: Указание пути к входному файлу.
- `-o <путь_к_выходному_файлу>`: Указание пути к выходному файлу.
- `-f <формат>`: Указание формата входного или выходного файла.
- `-n <имя>`: Указание имени для обозначения входных или выходных данных.
Пример: tidehunter -h 
#ошибка: free(): double free detected in tcache 2 
TRF_VERSION="4.09.1"
#установка зависимостей и программы 
git clone --recursive https://github.com/Benson-Genomics-Lab/TRF.git
cd  TRF
make 
conda install -c bioconda TRF
#запуск
trf pathtofastafile 2 7 7 80 10 50 500 -f -d -m
#через docker 
docker run -it myimage
docker run -it myimage TRF
 trf pathtofastafile 2 7 7 80 10 50 500 -f -d -m
Flags for STR:
-h или -H: Этот флаг указывает программе поиска на то, что следующая последовательность является гомополимером (например, AAAAAA).
-f: Этот флаг указывает на то, что последовательность представляет собой фрагмент длиной от 2 до 6 нуклеотидов.
-r: Этот флаг указывает на то, что последовательность представляет собой повтор длиной от 1 до 6 нуклеотидов.
-d: Этот флаг указывает на то, что повтор должен быть прямым.
-i: Этот флаг указывает на то, что повтор должен быть инвертированным.
