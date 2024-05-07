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
bash ./wisecondorx.sh convert /home/user/WisecondorX_Docker/samples  /home/user/WisecondorX_Docker/testoptput 1
```

