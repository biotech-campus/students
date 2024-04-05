#установка
git clone --recursive https://github.com/ChaissonLab/danbing-tk
cd danbing-tk
make -j 5
micromamba activate /home/elukyanchikova/micromamba/envs/danbing-tk
micromamba create -n $MY_ENVIRONMENT -c conda-forge -c bioconda
micromamba  config --show channels
conda create -n myenv numpy
conda activate myenv
#запуск
danbing-tk
#or  
python3 danbing-tk
samtools-1.17.tar.bz2 /opt/samtools-1.17.tar.bz2
conda deactivate
