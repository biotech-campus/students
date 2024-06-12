docker build -t methylartist -f Dockerfile_methylartist .

CONTAINER=methylartist
BAM_DIR="/mnt/data/common_private/platinum/Alignment"
REF_DIR="/mnt/data/common_private/human_ref/hg38"
OUT_DIR="/mnt/data/mshokodko/output"
IN_DIR="/mnt/data/mshokodko/input"

BAMFILE="000000000500.ONT.all_chem.dorado_sup@v4.3_C@v1_A@v2.minimap2.MarkDuplicates.bam"
REF_FASTA="GRCh38.d1.vd1.fa"
TARGET_BED="GRCh38.d1.vd1.main.bed"
DIR="/mnt/data/mshokodko"
WORKDIR="/home"
CPU=8

DOCKER_OPTIONS="--volume ${BAM_DIR}:${BAM_DIR}:ro \
        --volume ${REF_DIR}:${REF_DIR}:ro \
        --volume ${OUT_DIR}:${OUT_DIR} \
        --volume ${IN_DIR}:${IN_DIR} \
        -w ${OUT_DIR} \
        --cpus=${CPU}"

docker run -it --rm\
    ${DOCKER_OPTIONS} \
    ${CONTAINER} \
        methylartist locus \
                --bams ${BAM_DIR}/${BAMFILE} \
                --interval chr7:1072064-1101499 \
                --ref ${REF_DIR}/${REF_FASTA} \
                --motif CG \
                --plot_coverage yes

# при locus  еще лучше использовать --genes и --labelgenes это не изменит картину просто наложит 
# гены на график

# подходит для коротких ридов


# docker run -it --rm\
#     ${DOCKER_OPTIONS} \
#     ${CONTAINER} \
#         modkit sample-probs \
#                 -t ${CPU} \
#                 --log-filepath ${OUT_DIR}/modkit_debug.log \
#                 --percentiles 0.02,0.05,0.1,0.2,0.5,0.9 \
#                 --out-dir ${OUT_DIR}/modkit_sample-probs \
#                 --prefix v1 \
#                 --no-sampling \
#                 --include-bed ${OUT_DIR}/${TARGET_BED} \
#                 --hist \
#                 --interval-size 500000 \
#                 ${BAM_DIR}/${BAMFILE}

# docker run -it --rm\
#     ${DOCKER_OPTIONS} \
#     ${CONTAINER} \
#         modkit adjust-mods \
#                 -t ${CPU} \
#                 --ignore a \ одно из лишнее
#                 --convert h m \ одно из лишнее
#                 --log-filepath ${OUT_DIR}/modkit_debug.log \
#                 ${BAM_DIR}/${BAMFILE} \
#                 ${IN_DIR}/modkit_5mC.bam

# docker run -it --rm\
#     ${DOCKER_OPTIONS} \
#     ${CONTAINER} \
#         modkit summary \
#                 -t ${CPU} \
#                 --region chr21 \
#                 --log-filepath ${OUT_DIR}/modkit_debug.log \
#                 --interval-size 500 \
#                 --sampling-frac 0.01 \
#                 --include-bed ${OUT_DIR}/${TARGET_BED} \
#                 ${BAM_DIR}/${BAMFILE} > ${OUT_DIR}/modkit_summary.txt

# # List of chromosomes
# chromosomes=("chr1" "chr2" "chr3" "chr4" "chr5" "chr6" "chr7" "chr8" "chr9" "chr10" "chr11" "chr12" "chr13" "chr14" "chr15" "chr16" "chr17" "chr18" "chr19" "chr20" "chr21" "chr22" "chrX" "chrY" "chrM")

# # Initialize variables for statistical calculations
# min_pass_threshold_C=999999
# sum_pass_threshold_C=0
# count=0

# # File header for chromosome values
# echo "Chromosome pass_threshold_C values:" > ${OUT_DIR}/summary_stats.txt

# # Loop through each chromosome and process it
# for chrom in "${chromosomes[@]}"; do
#     # Define output file path
#     output_file="${OUT_DIR}/modkit_summary_${chrom}.txt"

#     # Run the modkit summary command for each chromosome
#     docker run -it --rm \
#         ${DOCKER_OPTIONS} \
#         ${CONTAINER} \
#         modkit summary \
#             -t ${CPU} \
#             --region $chrom \
#             --log-filepath ${OUT_DIR}/modkit_debug.log \
#             --interval-size 10000 \
#             --num-reads 10000 \
#             --include-bed ${OUT_DIR}/${TARGET_BED} \
#             ${BAM_DIR}/${BAMFILE} > $output_file

#     # Extract the pass_threshold_C value from the output
#     pass_threshold_C=$(grep "pass_threshold_C" $output_file | awk '{print $3}')

#     # Record the chromosome and its pass_threshold_C value
#     echo "$chrom: $pass_threshold_C" >> ${OUT_DIR}/summary_stats.txt

#     # Update statistics for minimum and average calculations
#     if [[ $pass_threshold_C < $min_pass_threshold_C ]]; then
#         min_pass_threshold_C=$pass_threshold_C
#     fi
#     sum_pass_threshold_C=$(echo "$sum_pass_threshold_C + $pass_threshold_C" | bc)
#     count=$((count + 1))
# done

# # Calculate the average pass_threshold_C
# average_pass_threshold_C=$(echo "scale=2; $sum_pass_threshold_C / $count" | bc)

# # Append the calculated statistics to the file
# echo "Minimum pass_threshold_C: $min_pass_threshold_C" >> ${OUT_DIR}/summary_stats.txt
# echo "Average pass_threshold_C: $average_pass_threshold_C" >> ${OUT_DIR}/summary_stats.txt

# THISTHISTHIS

# docker run -it --rm\
#     ${DOCKER_OPTIONS} \
#     ${CONTAINER} \
#         modkit pileup \
#                 --log-filepath ${OUT_DIR}/modkit_debug.log \
#                 --ref ${REF_DIR}/${REF_FASTA} \
#                 -t ${CPU} \
#                 --interval-size 10000 \
#                 --filter-threshold C:0.75 --filter-threshold A:0.85 \
#                 --prefix v1 \
#                 --cpg \
#                 --include-bed ${OUT_DIR}/${TARGET_BED} \
#                 ${BAM_DIR}/${BAMFILE} \
#                 --bedgraph ${OUT_DIR}/modkit_pileup_bedgraph

# THISTHISTHIS

# docker run -it --rm\
#     ${DOCKER_OPTIONS} \
#     ${CONTAINER} \
#         modkit pileup \
#                 --log-filepath ${OUT_DIR}/modkit_debug.log \
#                 --ref ${REF_DIR}/${REF_FASTA} \
#                 -t ${CPU} \
#                 --interval-size 50000 \
#                 --filter-threshold C:0.75 --filter-threshold A:0.85 \
#                 --prefix v1 \
#                 --cpg \
#                 --include-bed ${OUT_DIR}/${TARGET_BED} \
#                 --only-tabs \
#                 ${BAM_DIR}/${BAMFILE} \
#                 ${OUT_DIR}/modkit_pileup_bedmethyl/cpg_onlytabs.bedmethyl

# THISTHISTHIS

# docker run -it --rm\
#     ${DOCKER_OPTIONS} \
#     ${CONTAINER} \
#         modkit pileup \
#                 --log-filepath ${OUT_DIR}/modkit_debug.log \
#                 --ref ${REF_DIR}/${REF_FASTA} \
#                 -t ${CPU} \
#                 --interval-size 500000 \
#                 --filter-threshold C:0.75 --filter-threshold A:0.85 --filter-threshold 0.9 \
#                 --cpg \
#                 --include-bed ${OUT_DIR}/${TARGET_BED} \
#                 ${BAM_DIR}/${BAMFILE} \
#                 ${OUT_DIR}/modkit_pileup_bedmethyl/cpg_with_T,G_threshold.bedmethyl

# docker run -it \
#     ${DOCKER_OPTIONS} \
#     ${CONTAINER} \
#         modkit pileup-hemi \
#                 --log-filepath ${OUT_DIR}/modkit_debug.log \
#                 --ref ${REF_DIR}/${REF_FASTA} \
#                 -t ${CPU} \
#                 --interval-size 1000000 \
#                 --filter-threshold C:0.75 --filter-threshold A:0.85 \
#                 --cpg \
#                 --include-bed ${OUT_DIR}/${TARGET_BED} \
#                 -o ${OUT_DIR}/modkit_pileup_bedmethyl/hemi-pileup.bedmethyl \
#                 ${BAM_DIR}/${BAMFILE}      

# Narrowing output to CpG dinucleotides
# Hemi-methylation - neighbor on the opposite strand

        # modkit pileup \
        #         --log-filepath ${OUT_DIR}/modkit_debug.log \
        #         -r ${REF_DIR}/${REF_FASTA} \
        #         -t ${CPU} \
        #         --include-bed ${OUT_DIR}/${TARGET_BED} \
        #         ${BAM_DIR}/${BAMFILE} \
        #         ${OUT_DIR}/modkit_pileup_bedmethyl/basic.bedmethyl # Basic usage