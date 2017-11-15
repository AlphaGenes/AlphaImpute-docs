\chapter*{}

## Foreword

AlphaImpute\index{AlphaImpute} is a software package for imputing and phasing genotype data in diploid populations with pedigree information. 
To impute an individual’s genotype, the program infers possible haplotypes of the parental gametes that were inherited by the individual. 
This requires phase information, and when not present, the program this information. 
AlphaImpute operates on overlapping chromosome segments, here referred to as cores, to account for recombination events. 

Please report bugs or suggestions on how the program / user interface / manual could be improved or made more user friendly to John.Hickey@roslin.ed.ac.uk or Roberto.Antolin@roslin.ed.ac.uk.


## Historical background

AlphaImpute [@hickey_phasing_2012] was developed as the next step after AlphaPhase [@hickey_combined_2011]. 
While AlphaPhase\index{AlphaPhase} inferred the underlying haplotypes that could be passed inherited, AlphaPhase would utilize this information to impute missing genotypes based on Mendelian inheritance.
Prior to version v. 1.9, AlphaImpute relied on several algorithms; noticeably ‘GeneProb’ [@kerr_efficient_1996] and AlphaPhase [@hickey_combined_2011]. These were implemented as separately executables that AlphaImpute, but are now fully embedded within AlphaImpute for improved performance and efficiency. 
The GeneProb algorithm (Kerr and Kinghorn, 1996) performed segregation analysis by calculating the probability of an ungenotyped individual belonging to each genotype class. This was performed for each SNP position independently by traversing up and down the pedigree. The use of the GeneProb algorithm is now deprecated in favor of a more efficient algorithm.
The AlphaPhase algorithm (Hickey et al., 2011) is responsible for inferring the paternal and maternal gametes that each individual inherited; a process called ‘long-range phasing’ (Kong et al., 2008). This is performed on consecutive SNPs throughout multiple, overlapping chromosomal regions. AlphaPhase furthermore performs ‘haplotype library imputation’ to resolve phases where family structure is lacking. AlphaPhase is now fully embedded within AlphaImpute, but available as a separate binary from the website.
AlphaImpute builds upon the haplotype library constructed by the AlphaPhase algorithm to impute missing genotypes. This allows for imputation of completely ungenotyped animals and low-density genotyped animals, by iteratively matching the inferred haplotypes to the imputed animals’ alleles and updating the haplotype library with new haplotypes.
The newest development introduces a hidden Markov Model (HMM) (Antolín et al., 2017) that performa

## Availability

AlphaImpute is available from the AlphaGenes website: http://www.alphagenes.roslin.ed.ac.uk
Binaries are compiled for Linux (64 bit), Mac OaSX (64 bit), and Windows (64 bit).

## System requirements
???

## Conditions of use
AlphaImpute is available to the scientific community free of charge, but conditional on crediting its use in any publication with the citations listed below. Commercial users should contact John Hickey.

Citations:
•	Antolín, R., Nettelblad, C., Gorjanc, G., Money, D., Hickey, J.M., 2017. A hybrid method for the imputation of genomic data in livestock populations. Genetics Selection Evolution 49. doi:10.1186/s12711-017-0300-y
•	Hickey, J.M., Kinghorn, B.P., Tier, B., van der Werf, J.H., Cleveland, M.A., 2012. A phasing and imputation method for pedigreed populations that results in a single-stage genomic evaluation. Genetics Selection Evolution 44, 11. doi:10.1186/1297-9686-44-9

See appendix for bibtex format, together with full list of relevant citations for AlphaImpute.

## Disclaimer

While every effort has been made to ensure that AlphaImpute does what it claims to do, there is absolutely no guarantee that the results provided are correct. Use of AlphaImpute is entirely at your own risk!

## Advertisement

You are welcome to check out our Gibbs sampler “AlphaBayes”, specifically designed for GWAS and genomic selection: http://www.alphagenes.roslin.ed.ac.uk/alphasuite-softwares/alphabayes/

For simulating breeding programs, complete with genomic selection, SNP panels, recombination, and more, see “AlphaSim”: http://www.alphagenes.roslin.ed.ac.uk/alphasuite-softwares/alphasim/


\tableofcontents
