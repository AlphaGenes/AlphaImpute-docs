\newpage

#	AlphaImpute introduction

This section describes shortly what AlphaImpute does and how it works.

The theoretical framework for AlphaImpute and its implemented algorithms can be found in Hickey et al. [-@hickey_phasing_2012; -@hickey_combined_2011] and Antolín et al. [-@antolin_hybrid_2017].

\etocsetnexttocdepth{2}
\localtableofcontents

## What AlphaImpute does: Imputing genotypes

AlphaImpute’s primary goal is to impute genotypes. 
This is needed when a range of animals or humans have been genotyped using different single nucleotide polymorphism (SNP) genotyping panels; expensive SNP panels can genotype many SNPs (‘high-density’\index{high-density}) while the cheaper SNP panels genotypes fewer SNPs (‘low-density’\index{low-density}). 
*Imputing genotypes*\index{imputing genotypes} fills in the missing SNPs on the low-density SNP panels, based on the genotypes on the high-density SNP panels.

AlphaImpute employs several algorithms to achieve this. 
A notable by-product is the *phased genotypes*\index{phased genotypes|see {phases}}, or *phases*\index{phases}. 
The phases is the sequence of alleles that were inherited together in the parental gametes that fused to produce the animal. In comparison, the genotypes is the sequence of homozygote/heterozygote SNPs.

## How AlphaImpute works

AlphaImpute both *phases* and *imputes* alleles, which are then combined to impute missing genotypes. 
To do so, AlphaImpute first identifies all individuals that were genotyped at a large proportion of the SNP positions. 
These comprises the *high-density genotyped*\index{high-density genotyped} animals. 
These individuals are *phased* to derive the haplotypes that are carried by these individuals that could be inherited or be passed on to offspring. 
The phasing process is referred to *long-range phasing*\index{long-range phasing}, and results with the *haplotype library construction*\index{haplotype library construction}. 
This is performed on *cores*\index{cores}, continuous subsets of the chromosome. 
By having multiple lengths of cores, the subsets overlap allowing both close and distant inheritances to be identified. 

With the haplotype library, missing alleles are imputed by matching the alleles of the known alleles surrounding the missing alleles with the corresponding alleles of the haplotypes in the haplotype library. 
By using basic rules of Mendelian inheritance and segregation analysis, plausible haplotypes are found and used to impute the missing alleles. 

For a given allele position, multiple cores have been used to identify haplotypes. Only haplotypes that could have been inherited from the parents are used, and where all haplotypes are in agreement, the missing allele is imputed. If this results in a new haplotype, the haplotype library is updated.

The imputation is iterated several times, so that alleles that could not be imputed might be imputed with a haplotype that was found in a subsequently imputed individual.

AlphaImpute finally outputs imputed phases and genotypes for all individuals.  For both outputs, alleles that are in agreement across all cores are outputted as integer values, or missing where no agreement was found. In addition, the average allele across all cores is outputted, as allele or genotype dosages, as numeric values between 0.0 and 1.0 for phases and between 0.0 and 2.0 for genotypes. 

### Summary

AlphaImpute works by:

  1. Dividing the animals into two groups, either *high-density genotyped* or *low-density genotyped*.
  1. *Phasing* the genotypes of the high-density genotyped animals.
  1. *Haplotype library construction*, and
  1. Iteratively using haplotypes to *impute missing genotypes*.

  
