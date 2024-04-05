git clone https://github.com/mehrdadbakhtiari/adVNTR

cd adVNTR
g++ -g -std=c++0x -c -I. -lm -O2 -lpthread -o filtering/main.o filtering/main.cc
g++ -g -std=c++0x -o adVNTR-Filtering filtering/main.o -I. -lm -O2 -lpthread

sudo apt-get install python2.7 python-pip python-tk libz-dev samtools muscle
install -m 755 adVNTR-Filtering /home/elukyanchikova/.local/bin
micromamba  env create -f .travis.yml
micromamba  activate advntr
 python setup.py install
python3 /home/elukyanchikova/adVNTR/tests/test_genotyping.py