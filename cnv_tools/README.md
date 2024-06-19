# How to run tools

Добавил опцию с выборо short/не-short риды платинового отца.

```shell
bash cnv_calling.sh [tool] [short] 
```

[tool] - spectre,cnvpytor,vcf-check,svim,truvari,cnvkit
[short] - если есть короткие риды

1. `bash cnv_calling.sh [tool] [short]`
    Все тулы запустить, для каждого bam в папке OUT_DIR/BAM_FILE/ будут создаваться свои папки OUT_DIR/BAM_FILE/TOOL.
2. `bash cnv_calling.sh vcf-check`
    vcf-check просто нужен, чтобы проверить, что все vcf валидны для объединения, в целом этот шаг можно пропустить, все должно объединяться нормально.
    В конце этой команды должен создаться файлик OUT_DIR/BAM_FILE/all_vcf_files.txt, где списком пути дл всех vcf, посчитанные для нашего bam. Его можно подкорректировать, чтобы убрать/добавить пути до других vcf.
3. `bash cnv_calling.sh truvari`
    нужен OUT_DIR/BAM_FILE/all_vcf_files.txt, которые truvari будет объединять.
