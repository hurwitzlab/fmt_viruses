#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --nodes=1             
#SBATCH --time=10:00:00   
#SBATCH --partition=standard
#SBATCH --account=bhurwitz
#SBATCH --array=0-52                         
#SBATCH --output=Job-megahit-taxonomy-%a.out
#SBATCH --cpus-per-task=24
#SBATCH --mem-per-cpu=5G  

pwd; hostname; date

source $SLURM_SUBMIT_DIR/config.sh
names=($(cat $XFILE_DIR/$XFILE))

SAMPLE_ID=${names[${SLURM_ARRAY_TASK_ID}]}

### contigs
CONTIGS=${MEGAHIT_CONTIG_DIR}/${SAMPLE_ID}/final.contigs.fa.gz

KRAKEN_OUTDIR=${WORK_DIR}/out_megahit_taxonomy
OUTDIR=${KRAKEN_OUTDIR}/${SAMPLE_ID}
HUMAN_READ_DIR=${OUTDIR}/human_contigs
NONHUMAN_READ_DIR=${OUTDIR}/nonhuman_contigs

### create the outdir if it does not exist
if [[ ! -d "$KRAKEN_OUTDIR" ]]; then
  echo "$KRAKEN_OUTDIR does not exist. Directory created"
  mkdir $KRAKEN_OUTDIR
fi
                                  
if [[ ! -d "$OUTDIR" ]]; then
  echo "$OUTDIR does not exist. Directory created"
  mkdir $OUTDIR
fi

if [[ ! -d "$HUMAN_READ_DIR" ]]; then
  echo "$HUMAN_READ_DIR does not exist. Directory created"
  mkdir $HUMAN_READ_DIR
fi

if [[ ! -d "$NONHUMAN_READ_DIR" ]]; then
  echo "$NONHUMAN_READ_DIR does not exist. Directory created"
  mkdir $NONHUMAN_READ_DIR
fi

apptainer run ${KRAKEN2} kraken2 --db ${DB_DIR} --classified-out  ${OUTDIR}/cseqs#.fa --output ${OUTDIR}/kraken_results.txt  --report ${OUTDIR}/kraken_report.txt --use-names --threads ${SLURM_CPUS_PER_TASK}  ${CONTIGS} --gzip-compressed

# refine hits with Bracken
REPORT="${OUTDIR}/kraken_report.txt"
RESULTS="${OUTDIR}/kraken_results.txt"
apptainer run ${BRACKEN} est_abundance.py -i ${REPORT} -o ${OUTDIR}/bracken_results.txt -k ${DB_DIR}/database${KMER_SIZE}mers.kmer_distrib

# get human and non-human reads (microbial)
TAXID=9606
HUMAN_R1="${HUMAN_READ_DIR}/contigs.fa"

BRACKEN_REPORT="${OUTDIR}/kraken_report_bracken_species.txt"
BRACKEN_RESULTS="${OUTDIR}/bracken_results.txt"

apptainer run ${KRAKENTOOLS} extract_kraken_reads.py -k ${RESULTS}  -r ${BRACKEN_REPORT} -s1 ${CONTIGS} --taxid ${TAXID} -o ${HUMAN_R1}  --include-children 

if [[ -f "${HUMAN_READ_DIR}/contigs.fa" ]]; then
    gzip ${HUMAN_READ_DIR}/contigs.fa
fi

### selects all reads NOT from a given set of Kraken taxids (and all children)

NONHUMAN_R1="${NONHUMAN_READ_DIR}/contigs.fa"

apptainer run ${KRAKENTOOLS} extract_kraken_reads.py -k ${RESULTS}  -r ${BRACKEN_REPORT} -s1 ${CONTIGS} --taxid ${TAXID} -o ${NONHUMAN_R1}  --include-children --exclude 

if [[ -f "${NONHUMAN_READ_DIR}/contigs.fa" ]]; then
    gzip ${NONHUMAN_READ_DIR}/contigs.fa
fi

echo "Finished `date`"

