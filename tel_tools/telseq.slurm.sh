#!/bin/bash

READ_LENGTH=150 # for telseq
SING_DIR="/mnt/Storage/testdata/Temp/sing_containers"
MEMORY=8 # random number :)
THREADS=4 # random number :)

CSV=$1 # format: INDEX, SAMPLE, LIBRARY, PIPELINE (ignore LIBRARY column, if PIPELINE is not germline --> use telomerecat because wotks with aneuploidy)
# other tools to concider: telomerecat, TRF, TideHunter (for long reads)

for SAMPLE in $(grep germline ${CSV} | cut -d, -f2 | sort | uniq); do
	PROJECT_ID=${SAMPLE:0:6}
	WORK_DIR="/mnt/Storage/testdata/Results/${PROJECT_ID}/${SAMPLE}"
	if [ ! -f ${WORK_DIR}/Temp/${SAMPLE}.MGI.cutadapt.bwa.MarkDuplicates.telseq.tsv ]; then
		TOOL_NAME="telseq"
		TELSEQ_JOB=$(
		echo -e "#!/bin/bash\n" \
		singularity run \
			--bind ${WORK_DIR}:${WORK_DIR} \
			--workdir ${WORK_DIR}/Temp \
			${SING_DIR}/telseq_0.0.2.sif \
			/telseq-0.0.2/bin/ubuntu/telseq -r ${READ_LENGTH} \
			-u ${WORK_DIR}/Alignments/${SAMPLE}.MGI.cutadapt.bwa.MarkDuplicates.bam \
			-o ${WORK_DIR}/Temp/${SAMPLE}.MGI.cutadapt.bwa.MarkDuplicates.telseq.tsv |
		sbatch --parsable --job-name ${TOOL_NAME}-${SAMPLE} \
			--mem ${MEMORY} --cpus-per-task ${THREADS} \
			--time 3:00:00 \
			-o "${WORK_DIR}/Logs/${SAMPLE}.telseq.out" \
			-e "${WORK_DIR}/Logs/${SAMPLE}.telseq.err" \
			--partition CPU --nice
		)
		echo "Submit JOB=${TELSEQ_JOB} ${TOOL_NAME}"
	fi
done
