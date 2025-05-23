#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --nodes=1             
#SBATCH --time=10:00:00   
#SBATCH --partition=standard
#SBATCH --account=bhurwitz
#SBATCH --array=0-2                         
#SBATCH --output=Job-fastqc-trim-%a.out
#SBATCH --cpus-per-task=1                  
#SBATCH --mem=4G                           

pwd; hostname; date

source ./config.sh
names=($(cat $XFILE_DIR/$XFILE))
TRIM_DIR="${WORK_DIR}/trimmed_reads"

apptainer run /contrib/singularity/shared/bhurwitz/fastqc-0.11.9.sif fastqc     $TRIM_DIR/${names[${SLURM_ARRAY_TASK_ID}]}_*.fastq*

mkdir ~/check_fastqc_trimmed2
cp $TRIM_DIR/${names[${SLURM_ARRAY_TASK_ID}]}_*_fastqc.html ~/check_fastqc_trimmed2 

