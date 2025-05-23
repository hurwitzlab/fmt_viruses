#!/bin/bash
#SBATCH --output=./logs/02A_dvf/Job-%a.out
#SBATCH --account=bhurwitz
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=20:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=5000
#SBATCH --array=0-2

pwd; hostname; date

source ./config.sh
names=($(cat $XFILE_DIR/$XFILE))
SAMPLE_ID=${names[${SLURM_ARRAY_TASK_ID}]}

SPADES=${SPADES_DIR}/${SAMPLE_ID}/contigs.fasta.gz
UNZIPPED_SPADES=${SPADES_DIR}/${SAMPLE_ID}/contigs.fasta

gzip -d ${SPADES}

#load environment
CONDA="/groups/bhurwitz/miniconda3"
source $CONDA/etc/profile.d/conda.sh
conda activate dvf

cd ${DVF_DB}

python dvf.py -i ${UNZIPPED_SPADES} -o ${OUT_DVF}/${names[${SLURM_ARRAY_TASK_ID}]} -l 1500

gzip ${UNZIPPED_SPADES}

cd ${WORK_DIR}
