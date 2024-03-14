# Загрузка библиотек
library(methylKit)

# Считывание данных из файлов
file1 <- "output_first_data.txt"
file2 <- "output_second_data.txt"

# Чтение данных
data1 <- read.table(file1, header = TRUE, stringsAsFactors = FALSE)
data2 <- read.table(file2, header = TRUE, stringsAsFactors = FALSE)

# Создание объектов methylRawList
rawList <- list(data1, data2)
methylRaw <- methRead(rawList)

# Контроль качества
methylRaw <- filterByCoverage(methylRaw, lo.count = 10)

# Нормализация
methylNorm <- normalizeCoverage(methylRaw)

# Сравнение уровней метилирования
methDiff <- calculateDiffMeth(methylNorm)

# Выявление дифференциально метилированных регионов (DMR)
DMR <- getMethylDiff(methDiff, difference = 0.1, qvalue = 0.01)

# Статистический анализ
stats <- getMethylStats(methylNorm)

# Корреляционный анализ
correlation <- cor(rawCounts(methylNorm))

# Визуализация результатов
plotPCA(methylNorm)
plotMethylationProfile(methylNorm)
plotMethylationStats(stats)

# Сохранение результатов
write.table(methylRaw, "methylRaw.txt", sep = "\t", row.names = FALSE)
write.table(methylNorm, "methylNorm.txt", sep = "\t", row.names = FALSE)
write.table(methDiff, "methDiff.txt", sep = "\t", row.names = FALSE)
write.table(DMR, "DMR.txt", sep = "\t", row.names = FALSE)
write.table(stats, "methylStats.txt", sep = "\t", row.names = FALSE)
write.table(correlation, "correlation.txt", sep = "\t", row.names = FALSE)
