#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --nodes=1             
#SBATCH --time=10:00:00   
#SBATCH --partition=standard
#SBATCH --account=bhurwitz
#SBATCH --array=0-2                          
#SBATCH --output=Job-%a.out
#SBATCH --cpus-per-task=1                    
#SBATCH --mem=4G                          
 
pwd; hostname; date

source ./config.sh
names=($(cat $XFILE_DIR/$XFILE))
 
echo ${names[${SLURM_ARRAY_TASK_ID}]}

apptainer run /contrib/singularity/shared/bhurwitz/sra-tools-3.0.3.sif prefetch ${names[${SLURM_ARRAY_TASK_ID}]}
apptainer run /contrib/singularity/shared/bhurwitz/sra-tools-3.0.3.sif fasterq-dump --split-files     ${names[${SLURM_ARRAY_TASK_ID}]}
