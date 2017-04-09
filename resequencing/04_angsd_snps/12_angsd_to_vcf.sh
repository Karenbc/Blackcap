#!/bin/bash
## obtain genotype probabilities for vcf
## author: kira delmore
## date: mar 2017

#SBATCH --job-name=vcf
#SBATCH --ntasks=8
#SBATCH --nodes=1
#SBATCH --time=164:00:00
#SBATCH --mem=248G
#SBATCH --error=job.%J.vcf.err.wallace
#SBATCH --output=job.%J.vcf.out.wallace
#SBATCH --mail-type=ALL
#SBATCH --mail-user=delmore@evolbio.mpg.de
#SBATCH --partition=global

list=bam.filelist
minind=55
nind=110

ANGSD='/home/delmore/tools/angsd/angsd'

ref='/home/delmore/blackcaps_server/resequencing/ref/HybridScaffold_05_bppAdjust_cmap_Blackcap_BspQI_Hybrid_withnotusedNGS_fasta_NGScontigs_HYBRID_SCAFFOLD.fasta'
out='/home/delmore/blackcaps_server/resequencing/vcf'

$ANGSD/angsd -P 8 -b $list -ref $ref -out $out/all_noz \
        -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 \
        -minMapQ 20 -minQ 20 -minInd $minind -skipTriallelic 1 \
        -SNP_pval 1e-6 -rf exclude_z \
        -doVcf 1 -doPost 1 -doMajorMinor 1 -GL 1 -doMaf 1
