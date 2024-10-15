# HLA_typing

## T1K pipeline

[github](https://github.com/mourisl/T1K)

```bash
micromamba create -n hla_typing
micromamba activate hla_typing
micromamba install -c bioconda t1k

t1k-build.pl -o /mnt/data/gvykhodtsev/HLA_typing/References/hlaidx --download IPD-IMGT/HLA
t1k-build.pl -o /mnt/data/gvykhodtsev/HLA_typing/References/kiridx --download IPD-KIR --partial-intron-noseq

t1k-build.pl -o /mnt/data/gvykhodtsev/HLA_typing/References/hlaidx --download IPD-IMGT/HLA
t1k-build.pl -o /mnt/data/gvykhodtsev/HLA_typing/References/kiridx --download IPD-KIR --partial-intron-noseq

t1k-build.pl -o /mnt/data/gvykhodtsev/HLA_typing/References/hlaidx -d /mnt/data/gvykhodtsev/HLA_typing/References/hlaidx/hla.dat -g gencode.gtf
t1k-build.pl -o /mnt/data/gvykhodtsev/HLA_typing/References/hlaidx -d /mnt/data/gvykhodtsev/HLA_typing/References/hlaidx/hla.dat -g gencode.gtf

tmux new -s hla_wgs
bash /home/gvykhodtsev/projects/HLA_typing/t1k_run_WGS_bam.bash
tmux attach

```

> **Interleaved** files are when the R1 and R2 reads are combined in one file,
so that for each read pair, the R1 read in the file comes immediately before
the R2 read, followed by the R1 read for the next read pair, and so on.
