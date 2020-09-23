\chapter*{}

## Foreword

AlphaImpute is a software package for imputing and phasing genotype data in diploid populations with pedigree information. 
To impute an individual's genotype, the program infers possible haplotypes of the parental gametes that were inherited by the individual. 
This requires phase information, and when not present, the program generates this information by running AlphaPhase. 
AlphaImpute operates on overlapping chromosome segments, here referred to as cores, to account for recombination events. 

Please report bugs or suggestions on how the program / user interface / manual could be improved or made more user friendly to John.Hickey@roslin.ed.ac.uk.


## Historical background

AlphaImpute [@hickey_phasing_2012] was developed as the next step after AlphaPhase [@hickey_combined_2011]. 
While AlphaPhase inferred the underlying haplotypes that could be passed inherited, AlphaPhase would utilize this information to impute missing genotypes based on Mendelian inheritance.

Prior to version v. 1.9, AlphaImpute relied on several algorithms; noticeably 'GeneProb' [@kerr_efficient_1996] and 'AlphaPhase' [@hickey_combined_2011]. 
These were implemented as separately executables that AlphaImpute, but are now fully embedded within AlphaImpute for improved performance and efficiency. 

The GeneProb algorithm performed segregation analysis by calculating the probability of an ungenotyped individual belonging to each genotype class. 
This was performed for each SNP position independently by traversing up and down the pedigree. 
The use of the GeneProb algorithm is now deprecated in favor of a more efficient algorithm.

The AlphaPhase\index{AlphaPhase|textbf} algorithm [@hickey_combined_2011] is responsible for inferring the paternal and maternal gametes that each individual inherited; 
a process called *long-range phasing*\index{long-range phasing} [@kong_detection_2008]. 
This is performed on consecutive SNPs throughout multiple, overlapping chromosomal regions. 
AlphaPhase furthermore performs *haplotype library imputation* to resolve phases where family structure is lacking. 
AlphaPhase is now fully embedded within AlphaImpute, but available as a separate binary from the website.

AlphaImpute builds upon the haplotype library constructed by the AlphaPhase algorithm to impute missing genotypes. 
This allows for imputation of completely ungenotyped animals and low-density genotyped animals by iteratively matching the inferred haplotypes to the imputed animals' alleles and updating the haplotype library with new haplotypes.

The newest development introduces a hidden Markov Model (HMM) [@antolin_hybrid_2017] that that performs well in unrelated animals or when pedigree is unreliable. 
The HMM is based on MaCH [@li_mach:_2010], and can be used either alone or in conjunction with AlphaImpute’s standard long-range phasing and heuristic imputation.

## Availability

AlphaImpute is available as an executable file from the AlphaGenes website: <http://www.alphagenes.roslin.ed.ac.uk>.
Binaries are compiled for Linux (64 bit), Mac OaSX (64 bit), and Windows (64 bit).



## System requirements

The amount of RAM the program requires depends on the dataset. It tends to scale linearly with the number of animals in the supplied pedigree.

#### OS X

The program will function on any 64-bit intel based mac, with OS 10.8 or later (older versions might work). 


#### Linux

The program was tested working on linux kernel 3.14 and in theory should support any system with SSE3 instructions.



#### Windows

The program will run on Windows 7 or later, if the PC has a 64-bit processor with SSE3 instructions.
The executable depends on a list of .dll and .pdb files, which are available in the zip-file. 
If you move the executable to a different location, ensure that the .dll and .pdb are also found in the `PATH` environment variable.


## Conditions of use

AlphaImpute is part of a suite of software that our group has developed. It is fully and freely available for all use under the MIT License.

<!-- Please update the citations here to follow the layout produced by pandoc / latex -->
Citations:

*	Antolin, R., Nettelblad, C., Gorjanc, G., Money, D. & Hickey, J.M., (2017) A hybrid method for the imputation of genomic data in livestock populations', *Genetics Selection Evolution* 49. doi:10.1186/s12711-017-0300-y
*	Hickey, J.M., Kinghorn, B.P., Tier, B., van der Werf, J.H. & Cleveland, M.A. (2012) A phasing and imputation method for pedigreed populations that results in a single-stage genomic evaluation. *Genetics Selection Evolution* 44, 11. doi:10.1186/1297-9686-44-9

See appendix for bibtex format, together with full list of relevant citations for AlphaImpute.

## Disclaimer

While every effort has been made to ensure that AlphaImpute does what it claims to do, there is absolutely no guarantee that the results provided are correct. Use of AlphaImpute is entirely at your own risk!

## Advertisement

You are welcome to check out our Gibbs sampler "AlphaBayes", specifically designed for GWAS and genomic selection: http://www.alphagenes.roslin.ed.ac.uk/alphasuite-softwares/alphabayes/

For simulating breeding programs, complete with genomic selection, SNP panels, recombination, and more, see "AlphaSim": http://www.alphagenes.roslin.ed.ac.uk/alphasuite-softwares/alphasim/

\etocsetnexttocdepth{0}
\tableofcontents
