#!/bin/sh
## phase data with fastPHASE after converting angsd to plink, filtering, converting to vcf then to fastphase
## author: kira delmore
## date: mar 2017

list="$1"
sbatch="fastphase.sbatch"

while read prefix
do

echo "#!/bin/sh

#SBATCH --job-name=fastphase
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --time=164:00:00
#SBATCH --mem=2G
#SBATCH --error=job.%J."$prefix".fastphase.err.wallace
#SBATCH --output=job.%J."$prefix".fastphase.out.wallace
#SBATCH --mail-type=ALL
#SBATCH --mail-user=kira.delmore@gmail.com
#SBATCH --partition=global

~/tools/fastPHASE -u -o"$prefix" -C50 -H100 "$prefix"_geno

" > $sbatch/$prefix.sh

sbatch $sbatch/$prefix.sh

done < $list

