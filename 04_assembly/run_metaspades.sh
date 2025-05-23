#!/bin/bash
#SBATCH --output=Job-spades-%a.out
#SBATCH --account=bhurwitz
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=48:00:00
#SBATCH --cpus-per-task=28
#SBATCH --mem-per-cpu=5gb
#SBATCH --array=0-2

pwd; hostname; date

source ./config.sh
names=($(cat $XFILE_DIR/$XFILE))

SAMPLE_ID=${names[${SLURM_ARRAY_TASK_ID}]}

PAIR1=${FASTQ_DIR}/${SAMPLE_ID}_1.fastq*
PAIR2=${FASTQ_DIR}/${SAMPLE_ID}_2.fastq*

#add threads flag & exposition on adding threads or it runs inefficient
apptainer run /contrib/singularity/shared/bhurwitz/spades:3.15.5--h95f258a_1.sif metaspades.py    -o ${OUT_SPADES}/${names[${SLURM_ARRAY_TASK_ID}]}    --pe1-1 ${PAIR1}    --pe1-2 ${PAIR2}
