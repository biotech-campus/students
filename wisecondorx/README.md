# WisecondorX_Docker
Docker and sh file for WisecondorX

# Usage
## Convert
Function `convert` converts indexed and sorted bam files to npz files

```
bash ./wisecondorx.sh convert [abs path to folder with bams]  [abs path to output folder] [number of threads]
```

Usage example: 

```
bash ./wisecondorx.sh convert /home/user/samples  /home/user/testoptput 16
```

## Newref 
Function `newref` creates ref.npz from many WT samples (5 female and 5 male at least) 

```
bash ./wisecondorx.sh newref [folder to many reference npz files] [output filename.npz] [number of threads]
```
Usage example: 

```
bash ./wisecondorx.sh newref /home/user/files_to_ref/ /home/user/ref.npz 16
```

## Predict 
Function `predict` generate bed file and plots for your sample. It requires reference.npz file 

```
bash ./wisecondorx.sh predict [folder to many sample files you want to predict] [reference file.npz] [folder to output] [number of threads]
```

Usage example: 

```
bash ./wisecondorx.sh predict /home/user/samples/ /home/user/ref.npz /home/user/predict_output/ 16
```
