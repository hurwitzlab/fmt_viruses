#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --nodes=1             
#SBATCH --time=24:00:00   
#SBATCH --partition=standard
#SBATCH --account=bhurwitz
#SBATCH --array=0-2                         
#SBATCH --output=Job-rem_human-%a.out
#SBATCH --cpus-per-task=24
#SBATCH --mem-per-cpu=5G                                    

pwd; hostname; date

source $SLURM_SUBMIT_DIR/config.sh
names=($(cat $XFILE_DIR/$XFILE))

SAMPLE_ID=${names[${SLURM_ARRAY_TASK_ID}]}

PAIR1=${FASTQ_DIR}/${SAMPLE_ID}_1.fastq.gz
PAIR2=${FASTQ_DIR}/${SAMPLE_ID}_2.fastq.gz

### reads with human removed
BOWTIE_NAME="${WORK_DIR}/${SAMPLE_ID}_%.fastq.gz"
SAM_NAME="${WORK_DIR}/${SAMPLE_ID}_human_removed.sam"

### reads mapped to human
MET_NAME="${WORK_DIR}/${SAMPLE_ID}_hostmap.log"

apptainer run /contrib/singularity/shared/bhurwitz/bowtie2:2.5.1--py39h6fed5c7_2.sif bowtie2     -p 24 -x $HUM_DB -1 $PAIR1 -2 $PAIR2 --un-conc-gz $BOWTIE_NAME 1> $SAM_NAME 2> $MET_NAME

rm $SAM_NAME
