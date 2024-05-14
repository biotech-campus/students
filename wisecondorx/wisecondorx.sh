docker build -t wisecondorx:latest . 
WORKDIR="/home"

if [ $# -lt 1 ]; then
  echo "Error: No operation specified. Please use 'convert', 'newref', or 'predict' as the first argument."
  exit 1
fi

CONTAINER="wisecondorx:latest"
operation=$1 


if [ "$operation"!= "convert" ] && [ "$operation"!= "newref" ] && [ "$operation"!= "predict" ]; then
  echo "Error: Invalid operation. Please use 'convert', 'newref', or 'predict' as the first argument."
  exit 1
fi

start_time=$(date +%s)
start_memory=$(pmap -d $$ | awk '{print $3}')
start_cpu=$(top -b -n 1 | awk '/Cpu/ {print $2}' | sed 's/%//')

if [ "$operation" = "convert" ]; then 

    bam_folder=$2
    output_folder=$3
    threads=$4

    mkdir -p "$output_folder"
         
    bam_files=($(find "$bam_folder" -type f -name "*.bam"))
    echo "Converting BAM files to NPZ using WisecondorX..."
    for bam_file in "${bam_files[@]}"; do
        output_file="${output_folder}/${bam_file%.bam}.npz"
        echo "Converting $bam_file to $output_file"
        echo "docker run \
         --rm -v ${bam_folder}:${bam_folder}:ro -v ${output_folder}:${output_folder}:ro $CONTAINER WisecondorX convert /${bam_file} /${output_file}"  >> WiseConvert.logs
        docker run \
         --rm -v ${bam_folder}:${bam_folder}:ro -v ${output_folder}:${output_folder}:ro $CONTAINER \
         WisecondorX convert /${bam_file} /${output_file} &
    done | xargs -P "$threads" -n 1

   wait
   echo "All BAM files converted to NPZ successfully!" >> WiseConvert.logs
  echo "Conversion complete."

elif [ "$operation" = "newref" ]; then 

    input_folder=$2
    output_file=$3
    threads=$4
    docker run --rm -v ${input_folder}:${input_folder} -v ${output_file}:${output_file} $CONTAINER \
    WisecondorX newref /${input_folder}/*.npz /${output_file} --cpus $threads
    echo "All NPZ files processed successfully using WisecondorX newref!"

elif [ "$operation" = "predict" ]; then 

    input_folder=$2
    reference=$3 
    output_folder=$4
    threads=$5
    
    npz_to_predict=($(find "$input_folder" -type f -name "*.npz"))
    echo "Predicting NPZ files using WisecondorX..."
    for npz_file in "${npz_to_predict[@]}"; do 
        output_id="${output_folder}/${npz_file%.npz}"
        echo "Predicting $output_id"
        echo "docker run --rm -v ${input_folder}:${input_folder} -v ${reference}:${reference} -v ${output_folder}:${output_folder} $CONTAINER WisecondorX predict /${npz_file} /${reference} /${output_folder} --plot --bed &" >> WisePredict.logs
        docker run --rm -v ${input_folder}:${input_folder} -v ${reference}:${reference} -v ${output_folder}:${output_folder} $CONTAINER \ 
        WisecondorX predict /${npz_file} /${reference} /${output_folder} --plot --bed &
    done | xargs -P "$threads" -n 1

    wait 
    echo "All NPZ files were predicted. You can check results in $output_folder"
    echo "Prediction complete"

else
  echo "Invalid operation. Please use 'convert' as the first argument."
fi

end_time=$(date +%s)
end_memory=$(pmap -d $$ | awk '{print $3}')
end_cpu=$(top -b -n 1 | awk '/Cpu/ {print $2}' | sed 's/%//')

echo "Operation completed in $(($end_time - $start_time)) seconds."
echo "Memory usage: $(($end_memory - $start_memory)) MB"
echo "CPU usage: $(($end_cpu - $start_cpu))%"
