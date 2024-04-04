#установка зависимостей miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh
bash Miniconda3-py39_4.9.2-Linux-x86_64.sh
#установка
git clone git@github.com:unique379r/strspy
cd strspy
bash setup/STRspy_setup.sh
set auto_activate_base false
miniconda config --set auto_activate_base false
#генерация среды
micromamba  env create -f /home/elukyanchikova/strspy/setup/environment.yml
micromamba activate strspy_env
#установка конфигурации
bash setup/MakeToolConfig.sh
mv UserToolsConfig.txt config/
#запуск
bash ./STRspy_run_v1.0.sh -h
bash ./STRspy_run_v1.0.sh config/InputConfig.txt config/ToolsConfig.txt
bash ./STRspy_Parallel_v0.1.sh example/test_dir no ont example/str_fa example/str_bed example/ref_fasta/hg19.fa region_bed 0.4 output_dir tools_config.txt