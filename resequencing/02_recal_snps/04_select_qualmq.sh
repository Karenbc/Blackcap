#!/bin/sh
# mkdir combine_select_vars and select_vars
# make list of populations as below
# cat > pops
# long_se
# med_nw_moos2
# med_nw_uk
# med_se_aus
# med_se_pol
# med_sw_bel
# med_sw_moos
# med_sw_rad
# res_anc
# res_isl_azo
# res_isl_cap
# res_isl_pal
# res_lis
# res_na
# short_sw
# usage ./script.sh
# run this for each snp caller
# selects higher quality snps before combining and selecting common snps with 04
# author = kdelmore
# date = sept 2016

module load jdk-oracle/x64/8u60

caller=$1
list=$2

while read prefix
do

ref='ref/HybridScaffold_05_bppAdjust_cmap_Blackcap_BspQI_Hybrid_withnotusedNGS_fasta_NGScontigs_HYBRID_SCAFFOLD.fasta'
gatk='/opt/biosoftware/GATK/GATK'

java -Xmx12g -jar $gatk/GenomeAnalysisTK.jar \
-T SelectVariants \
-R $ref \
-V $caller\_snps/$caller\_"$prefix".vcf \
-o $caller\_snps/$caller\_"$prefix".qualmq3.vcf \
-select "QUAL > 995.0" \
-nt 4

done < $2
