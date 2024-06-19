docker build -t cnv_calling:latest .

CONTAINER="cnv_calling:latest"
TOOL="$1"
WORKDIR="/home"
CPU=4

# Input BAM files
IN_DIR="/mnt/data/common_private/platinum/Alignment"
VAR_DIR="/mnt/data/common_private/platinum/Variation"
if [ "$2" = "short" ]
then
    BAM_FILE="000000000500.MGI.cutadapt.bwa.MarkDuplicates" # Short reads
else
    BAM_FILE="000000000500.ONT.all_chem.dorado_sup@v4.3_C@v1_A@v2.minimap2.MarkDuplicates" # Long reads
fi

# Reference data
REF_DIR="/mnt/data/common_private/human_ref/hg38"
REF_FASTA="/GRCh38.d1.vd1.fa"
TARGET_GRCh38_BED=GRCh38.d1.vd1.main.bed
CHROMS=$(cat /mnt/data/common_private/human_ref/hg38_old/chroms.txt)

# Structural variation data
VAR_VCF="/000000000500.ONT.all_chem.dorado_sup@v4.3_C@v1_A@v2.minimap2.MarkDuplicates.Sniffles2.vcf.gz"

# Output
OUT_DIR="/mnt/data/ayamoncheryaev/${BAM_FILE}"
TOOL_OUT_DIR="${OUT_DIR}/${TOOL}"

CONTAINER_OPTIONS="--volume ${REF_DIR}:${REF_DIR}:ro \
        --volume ${IN_DIR}:${IN_DIR}:ro \
        --volume ${VAR_DIR}:${VAR_DIR}:ro \
        --volume ${OUT_DIR}:${OUT_DIR} \
        -w ${TOOL_OUT_DIR} \
        --cpus ${CPU}"


# Create directory for a singular bam output data (out_dir/bam_filename[/tool])
mkdir -p ${OUT_DIR} ${TOOL_OUT_DIR}


if [ "${TOOL}" = "cnvpytor" ]
then 
    docker run \
        ${CONTAINER_OPTIONS} \
        ${CONTAINER} \
            python3 cnvpytor_launch.py \
                --bam ${IN_DIR}/${BAM_FILE}.bam \
                -o ${TOOL_OUT_DIR} \
                --cpu ${CPU} \
                --chroms ${CHROMS} \
                --hists 1000 10000 100000
fi


if [ "${TOOL}" = "spectre" ]
then 
    WINDOW_SIZE=1000
    coverage_call="mkdir -p ${TOOL_OUT_DIR}/temp && \
                        mosdepth \
                            -x -n \
                            -t ${CPU} \
                            -Q 20 \
                            -b 1000 \
                            ${TOOL_OUT_DIR}/temp/${BAM_FILE} \
                            ${IN_DIR}/${BAM_FILE}.bam"

    spectre_call="spectre CNVCaller \
                    --threads ${CPU} \
                    --coverage ${TOOL_OUT_DIR}/temp/${BAM_FILE}.regions.bed.gz \
                    --sample-id ${BAM_FILE} \
                    --output-dir ${TOOL_OUT_DIR} \
                    --reference ${REF_DIR}/${REF_FASTA} \
                    --min-cnv-len 80000 \
                    --blacklist ${REF_DIR}/data/grch38_blacklist.bed\
                    --metadata ${REF_DIR}/data/grch38.mdr \
                    --only-chr ${CHROMS}"

    command="${coverage_call} && ${spectre_call}"

    docker run \
        ${CONTAINER_OPTIONS} \
        ${CONTAINER} \
            sh -c "${command}"
                
fi


if [ "${TOOL}" = "vcf-check" ]
then
    declare -a vcf_file_array
    tools=(cnvpytor cnvkit spectre svim)
    for tool in "${tools[@]}"; do
        vcf_files=$(find "${OUT_DIR}/${tool}" -type f -name "*.vcf" -o -name "*.vcf.gz")
        for vcf_file in $vcf_files; do
            echo
            echo "Check ${vcf_file}"
            docker run --rm \
                ${CONTAINER_OPTIONS} \
                ${CONTAINER} \
                    python3 ${WORKDIR}/usable_vcf/usable_vcf.py -v ${vcf_file}
            vcf_file_array+=("$vcf_file")
        done
    done
    touch ${OUT_DIR}/all_vcf_files.txt
    for element in "${vcf_file_array[@]}"; do
        echo "$element" >> ${OUT_DIR}/all_vcf_files.txt
    done
fi


if [ "${TOOL}" = "truvari" ] && [ -e "${OUT_DIR}/all_vcf_files.txt" ];
then
    vcf_files_list=()
    while IFS= read -r vcf_file; do
        # copy to truvari dir
        vcf_file_name="${vcf_file##*/}"
        out_vcf_file=${TOOL_OUT_DIR}/vcfs/$vcf_file_name
        mkdir -p ${TOOL_OUT_DIR}/vcfs
        cp $vcf_file $out_vcf_file

        # sort and index vcf
        if [ "${vcf_file_name##*.}" != "gz" ];
        then
            bcftools sort -o $out_vcf_file.gz -O z $out_vcf_file
            out_vcf_file=$out_vcf_file.gz
        fi
        bcftools index --tbi $out_vcf_file

        vcf_files_list+=("$out_vcf_file")
    done < ${OUT_DIR}/all_vcf_files.txt
    echo "${vcf_files_list[@]}"
    bcftools merge -m none "${vcf_files_list[@]}" --force-samples | bgzip > ${TOOL_OUT_DIR}/merge.vcf.gz
    bcftools sort -o ${TOOL_OUT_DIR}/merge.vcf.gz -O z ${TOOL_OUT_DIR}/merge.vcf.gz
    bcftools index --tbi ${TOOL_OUT_DIR}/merge.vcf.gz
    docker run \
        ${CONTAINER_OPTIONS} \
        ${CONTAINER} \
            truvari collapse \
            -i merge.vcf.gz \
            -o ${TOOL_OUT_DIR}/${BAM_FILE}_truvari_merge.vcf \
            -c ${TOOL_OUT_DIR}/${BAM_FILE}_truvari_collapsed.vcf \
            --pctseq 0.70 --pctsize 0.70 --refdist 1000 --chain

elif [ "${TOOL}" = "truvari" ]; then
    echo "Run \"vcf-check\" to make \"all_vcf_files.txt\" that consist of paths to vcf files made by tools!"
fi

if [ "${TOOL}" = "svim" ]
then 
    docker run \
        ${CONTAINER_OPTIONS} \
        ${CONTAINER} \
            svim alignment \
                ${TOOL_OUT_DIR} \
                ${IN_DIR}/${BAM_FILE}.bam \
                ${REF_DIR}/${REF_FASTA}  \
                --min_sv_size 1000 \
                --max_consensus_length 300000
                --types=DEL,INS,INV,DUP:TANDEM,DUP:INT,BND
fi


if [ "${TOOL}" = "cnvkit" ]
then 
    docker run \
        ${CONTAINER_OPTIONS} \
        ${CONTAINER} \
            sh -c "
                cnvkit.py batch \
                    ${IN_DIR}/${BAM_FILE}.bam -n \
                    -f ${REF_DIR}/${REF_FASTA} \
                    --output-reference ${TOOL_OUT_DIR}/flat_reference.cnn \
                    --annotate ${REF_DIR}/refFlat.txt \
                    -d ${TOOL_OUT_DIR}/ \
                    -m wgs \
                    -p ${CPU} && \
                cnvkit.py segment ${TOOL_OUT_DIR}/${BAM_FILE}.cnr -o ${TOOL_OUT_DIR}/${BAM_FILE}.cns && \
                cnvkit.py call ${TOOL_OUT_DIR}/${BAM_FILE}.cns -o ${TOOL_OUT_DIR}/${BAM_FILE}.call.cns && \
                cnvkit.py export vcf ${TOOL_OUT_DIR}/${BAM_FILE}.call.cns -i "${BAM_FILE}" -o ${TOOL_OUT_DIR}/${BAM_FILE}.cnv.vcf"
            
fi