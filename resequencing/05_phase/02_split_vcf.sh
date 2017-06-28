while read prefix
do
vcftools --vcf ../plink_gl2/geno_mind_maf.vcf --chr "$prefix" --recode --recode-INFO-all --out "$prefix"
perl ~/tools/vcf-conversion-tools/vcf2fastPHASE.pl "$prefix".recode.vcf "$prefix"_geno "$prefix"_markers 108
done < ../scaffold
