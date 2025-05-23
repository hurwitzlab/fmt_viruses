#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --nodes=1             
#SBATCH --time=10:00:00   
#SBATCH --partition=standard
#SBATCH --account=bhurwitz
#SBATCH --array=0-2             # the number of accession files
#SBATCH --output=Job-gzip-%a.out
#SBATCH --cpus-per-task=1        # num CPUs per task
#SBATCH --mem=4G                 # total memory per node
 
pwd; hostname; date
source ./config.sh
names=($(cat ${XFILE_DIR}/${XFILE}))
gzip ${FASTQ_DIR}/${names[${SLURM_ARRAY_TASK_ID}]}_*.fastq
