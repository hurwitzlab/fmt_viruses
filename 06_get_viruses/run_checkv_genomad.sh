#!/bin/bash
#SBATCH --output=Job-checkv-genomad-%a.out
#SBATCH --account=bhurwitz
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=20:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=1000
#SBATCH --array=0-2

pwd; hostname; date

source ./config.sh
names=($(cat $XFILE_DIR/$XFILE))
SAMPLE_ID=${names[${SLURM_ARRAY_TASK_ID}]}

GENOMAD=${OUT_GENOMAD}/${SAMPLE_ID}/contigs_summary/contigs_virus.fna

#load environment
CONDA="/groups/bhurwitz/miniconda3"
source $CONDA/etc/profile.d/conda.sh
conda activate checkv_env

checkv end_to_end ${GENOMAD} ${OUT_CHECKV_GENOMAD}/${names[${SLURM_ARRAY_TASK_ID}]} -t 16
