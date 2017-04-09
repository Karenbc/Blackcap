#!/bin/bash
# author: kira delmore
# date: nov 2016
# usage: ./vqsr.sh <list>
# submits pbs file for each item in list
# based on https://software.broadinstitute.org/gatk/guide/article?id=1259

list="$1"
pbs="vqsr.pbs"

while read prefix
do
        echo "#!/bin/bash
#PBS -S /bin/bash
#PBS -l walltime=24:00:00
#PBS -l nodes=1:ppn=4
#PBS -N "$prefix"_vqsr

## odds and ends

ref='/home/delmore/blackcaps_server/resequencing/ref/HybridScaffold_05_bppAdjust_cmap_Blackcap_BspQI_Hybrid_withnotusedNGS_fasta_NGScontigs_HYBRID_SCAFFOLD.fasta'
recal='/home/delmore/blackcaps_server/resequencing/vqsr'
snps='/home/delmore/blackcaps_server/resequencing/unified_snps_step2'
gatk='/opt/biosoftware/GATK/GATK'
known='/home/delmore/blackcaps_server/resequencing/combine_select_vars/select_vars.qualmq3.vcf'

cd \$PBS_O_WORKDIR
JOBINFO="$prefix"_vqsr_\${PBS_JOBID}
echo \"Starting run at: \`date\`\" >> \$JOBINFO

module load jdk-oracle/x64/8u60

java -Xmx48g -jar \$gatk/GenomeAnalysisTK.jar \
   -T VariantRecalibrator \
   -R \$ref \
   -input \$snps/unified_"$prefix".vcf \
   -recalFile \$recal/"$prefix".recal \
   -tranchesFile \$recal/"$prefix".tranches \
   -rscriptFile \$recal/"$prefix".recalibrate_SNP_plots.R \
   -nt 4 \
   -resource:filtered,known=false,training=true,truth=true,prior=10.0 \$known \
   -an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR -an DP -an HaplotypeScore \
   -mode SNP

 java -Xmx48g -jar \$gatk/GenomeAnalysisTK.jar \
   -T ApplyRecalibration \
   -R \$ref \
   -input \$snps/unified_"$prefix".vcf \
   -recalFile \$recal/"$prefix".recal \
   -tranchesFile \$recal/"$prefix".tranches \
   -o \$recal/"$prefix".recalibrated.filtered.vcf \
   -mode SNP \
   --ts_filter_level 99.0 

echo \"Program finished with exit code \$? at: \`date\`\" >> \$JOBINFO" > $pbs/$prefix.pbs
   
qsub -c s $pbs/$prefix.pbs

done < $list
