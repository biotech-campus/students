import pysam

# Пути к вашим BAM файлам и соответствующим выходным текстовым файлам
bam_files_and_outputs = {
    'your_first_data.bam': 'output_first_data.txt',
    'your_second_data.bam': 'output_second_data.txt'
}

# Функция для обработки одного BAM файла и записи в текстовый файл
def process_bam(file_path, output_file_path):
    with pysam.AlignmentFile(file_path, "rb") as bamfile, open(output_file_path, 'w') as outfile:
        outfile.write("chromosome\tposition\tcountMeth\tcountUnmeth\n")

        for read in bamfile:
            if read.is_unmapped:  # Пропуск не выровненных ридов
                continue

            try:
                methylation_info = read.get_tag('XM')  # Предполагаемый тег с информацией о метилировании
            except KeyError:
                continue  # Пропуск ридов без информации о метилировании

            countMeth = methylation_info.count('Z')  # Пример: 'Z' для метилированных цитозинов
            countUnmeth = methylation_info.count('z')  # Пример: 'z' для неметилированных цитозинов

            outfile.write(f"{read.reference_name}\t{read.reference_start}\t{countMeth}\t{countUnmeth}\n")

# Обрабатываем каждый BAM файл и записываем результаты в соответствующий текстовый файл
for bam_file, output_file in bam_files_and_outputs.items():
    process_bam(bam_file, output_file)
