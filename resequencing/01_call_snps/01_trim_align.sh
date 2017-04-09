#!/bin/bash
# author: kira delmore
# date: feb 2016
# usage: ./align.sh <list>
# submits pbs file for each item in list
# change project name and paths
# ensure you have the pbs folder created
# modified from stickleback genome project, swth gbs project and comparative avian genomics project

list="$1"
pbs="trim_align.pbs"
project="demog"

while read prefix
do
        echo "#!/bin/bash

#PBS -S /bin/bash
#PBS -l walltime=48:00:00
#PBS -l mem=7GB
#PBS -l nodes=1:ppn=4
#PBS -N "$prefix"_align

## odds and ends to set
ref='/home/delmore/blackcaps_server/resequencing/ref/HybridScaffold_05_bppAdjust_cmap_Blackcap_BspQI_Hybrid_withnotusedNGS_fasta_NGScontigs_HYBRID_SCAFFOLD.fasta'

## directories
raw='/home/delmore/blackcaps_server/resequencing/raw'
trim='/home/delmore/blackcaps_server/resequencing/trim'
sam='/home/delmore/blackcaps_server/resequencing/sam'
bam='/home/delmore/blackcaps_server/resequencing/bam'
log='/home/delmore/blackcaps_server/resequencing/log'
bam_final='/home/delmore/blackcaps_server/resequencing/bam_final'

## tools
trimmomatic="/home/delmore/tools/trimmomatic-0.32/trimmomatic-0.32.jar"
bwa='/usr/local/bin/bwa'
picardtools='/opt/biosoftware/picard/picard-tools-1.90'
samtools='/usr/local/bin/samtools'
project='demog'

cd \$PBS_O_WORKDIR
JOBINFO="$prefix"_\${PBS_JOBID}
echo \"Starting run at: \`date\`\" >> \$JOBINFO

## trim reads

java -jar \$trimmomatic PE -phred33 -threads 4 \$raw/"$prefix"_R1.fastq.gz \$raw/"$prefix"_R2.fastq.gz \$trim/"$prefix"_R1.fastq \$trim/"$prefix"_R1_unpaired.fastq \$trim/"$prefix"_R2.fastq \$trim/"$prefix"_R2_unpaired.fastq ILLUMINACLIP:TruSeq3-PE-2.fa:2:30:10 MINLEN:36 LEADING:3  TRAILING:3 SLIDINGWINDOW:4:15

## align reads with bwa

\$bwa mem -M -t 4 \$ref \$trim/"$prefix"_R1.fastq \$trim/"$prefix"_R2.fastq > \$sam/"$prefix".sam 2> \$log/"$prefix".bwape.log 
\$bwa mem -M \$ref \$trim/"$prefix"_R1_unpaired.fastq > \$sam/"$prefix"_1_unpaired.sam 2> \$log/"$prefix".bwase1.log
\$bwa mem -M \$ref \$trim/"$prefix"_R2_unpaired.fastq > \$sam/"$prefix"_2_unpaired.sam 2> \$log/"$prefix".bwase2.log

rm \$trim/"$prefix"*

\$samtools view -Sb \$sam/"$prefix".sam > \$bam/"$prefix".bam 2>  \$log/"$prefix".sampe.log
\$samtools view -Sb \$sam/"$prefix"_1_unpaired.sam > \$bam/"$prefix"_1_unpaired.bam 2>  \$log/"$prefix".samse1.log
\$samtools view -Sb \$sam/"$prefix"_2_unpaired.sam > \$bam/"$prefix"_2_unpaired.bam 2>  \$log/"$prefix".samse2.log

rm \$sam/"$prefix"*

java -jar \$picardtools/CleanSam.jar INPUT=\$bam/"$prefix".bam OUTPUT=\$bam/"$prefix".clean.bam  2> \$log/"$prefix".cleansam.log
java -jar \$picardtools/SortSam.jar TMP_DIR=`pwd`/tmp INPUT=\$bam/"$prefix".clean.bam OUTPUT=\$bam/"$prefix".sort.bam MAX_RECORDS_IN_RAM=5000000 SORT_ORDER=coordinate 2> \$log/"$prefix".sortsam.log
java -jar \$picardtools/AddOrReplaceReadGroups.jar TMP_DIR=`pwd`/tmp I=\$bam/"$prefix".sort.bam O=\$bam/"$prefix".sortrg.bam MAX_RECORDS_IN_RAM=5000000 SORT_ORDER=coordinate RGID="$prefix" RGLB="$project" RGPL=ILLUMINA RGPU="$project" RGSM="$prefix" CREATE_INDEX=True 2> \$log/"$prefix".addRG.log
java -Xmx7g -jar \$picardtools/MarkDuplicates.jar TMP_DIR=`pwd`/tmp INPUT=\$bam/"$prefix".sortrg.bam MAX_RECORDS_IN_RAM=5000000 OUTPUT=\$bam/"$prefix".duprem.bam M=\$log/"$prefix".duprem.log REMOVE_DUPLICATES=true

java -jar \$picardtools/CleanSam.jar INPUT=\$bam/"$prefix"_1_unpaired.bam OUTPUT=\$bam/"$prefix"_1_unpaired.clean.bam 2> \$log/"$prefix"_1_unpaired.cleansam.log
java -jar \$picardtools/SortSam.jar INPUT=\$bam/"$prefix"_1_unpaired.clean.bam OUTPUT=\$bam/"$prefix"_1_unpaired.sort.bam SORT_ORDER=coordinate 2> \$log/"$prefix"_1_unpaired.sortsam.log
java -jar \$picardtools/AddOrReplaceReadGroups.jar I=\$bam/"$prefix"_1_unpaired.sort.bam O=\$bam/"$prefix"_1_unpaired.sortrg.bam SORT_ORDER=coordinate RGID="$prefix" RGLB="$project" RGPL=ILLUMINA RGPU="$project" RGSM="$prefix" CREATE_INDEX=True 2> \$log/"$prefix"_1_unpaired.addRG.log

java -jar \$picardtools/CleanSam.jar INPUT=\$bam/"$prefix"_2_unpaired.bam OUTPUT=\$bam/"$prefix"_2_unpaired.clean.bam 2> \$log/"$prefix"_2_unpaired.cleansam.log
java -jar \$picardtools/SortSam.jar INPUT=\$bam/"$prefix"_2_unpaired.clean.bam OUTPUT=\$bam/"$prefix"_2_unpaired.sort.bam SORT_ORDER=coordinate 2> \$log/"$prefix"_2_unpaired.sortsam.log
java -jar \$picardtools/AddOrReplaceReadGroups.jar I=\$bam/"$prefix"_2_unpaired.sort.bam O=\$bam/"$prefix"_2_unpaired.sortrg.bam SORT_ORDER=coordinate RGID="$prefix" RGLB="$project" RGPL=ILLUMINA RGPU="$project" RGSM="$prefix" CREATE_INDEX=True 2> \$log/"$prefix"_2_unpaired.addRG.log

\$samtools merge \$bam_final/"$prefix".combo.bam \$bam/"$prefix".duprem.bam \$bam/"$prefix"_1_unpaired.sortrg.bam \$bam/"$prefix"_2_unpaired.sortrg.bam > \$log/"$prefix".sammerge.log
\$samtools index \$bam_final/"$prefix".combo.bam

rm \$bam/"$prefix"*

echo \"Program finished with exit code \$? at: \`date\`\" >> \$JOBINFO" > $pbs/$prefix.pbs

qsub -c s $pbs/$prefix.pbs

done < $list
