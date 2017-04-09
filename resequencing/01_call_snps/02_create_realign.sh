#!/bin/bash
# author: kira delmore
# date: feb 2016
# usage: ./realign.sh <list>
# submits pbs file for each item in list
# change project name and paths
# ensure you have the pbs folder created
# modified from stickleback genome project, swth gbs project and comparative avian genomics project

list="$1"
pbs="realign.pbs"
project="demog"

while read prefix
do
        echo "#!/bin/bash

#PBS -S /bin/bash
#PBS -l walltime=24:00:00
#PBS -l mem=4GB
#PBS -l nodes=1:ppn=1
#PBS -N "$prefix"_realign

project='demog'

## odds and ends to set
#ref='/home/delmore/blackcaps_server/resequencing/ref/HybridScaffold_05_bppAdjust_cmap_Blackcap_BspQI_Hybrid_withnotusedNGS_fasta_NGScontigs_HYBRID_SCAFFOLD.folded.fasta'
ref='/home/delmore/blackcaps_server/resequencing/ref/HybridScaffold_05_bppAdjust_cmap_Blackcap_BspQI_Hybrid_withnotusedNGS_fasta_NGScontigs_HYBRID_SCAFFOLD.fasta'

## directories
log='/home/delmore/blackcaps_server/resequencing/log'
bam_final='/home/delmore/blackcaps_server/resequencing/bam_final'
realign_bam_final='/home/delmore/blackcaps_server/resequencing/realign_bam_final'
intervals='/home/delmore/blackcaps_server/resequencing/intervals'
#intervals='/home/delmore/blackcaps_server/resequencing/intervals/interval_output.blackcaps2.list'
#gvcf='/home/delmore/blackcaps_server/resequencing/gvcfs'
#bamout='/home/delmore/blackcaps_server/resequencing/bamout'

## tools
gatk='/opt/biosoftware/GATK/GATK'

cd \$PBS_O_WORKDIR
JOBINFO="$prefix"_\${PBS_JOBID}
echo \"Starting run at: \`date\`\" >> \$JOBINFO

module load jdk-oracle/x64/8u60

## realign around indels with gatk

java -Xmx4g -jar \$gatk/GenomeAnalysisTK.jar -T RealignerTargetCreator -R \$ref -I \$bam_final/"$prefix".combo.bam -nt 2 -o \$intervals/"$prefix".intervals -log \$log/"$prefix".targetcreator.log
java -Xmx4g -jar \$gatk/GenomeAnalysisTK.jar -T IndelRealigner -R \$ref -I \$bam_final/"$prefix".combo.bam -targetIntervals \$intervals/"$prefix".intervals -o \$realign_bam_final/"$prefix".realigned.bam -log \$log/"$prefix".indelrealigner.log

## generate gvcf

#java -Xmx23g -jar \$gatk/GenomeAnalysisTK.jar -T HaplotypeCaller -R \$ref -l INFO -I \$realign_bam_final/"$prefix".realigned.bam --emitRefConfidence GVCF --max_alternate_alleles 2 -variant_index_type LINEAR -variant_index_parameter 128000 -o \$gvcf/"$prefix".gvcf -log \$log/"$prefix".haplotypecaller.log -bamout \$bamout/"$prefix".bamout.bam

echo \"Program finished with exit code \$? at: \`date\`\" >> \$JOBINFO" > $pbs/$prefix.pbs

qsub -c s $pbs/$prefix.pbs

done < $list
