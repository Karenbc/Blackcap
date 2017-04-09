#!/bin/sh
# mkdir combine_select_vars and select_vars
# usage ./script.sh
# author = kdelmore
# date = sept 2016
# combines variants from seperate snps callers and populations that are above a certain QUAL threshold and selects common snps

module load jdk-oracle/x64/8u60

pop1='long_se'
pop2='med_nw_moos2'
pop3='med_nw_uk'
pop4='med_se_aus'
pop5='med_se_pol'
pop6='med_sw_bel'
pop7='med_sw_moos'
pop8='med_sw_rad'
pop9='res_anc'
pop10='res_isl_azo'
pop11='res_isl_cap'
pop12='res_isl_pal'
pop13='res_lis'
pop14='res_na'
pop15='short_sw'

ref='ref/HybridScaffold_05_bppAdjust_cmap_Blackcap_BspQI_Hybrid_withnotusedNGS_fasta_NGScontigs_HYBRID_SCAFFOLD.fasta'
gatk='/opt/biosoftware/GATK/GATK'

java -Xmx48g -jar $gatk/GenomeAnalysisTK.jar \
-T CombineVariants \
-R $ref \
--variant samtools_snps/samtools_$pop1.qualmq3.vcf \
--variant freebays_snps/freebays_$pop1.qualmq3.vcf \
--variant unified_snps/unified_$pop1.qualmq3.vcf \
--variant samtools_snps/samtools_$pop2.qualmq3.vcf \
--variant freebays_snps/freebays_$pop2.qualmq3.vcf \
--variant unified_snps/unified_$pop3.qualmq3.vcf \
--variant samtools_snps/samtools_$pop3.qualmq3.vcf \
--variant freebays_snps/freebays_$pop3.qualmq3.vcf \
--variant unified_snps/unified_$pop3.qualmq3.vcf \
--variant samtools_snps/samtools_$pop4.qualmq3.vcf \
--variant freebays_snps/freebays_$pop4.qualmq3.vcf \
--variant unified_snps/unified_$pop4.qualmq3.vcf \
--variant samtools_snps/samtools_$pop5.qualmq3.vcf \
--variant freebays_snps/freebays_$pop5.qualmq3.vcf \
--variant unified_snps/unified_$pop5.qualmq3.vcf \
--variant samtools_snps/samtools_$pop6.qualmq3.vcf \
--variant freebays_snps/freebays_$pop6.qualmq3.vcf \
--variant unified_snps/unified_$pop6.qualmq3.vcf \
--variant samtools_snps/samtools_$pop7.qualmq3.vcf \
--variant freebays_snps/freebays_$pop7.qualmq3.vcf \
--variant unified_snps/unified_$pop7.qualmq3.vcf \
--variant samtools_snps/samtools_$pop8.qualmq3.vcf \
--variant freebays_snps/freebays_$pop8.qualmq3.vcf \
--variant unified_snps/unified_$pop8.qualmq3.vcf \
--variant samtools_snps/samtools_$pop9.qualmq3.vcf \
--variant freebays_snps/freebays_$pop9.qualmq3.vcf \
--variant unified_snps/unified_$pop9.qualmq3.vcf \
--variant samtools_snps/samtools_$pop10.qualmq3.vcf \
--variant freebays_snps/freebays_$pop10.qualmq3.vcf \
--variant unified_snps/unified_$pop10.qualmq3.vcf \
--variant samtools_snps/samtools_$pop11.qualmq3.vcf \
--variant freebays_snps/freebays_$pop11.qualmq3.vcf \
--variant unified_snps/unified_$pop11.qualmq3.vcf \
--variant samtools_snps/samtools_$pop12.qualmq3.vcf \
--variant freebays_snps/freebays_$pop12.qualmq3.vcf \
--variant unified_snps/unified_$pop12.qualmq3.vcf \
--variant samtools_snps/samtools_$pop13.qualmq3.vcf \
--variant freebays_snps/freebays_$pop13.qualmq3.vcf \
--variant unified_snps/unified_$pop13.qualmq3.vcf \
--variant samtools_snps/samtools_$pop14.qualmq3.vcf \
--variant freebays_snps/freebays_$pop14.qualmq3.vcf \
--variant unified_snps/unified_$pop14.qualmq3.vcf \
--variant samtools_snps/samtools_$pop15.qualmq3.vcf \
--variant freebays_snps/freebays_$pop15.qualmq3.vcf \
--variant unified_snps/unified_$pop15.qualmq3.vcf \
-o combine_select_vars/combine_vars.qualmq3.vcf \
-genotypeMergeOptions UNIQUIFY \
-nt 4

java -Xmx48g -jar $gatk/GenomeAnalysisTK.jar \
-T SelectVariants \
-R $ref \
-V combine_select_vars/combine_vars.qualmq3.vcf \
-o combine_select_vars/select_vars.qualmq3.vcf \
-select 'set == "Intersection"' \
-nt 4
