## shell script to filter our all snps that do not have PASS in FILTER following VQSR
## author: kira delmore
## date: nov 2016
## usage ./sh <list>

ref='/home/delmore/blackcaps_server/resequencing/ref/HybridScaffold_05_bppAdjust_cmap_Blackcap_BspQI_Hybrid_withnotusedNGS_fasta_NGScontigs_HYBRID_SCAFFOLD.fasta'
vcfs='/home/delmore/blackcaps_server/resequencing/vqsr/'
while read prefix
do

java -jar /opt/biosoftware/GATK/GATK/GenomeAnalysisTK.jar \
   -T SelectVariants \
   -R $ref \
   -V $vcfs/"$prefix".recalibrated.filtered.vcf \
   -o $vcfs/"$prefix".recalibrated.filtered2.vcf \
   --excludeFiltered
   
done < $1
