#!/bin/bash
#SBATCH -N 1
#SBATCH -c 8    # Number of cores (-c)
#SBATCH -t 0-08:00         # Runtime in D-HH:MM, minimum of 10 minutes
#SBATCH -p gpu,gpu_requeue   # Partition to submit to
#SBATCH --gres=gpu:1
#SBATCH --mem-per-cpu=4000          # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o ./out/myoutput_%j.out  # File to which STDOUT will be written, %j inserts jobid
#SBATCH -e ./err/myerrors_%j.err  # File to which STDERR will be written, %j inserts jobid
#source ~/.bashrc
source ~/.bashrc
source activate localcolabfold
module load gcc
fastafile=${1}
var1=$(echo $fastafile | awk -F "." '{print $1}')
echo $var1
mkdir -p $var1
colabfold_batch --amber --templates --num-recycle 5 --use-gpu-relax --rank iptm --model-type alphafold2_multimer_v3 $fastafile $var1
