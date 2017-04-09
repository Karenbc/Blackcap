#!/bin/bash
# author: kira delmore
# date: july 2016
# usage: ./ known list
# creates and submits pbs files

#known="$1"
pbs="recal.pbs"
list="$2"

while read prefix
do
        echo "#!/bin/bash

#PBS -S /bin/bash
#PBS -l walltime=72:00:00
#PBS -l mem=4GB
#PBS -l nodes=1:ppn=1
#PBS -N "$prefix"_recal

known='$1'

## odds and ends to set
ref='/home/delmore/blackcaps_server/resequencing/ref/HybridScaffold_05_bppAdjust_cmap_Blackcap_BspQI_Hybrid_withnotusedNGS_fasta_NGScontigs_HYBRID_SCAFFOLD.fasta'
gatk='/opt/biosoftware/GATK/GATK'
realign='/home/delmore/blackcaps_server/resequencing/realign_bam_final'
recal='/home/delmore/blackcaps_server/resequencing/realign_bam_final_recal'
recal_tables='/home/delmore/blackcaps_server/resequencing/recal_tables'
recal_log='/home/delmore/blackcaps_server/resequencing/recal_logs'

cd \$PBS_O_WORKDIR
JOBINFO="$prefix"_\${PBS_JOBID}
echo \"Starting run at: \`date\`\" >> \$JOBINFO

module load jdk-oracle/x64/8u60
#PATH=$PATH:$HOME/bin:/opt/biosoftware/R/R/

## generate first pass recalibration file and use to recalibrate bams
java -jar \$gatk/GenomeAnalysisTK.jar -T BaseRecalibrator -R \$ref -I \$realign/"$prefix".realigned.bam -knownSites \$known -o \$recal_tables/"$prefix".recal_data.table > \$recal_log/"$prefix".bqsr
java -jar \$gatk/GenomeAnalysisTK.jar -T PrintReads -R \$ref -I \$realign/"$prefix".realigned.bam -BQSR \$recal_tables/"$prefix".recal_data.table -o \$recal/"$prefix"_reacalibrated.bam > \$recal_log/"$prefix".printreads

## generate second pass recalibration table and plots to evaluate how recalibration worked
java -jar \$gatk/GenomeAnalysisTK.jar -T BaseRecalibrator -R \$ref  -I \$realign/"$prefix".realigned.bam -knownSites \$known -BQSR \$recal_tables/"$prefix".recal_data.table -o \$recal_tables/"$prefix".recal2_data.table > \$recal_log/"$prefix".bqsr1
java -jar \$gatk/GenomeAnalysisTK.jar -T AnalyzeCovariates -R \$ref -before \$recal_tables/"$prefix".recal_data.table -after \$recal_tables/"$prefix".recal2_data.table -csv \$recal_tables/"$prefix"_bqsr.csv -plots \$recal_tables/"$prefix"_bqsr.pdf > \$recal_log/"$prefix".analyzecovar

echo \"Program finished with exit code \$? at: \`date\`\" >> \$JOBINFO" > $pbs/$prefix.pbs

qsub -c s $pbs/$prefix.pbs

done < $list
