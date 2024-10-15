micromamba activate hla_typing
cd /home/gvykhodtsev/projects/HLA_typing

## Create HLA and KIR database with coord fasta for BAM processing
t1k-build.pl -o /mnt/data/gvykhodtsev/HLA_typing/References/hlaidx --download IPD-IMGT/HLA
t1k-build.pl -o /mnt/data/gvykhodtsev/HLA_typing/References/kiridx --download IPD-KIR --partial-intron-noseq

wget -P /mnt/data/gvykhodtsev/HLA_typing/References \
        https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_46/gencode.v46.annotation.gtf.gz

wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_46/gencode.v46.annotation.gtf.gz

gunzip /mnt/data/gvykhodtsev/HLA_typing/References/gencode.v46.annotation.gtf.gz



t1k-build.pl -o /mnt/data/gvykhodtsev/HLA_typing/References/hlaidx \
             -d /mnt/data/gvykhodtsev/HLA_typing/References/hlaidx/hla.dat \
             -g /mnt/data/gvykhodtsev/HLA_typing/References/gencode.v46.annotation.gtf

t1k-build.pl -o /mnt/data/gvykhodtsev/HLA_typing/References/kiridx \
             -d /mnt/data/gvykhodtsev/HLA_typing/References/kiridx/kir.dat \
             -g /mnt/data/gvykhodtsev/HLA_typing/References/gencode.v46.annotation.gtf

# wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_46/gencode.v46.chr_patch_hapl_scaff.annotation.gtf.gz


## BED with selected full chromosome regions
HG38_FAI="/mnt/data/common_private/human_ref/hg38/GRCh38.d1.vd1.fa.fai"
cat $HG38_FAI | awk -v OFS='\t' '$1 ~ /(^chr6($|_))|(^chr19($|_))|(chrUn($|_))/ {print $1, "0", $2}' > HLA_KIR_chrom.bed

## Subsample BAM
cd /mnt/data/gvykhodtsev/HLA_typing/Samples/000000000500/Trim_align
samtools view -s 0.001 -b filter_chr_6_19_Un.bam > small.bam

## Count reads on chromosomes
INPUT_BAM="/mnt/data/common_private/platinum/Alignment/000000000500.MGI.cutadapt.bwa.MarkDuplicates.bam"
samtools idxstats $INPUT_BAM > /mnt/data/gvykhodtsev/HLA_typing/Samples/000000000500/Trim_align/ref_idxstats.txt

INPUT_BAM="/mnt/data/common_private/platinum/Alignment/000000000500.ONT.all_chem.dorado_sup@v4.3_C@v1_A@v2.minimap2.MarkDuplicates.bam"
samtools idxstats $INPUT_BAM > /mnt/data/gvykhodtsev/HLA_typing/Samples/000000000500/Trim_align/ONT_ref_idxstats.txt