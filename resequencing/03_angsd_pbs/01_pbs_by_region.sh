#!/bin/bash
# author: kira delmore
# date: feb 2016
# useage: ./pca.sh <list> <nInd> <minInd>
# submits pbs file for each item in list
# following guidelines from ngstools tutorial
# for now using half the nInd for minInd

list="$1"
pbs="pbs.pbs_long"

while read prefix
do
        echo "#!/bin/bash

#PBS -S /bin/bash
#PBS -l walltime=48:00:00
#PBS -l mem=6GB
#PBS -l nodes=1:ppn=2
#PBS -N "$prefix"_pbs_island

## odds and ends
minInd='$2'
pop1='$3'
pop2='$4'
pop3='$5'
pop4='$6'

## tools
ANGSD='/home/delmore/tools/angsd/angsd'
NGSTOOLS='/home/delmore/tools/ngsTools'

## directories
ref='ref/HybridScaffold_05_bppAdjust_cmap_Blackcap_BspQI_Hybrid_withnotusedNGS_fasta_NGScontigs_HYBRID_SCAFFOLD.fasta'
pbs='/home/delmore/blackcaps_server/resequencing/pbs_long'
log='/home/delmore/blackcaps_server/resequencing/pbs_logs_long'

cd \$PBS_O_WORKDIR
JOBINFO="$prefix"_island_\${PBS_JOBID}
echo \"Starting run at: \`date\`\" >> \$JOBINFO

export LD_LIBRARY_PATH=/usr/local/lib

## estimate sfs for each population
\$ANGSD/angsd -b \$pop1 -anc \$ref -remove_bads 1 -uniqueOnly 1 -minMapQ 20 -minQ 20 -only_proper_pairs 1 -trim 0 -minInd \$minInd -P 2 -out \$pbs/"$prefix"_pop1.pbs -r "$prefix": -dosaf 1 -gl 1 2> \$log/"$prefix"_sfs_pop1.log
\$ANGSD/angsd -b \$pop2 -anc \$ref -remove_bads 1 -uniqueOnly 1 -minMapQ 20 -minQ 20 -only_proper_pairs 1 -trim 0 -minInd \$minInd -P 2 -out \$pbs/"$prefix"_pop2.pbs -r "$prefix": -dosaf 1 -gl 1 2> \$log/"$prefix"_sfs_pop2.log
\$ANGSD/angsd -b \$pop3 -anc \$ref -remove_bads 1 -uniqueOnly 1 -minMapQ 20 -minQ 20 -only_proper_pairs 1 -trim 0 -minInd \$minInd -P 2 -out \$pbs/"$prefix"_pop3.pbs -r "$prefix": -dosaf 1 -gl 1 2> \$log/"$prefix"_sfs_pop3.log
\$ANGSD/angsd -b \$pop4 -anc \$ref -remove_bads 1 -uniqueOnly 1 -minMapQ 20 -minQ 20 -only_proper_pairs 1 -trim 0 -minInd \$minInd -P 2 -out \$pbs/"$prefix"_pop4.pbs -r "$prefix": -dosaf 1 -gl 1 2> \$log/"$prefix"_sfs_pop4.log

## obtain ml for different sets of MIGRATORY populations
\$ANGSD/misc/realSFS \$pbs/"$prefix"_pop1.pbs.saf.idx \$pbs/"$prefix"_pop2.pbs.saf.idx -P 2 > \$pbs/"$prefix"_pop12.ml 2> \$log/"$prefix".pop12.ml.out
\$ANGSD/misc/realSFS \$pbs/"$prefix"_pop1.pbs.saf.idx \$pbs/"$prefix"_pop3.pbs.saf.idx -P 2 > \$pbs/"$prefix"_pop13.ml 2> \$log/"$prefix".pop13.ml.out
\$ANGSD/misc/realSFS \$pbs/"$prefix"_pop2.pbs.saf.idx \$pbs/"$prefix"_pop3.pbs.saf.idx -P 2 > \$pbs/"$prefix"_pop23.ml 2> \$log/"$prefix".pop23.ml.out

## obtain ml for ANCESTOR vs. migratory populations
\$ANGSD/misc/realSFS \$pbs/"$prefix"_pop4.pbs.saf.idx \$pbs/"$prefix"_pop1.pbs.saf.idx -P 2 > \$pbs/"$prefix"_pop41.ml 2> \$log/"$prefix".pop41.ml.out
\$ANGSD/misc/realSFS \$pbs/"$prefix"_pop4.pbs.saf.idx \$pbs/"$prefix"_pop2.pbs.saf.idx -P 2 > \$pbs/"$prefix"_pop42.ml 2> \$log/"$prefix".pop42.ml.out
\$ANGSD/misc/realSFS \$pbs/"$prefix"_pop4.pbs.saf.idx \$pbs/"$prefix"_pop3.pbs.saf.idx -P 2 > \$pbs/"$prefix"_pop43.ml 2> \$log/"$prefix".pop43.ml.out
\$ANGSD/misc/realSFS \$pbs/"$prefix"_pop1.pbs.saf.idx \$pbs/"$prefix"_pop3.pbs.saf.idx -P 2 > \$pbs/"$prefix"_pop13.ml 2> \$log/"$prefix".pop13.ml.out

## estimate pbs (if you give it three populations it will give you pbs instead of fst)
\$ANGSD/misc/realSFS fst index \$pbs/"$prefix"_pop1.pbs.saf.idx \$pbs/"$prefix"_pop2.pbs.saf.idx \$pbs/"$prefix"_pop3.pbs.saf.idx -sfs \$pbs/"$prefix"_pop12.ml -sfs \$pbs/"$prefix"_pop13.ml -sfs \$pbs/"$prefix"_pop23.ml -fstout \$pbs/"$prefix"_pop123 2> \$log/"$prefix"_index_pop123.log
\$ANGSD/misc/realSFS fst index \$pbs/"$prefix"_pop4.pbs.saf.idx \$pbs/"$prefix"_pop1.pbs.saf.idx -sfs \$pbs/"$prefix"_pop41.ml -fstout \$pbs/"$prefix"_pop41 2> \$log/"$prefix"_index_pop41.log
\$ANGSD/misc/realSFS fst index \$pbs/"$prefix"_pop4.pbs.saf.idx \$pbs/"$prefix"_pop2.pbs.saf.idx -sfs \$pbs/"$prefix"_pop42.ml -fstout \$pbs/"$prefix"_pop42 2> \$log/"$prefix"_index_pop42.log
\$ANGSD/misc/realSFS fst index \$pbs/"$prefix"_pop4.pbs.saf.idx \$pbs/"$prefix"_pop3.pbs.saf.idx -sfs \$pbs/"$prefix"_pop43.ml -fstout \$pbs/"$prefix"_pop43 2> \$log/"$prefix"_index_pop43.log
#\$ANGSD/misc/realSFS fst index \$pbs/"$prefix"_pop1.pbs.saf.idx \$pbs/"$prefix"_pop3.pbs.saf.idx -sfs \$pbs/"$prefix"_pop13.ml -fstout \$pbs/"$prefix"_pop13 2> \$log/"$prefix"_index_pop13.log

## summarize by window
\$ANGSD/misc/realSFS fst stats2 \$pbs/"$prefix"_pop123.fst.idx -win 5000 -step 5000 -type 2 > \$pbs/"$prefix"_pop123_5000.txt 2> \$log/"$prefix"_stats2_5000_pop123.log
\$ANGSD/misc/realSFS fst stats2 \$pbs/"$prefix"_pop41.fst.idx -win 5000 -step 5000 -type 2 > \$pbs/"$prefix"_pop41_5000.txt 2> \$log/"$prefix"_stats2_5000_pop41.log
\$ANGSD/misc/realSFS fst stats2 \$pbs/"$prefix"_pop42.fst.idx -win 5000 -step 5000 -type 2 > \$pbs/"$prefix"_pop42_5000.txt 2> \$log/"$prefix"_stats2_5000_pop42.log
\$ANGSD/misc/realSFS fst stats2 \$pbs/"$prefix"_pop43.fst.idx -win 5000 -step 5000 -type 2 > \$pbs/"$prefix"_pop43_5000.txt 2> \$log/"$prefix"_stats2_5000_pop43.log
#\$ANGSD/misc/realSFS fst stats2 \$pbs/"$prefix"_pop13.fst.idx -win 5000 -step 5000 -type 2 > \$pbs/"$prefix"_pop13_5000.txt 2> \$log/"$prefix"_stats2_5000_pop13.log

\$ANGSD/misc/realSFS fst stats2 \$pbs/"$prefix"_pop123.fst.idx -win 2500 -step 500 -type 2 > \$pbs/"$prefix"_pop123_2500.txt 2> \$log/"$prefix"_stats2_2500_pop123.log
\$ANGSD/misc/realSFS fst stats2 \$pbs/"$prefix"_pop41.fst.idx -win 2500 -step 500 -type 2 > \$pbs/"$prefix"_pop41_2500.txt 2> \$log/"$prefix"_stats2_2500_pop41.log
\$ANGSD/misc/realSFS fst stats2 \$pbs/"$prefix"_pop42.fst.idx -win 2500 -step 500 -type 2 > \$pbs/"$prefix"_pop42_2500.txt 2> \$log/"$prefix"_stats2_2500_pop42.log
\$ANGSD/misc/realSFS fst stats2 \$pbs/"$prefix"_pop43.fst.idx -win 2500 -step 500 -type 2 > \$pbs/"$prefix"_pop43_2500.txt 2> \$log/"$prefix"_stats2_2500_pop43.log
#\$ANGSD/misc/realSFS fst stats2 \$pbs/"$prefix"_pop13.fst.idx -win 2500 -step 500 -type 2 > \$pbs/"$prefix"_pop13_2500.txt 2> \$log/"$prefix"_stats2_2500_pop13.log

echo \"Program finished with exit code \$? at: \`date\`\" >> \$JOBINFO" > $pbs/$prefix.pbs

qsub -c s $pbs/$prefix.pbs

done < $list
