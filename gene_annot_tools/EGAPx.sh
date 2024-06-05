git clone https://github.com/ncbi/egapx.git
cd egapx

python3 -m venv /home/gvykhodtsev/egapx_venv
source /home/gvykhodtsev/egapx_venv/bin/activate
pip install -r ui/requirements.txt

python3 ui/egapx.py ./polar_bear/BTC_polar_bear.yaml -o /mnt/data/gvykhodtsev/genomes/BTC_polar_bear/EGAPx
