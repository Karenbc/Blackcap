#!/bin/sh
# usage ./script.sh
# author = kira delmore
# date = nov 2016
# combines variants from seperate populations that have been run through vqsr and filtered for PASS

module load jdk-oracle/x64/8u60

pop1='med_se_vienna'
pop2='res_na'
pop3='res_lis'
pop4='res_anc'
pop5='med_sw_rad'
pop6='med_se_aus'
pop7='med_sw_belb'
pop8='med_se_pol'
pop9='med_sw_moos'
pop10='med_nw_ukb'
pop11='res_isl_azo'
pop12='res_isl_cap'
pop13='med_nw_moos'
pop14='res_isl_pal'
pop15='long_seb'
pop16='short_swb'

ref='ref/HybridScaffold_05_bppAdjust_cmap_Blackcap_BspQI_Hybrid_withnotusedNGS_fasta_NGScontigs_HYBRID_SCAFFOLD.fasta'
gatk='/opt/biosoftware/GATK/GATK'
vcf='vqsr/'

java -Xmx48g -jar $gatk/GenomeAnalysisTK.jar \
-T CombineVariants \
-R $ref \
--variant $vcf/$pop1.recalibrated.filtered2.vcf \
--variant $vcf/$pop2.recalibrated.filtered2.vcf \
--variant $vcf/$pop3.recalibrated.filtered2.vcf \
--variant $vcf/$pop4.recalibrated.filtered2.vcf \
--variant $vcf/$pop5.recalibrated.filtered2.vcf \
--variant $vcf/$pop6.recalibrated.filtered2.vcf \
--variant $vcf/$pop7.recalibrated.filtered2.vcf \
--variant $vcf/$pop8.recalibrated.filtered2.vcf \
--variant $vcf/$pop9.recalibrated.filtered2.vcf \
--variant $vcf/$pop10.recalibrated.filtered2.vcf \
--variant $vcf/$pop11.recalibrated.filtered2.vcf \
--variant $vcf/$pop12.recalibrated.filtered2.vcf \
--variant $vcf/$pop13.recalibrated.filtered2.vcf \
--variant $vcf/$pop14.recalibrated.filtered2.vcf \
--variant $vcf/$pop15.recalibrated.filtered2.vcf \
--variant $vcf/$pop16.recalibrated.filtered2.vcf \
-o $vcf/vqsr_variants.vcf \
-nt 4
