#!/bin/bash
## obtain genotype probabilities for plink
## author: kira delmore
## date: mar 2017

#SBATCH --job-name=plink
#SBATCH --ntasks=8
#SBATCH --nodes=1
#SBATCH --time=164:00:00
#SBATCH --mem=248G
#SBATCH --error=job.%J.plink.err.wallace
#SBATCH --output=job.%J.plink.out.wallace
#SBATCH --mail-type=ALL
#SBATCH --mail-user=delmore@evolbio.mpg.de
#SBATCH --partition=global

list=bam.filelist
minind=55
nind=110

ANGSD='/home/delmore/tools/angsd/angsd'
NGSTOOLS='/opt/biosoftware/ngsTools/ngsTools'
NGSDIST='/opt/biosoftware/ngsDist/ngsDist'
FASTME='/home/delmore/tools/fastme-2.1.5/src/fastme'

ref='/home/delmore/blackcaps_server/resequencing/ref/HybridScaffold_05_bppAdjust_cmap_Blackcap_BspQI_Hybrid_withnotusedNGS_fasta_NGScontigs_HYBRID_SCAFFOLD.fasta'
plink='/home/delmore/blackcaps_server/resequencing/plink2'

$ANGSD/angsd -P 8 -b $list -ref $ref -out $plink/all_geno4_noz \
        -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 \
        -minMapQ 20 -minQ 20 -minInd $minind -skipTriallelic 1 \
        -SNP_pval 1e-6 -rf exclude_z \
        -doPlink 2 -doGeno -4 -doPost 1 -postCutoff 0.99 -doMajorMinor 1 -GL 1 -doCounts 1 -doMaf 2
