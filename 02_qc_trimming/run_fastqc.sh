#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --nodes=1             
#SBATCH --time=10:00:00   
#SBATCH --partition=standard
#SBATCH --account=bhurwitz
#SBATCH --array=0-2                         
#SBATCH --output=Job-fastqc-%a.out
#SBATCH --cpus-per-task=1                  
#SBATCH --mem=4G                           

pwd; hostname; date

source ./config.sh
names=($(cat $XFILE_DIR/$XFILE))

apptainer run /contrib/singularity/shared/bhurwitz/fastqc-0.11.9.sif fastqc     $FASTQ_DIR/${names[${SLURM_ARRAY_TASK_ID}]}_*.fastq*

mkdir ~/check_fastqc
cp $FASTQ_DIR/${names[${SLURM_ARRAY_TASK_ID}]}_*_fastqc.html ~/check_fastqc 
mv $FASTQ_DIR/${names[${SLURM_ARRAY_TASK_ID}]}_*_fastqc.html $WORK_DIR
mv $FASTQ_DIR/${names[${SLURM_ARRAY_TASK_ID}]}_*_fastqc.zip $WORK_DIR
 
