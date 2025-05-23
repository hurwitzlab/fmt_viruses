#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --nodes=1             
#SBATCH --time=10:00:00   
#SBATCH --partition=standard
#SBATCH --account=bhurwitz
#SBATCH --array=0-2                          # the number of accessions
#SBATCH --output=Job-trim-%a.out
#SBATCH --cpus-per-task=1                    # num CPUs per task
#SBATCH --mem=4G                             # total memory per node
 
pwd; hostname; date
source ./config.sh
names=($(cat ${XFILE_DIR}/${XFILE}))

TRIM_DIR="${WORK_DIR}/trimmed_reads"
UNPAIR_DIR="${WORK_DIR}/unpaired_reads"

apptainer run /contrib/singularity/shared/bhurwitz/trimmomatic:0.39--hdfd78af_2.sif trimmomatic PE -phred33     ${FASTQ_DIR}/${names[${SLURM_ARRAY_TASK_ID}]}_1.fastq.gz ${FASTQ_DIR}/${names[${SLURM_ARRAY_TASK_ID}]}_2.fastq.gz     ${TRIM_DIR}/${names[${SLURM_ARRAY_TASK_ID}]}_1.fastq.gz ${UNPAIR_DIR}/${names[${SLURM_ARRAY_TASK_ID}]}_1.fastq.gz     ${TRIM_DIR}/${names[${SLURM_ARRAY_TASK_ID}]}_2.fastq.gz ${UNPAIR_DIR}/${names[${SLURM_ARRAY_TASK_ID}]}_2.fastq.gz     ILLUMINACLIP:TruSeq3-PE-2.fa:2:30:10 SLIDINGWINDOW:4:20
