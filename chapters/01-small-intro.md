#	AlphaImpute introduction

This section describes shortly what AlphaImpute does, how it works, and how to use it.
It is intended as a quick introduction to getting started for imputing genotypes with AlphaImpute.

A full reference with examples is available in the full manual.

The theoretical framework for AlphaImpute and its implemented algorithms can be found in Hickey et al. [-@hickey_phasing_2012; -@hickey_combined_2011] and Antolin et al. [-@antolin_hybrid_2017].

\etocsetnexttocdepth{1}
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
This occures in two steps: 
  1. *Long-range phasing*\index{long-range phasing} and *haplotype library construction*\index{haplotype library construction} of animals genotyped with high-denisty SNP panels.\index{Step 1}
  1. *Imputation* of missing genotypes by matching haplotypes.\index{Step 2}

To do so, AlphaImpute first identifies all individuals that were genotyped at a large proportion of the SNP positions. 
These comprises the *high-density genotyped*\index{high-density} animals. 
These individuals are *phased* to derive the haplotypes that are carried by these individuals that could be inherited or be passed on to offspring. 
The phasing process is referred to *long-range phasing*\index{long-range phasing}, and results with the *haplotype library construction*\index{haplotype library construction}. 
This is performed on *cores*\index{cores}, continuous subsets of the chromosome. 
By having multiple lengths of cores, the subsets overlap allowing both close and distant inheritances to be identified. 

With the haplotype library, missing alleles are imputed by matching the alleles of the known alleles surrounding the missing alleles with the corresponding alleles of the haplotypes in the haplotype library. 
By using basic rules of Mendelian inheritance and segregation analysis, plausible haplotypes are found and used to impute the missing alleles. 

For a given allele position, multiple cores have been used to identify haplotypes. Only haplotypes that could have been inherited from the parents are used, and where all haplotypes are in agreement, the missing allele is imputed. If this results in a new haplotype, the haplotype library is updated.

The imputation is iterated several times, so that alleles that could not be imputed might be imputed with a haplotype that was found in a subsequently imputed individual.

AlphaImpute finally outputs imputed phases and genotypes for all individuals.  
For both outputs, alleles that are in agreement across all cores are outputted as integer values, or missing where no agreement was found. 
In addition, the average allele across all cores is outputted, as *allele*\index{allele dosages} or *genotype dosages*\index{genotype dosages}, as numeric values between 0.0 and 1.0 for phases and between 0.0 and 2.0 for genotypes. 

### Summary

AlphaImpute works by:

  1. Dividing the animals into two groups, either *high-density genotyped* or *low-density genotyped*.
  1. *Phasing* the genotypes of the high-density genotyped animals.
  1. *Haplotype library construction*, and
  1. Iteratively using haplotypes to *impute missing genotypes*.

Step 1 corresponds to the first three items, step 2 to the last.
  
## How to use AlphaImpute

AlphaImpute is available as an executable file from the AlphaGenes website: <http://www.alphagenes.roslin.ed.ac.uk>.
Its standard mode of operation is described here. 
Alternative uses, including re-using previous phasing information, is available in the full manual.

AlphaImpute requires at least 3 input files: 
A file specifying settings ('spec file'), a genotype file, and a pedigree file^[Pedigree free phasing and imputation is possible with AlphaImpute; see setting `PedigreePhasing` and the Hidden Markov model.]. 
For the genotype and pedigree files, AlphaImpute accepts either simple text formats or the PLINK 1.9 formatted files [@purcell_plink:_2007,@chang_second-generation_2015].

The spec file is text based and discussed in the following section.

AlphaImpute accepts integer or alphanumeric IDs for identifying animals^[The family ID in PLINK 1.9 formatted files is ignored by AlphaImpute.].

The *pedigree file* \index{Pedigree} must consist of 3 columns, space or comma separated: ID for the Individual, ID for the sire, and ID for the dam. The pedigree does not have to be sorted, as this is done during preprocessing. Missing parents should be coded as 0. 

The *genotype file* \index{Genotypes} is formatted with one row per individual, and is space or comma separated. Multiple spaces or tabs are ignored. 
The first column of the genotype file contains the ID for the genotyped individuals, followed by columns for each SNP. 
SNPs are encoded `0`, `1`, or `2` for homozygote, heterozygote, and homozygote, respectively. Missing genotypes are coded with any value between 3 and 9. 
For PLINK 1.9 formatted files, we refer to the full manual.

Neither pedigree or genotype file may contain headers. The pedigree file may record additional individuals that are not genotyped. 

### Settings in the spec file

The settings for AlphaImpute are specified in `AlphaImputeSpec.txt`^[The AlphaImpute executable accepts a single command line argument, the filename of the spec file. Without a command line argument, AlphaImpute expects the spec file to be named `AlphaImputeSpec.txt` and located in the current directory.].
An example of the spec file is given in the section ['Spec file example'](#spec-file-example).
Most options have default values and do not require specifying^[AlphaImpute will create the file `AlphaImputeSpecFileUsed.txt` with the values it has used.].
Only a few lines are required to specify the input files, number of SNPs, settings for phasing, parallelization, and threshold for distinguishing high-density vs. low-density individuals, although good default values for these exists.
Examples of the file is available in the zip file with the executable.

The spec file is a text file comprising two comma separated columns. Lines starting with `=` are ignored. 
The name of the setting is left of the comma and is case insensitive. The value to the right of the comma, is case insensitive, with the *exception of filenames*.

The settings in the spec file are for clarity split into 8 boxes, corresponding to different topics.

## Running AlphaImpute

AlphaImpute is run from the command line with the simple command:

`./AlphaImpute` (Linux, Mac OSX) 

or 

`AlphaImpute.exe` (Windows). 

Consult the specifics of your operating system for how to call executables from other locations.

**Warning:** 
AlphaImpute will delete the following directories before attempting to create them! 
It is your own responsibility to ensure these folders are backed up safely:
`GeneProb`, `InputFiles`, `IterateGeneProb`, `Miscellaneous`, `Phasing`, `Results`

The listed directories are created by AlphaImpute to contain recoded data, 
intermediate data, and various output such as quality of phasing and imputation 
that can be used to gain insight into the data and the imputation.

## Imputed genotypes are found in the `Results` directory

The directory 'Results'\index{Files!Results} contains the main final imputed genotypes and phases.
The main files of interest are:

* `ImputeGenotypes.txt`\index{Files!ImputeGenotypes.txt}
* `ImputeGenotypeProbabilities.txt`\index{Files!ImputeGenotypeProbabilities.txt}
* `ImputePhase.txt`\index{Files!ImputePhase.txt}
* `ImputePhaseProbabilities.txt`\index{Files!ImputePhaseProbabilities.txt}

Filenames without `Probabilities` are 'called' genotypes and alleles.
When an allele or genotype for an animal is imputed in unison across all cores,
it is called, otherwise output as missing with integer `9`.

Filenames with `Probabilities`^[The name 'probabilities' has been retained for legacy.] are *genotype dosages*\index{genotype dosages} and *allele dosages*.
These contain the average of the imputed genotype or allele across all cores.

The difference between the files are shown in the example below, and a summary given in Table @tbl:imputed_files_summary.

**Example:** Phase vs. genotypes, and dosages vs. called.
```
ImputePhaseProbabilities.txt            ImputePhase.txt
1067 0.00 0.00 1.00 0.00 0.00 0.00      1067 0 0 1 0 0 0 
1067 0.00 0.00 1.00 0.50 0.50 0.50      1067 0 0 1 9 9 9 
1068 0.00 0.00 1.00 0.00 0.00 0.00      1068 0 0 1 0 0 0 
1068 0.00 0.00 1.00 0.00 0.00 0.00      1068 0 0 1 0 0 0 
1069 0.00 0.00 1.00 0.00 0.00 0.00      1069 0 0 1 0 0 0 
1069 0.00 0.00 1.00 0.00 0.00 0.00	    1069 0 0 1 0 0 0 

ImputeGenotypeProbabilities.txt         ImputeGenotypes.txt
1067 0.00 0.00 2.00 0.50 0.50 0.50      1067 0 0 2 9 9 9 
1068 0.00 0.00 2.00 0.00 0.00 0.00      1068 0 0 2 0 0 0 
1069 0.00 0.00 2.00 0.00 0.00 0.00 	    1069 0 0 2 0 0 0 
```

Table: Summary of primary output files. No. row is function of number of individuals (n). {#tbl:imputed_files_summary} 
  
  .      | No. rows  |  Allele / genotype dosages	| Called alleles / genotypes
---------|----|------------------------------|------------------------------------
  .      |    |   `Impute*Probabilities.txt` | `Impute*.txt`
  .      |    |------------------------------|------------------------------------         
Phase    | 2n | 0.0 – 1.0 | 0, 1, 9
Genotype | n  | 0.0 – 2.0 | 0, 1, 2, 9



## Spec file example

```
= BOX 1: Input Files ==========================================================
PedigreeFile                ,Pedigree.txt
GenotypeFile                ,Genotypes.txt
TrueGenotypeFile            ,TrueGenotypes.txt
SexChrom                    ,No
PlinkInputfile              ,
= BOX 2: SNPs ==================================================================
NumberSnp                   ,1500
MultipleHDPanels            ,0
NumberSnpxChip              ,0,0
= BOX 3: Filtering====== =======================================================
InternalEdit                ,No
EditingParameters           ,0.0,0.0,0.0,AllSnpOut
= BOX 4: Phasing ===============================================================
HDAnimalsThreshold          ,90.0
NumberPhasingRuns           ,4
CoreAndTailLengths          ,300,350,400,450
CoreLengths                 ,250,300,350,400
PedigreeFreePhasing         ,No
GenotypeError               ,0.0
LargeDatasets               ,No
UserDefinedAlphaPhaseAnimalsFile    ,None
PrePhasedFile               ,None
= BOX 5: Imputation =========================================================
InternalIterations          ,5
ConservativeHaplotypeLibraryUse     ,No
ModelRecomb                 ,Yes
= BOX 6: Hidden Markov Model ================================================
HMMOption                   ,No
TemplateHaplotypes          ,200
BurnInRounds                ,5
Rounds                      ,20
Seed                        ,-123456789
ThresholdForMissingAlleles  ,50.0
ThresholdImputed            ,90.0
= BOX 7: Running options ====================================================
ParallelProcessors          ,1
PreprocessDataOnly          ,No
RestartOption               ,0
= BOX 8: Output =============================================================
WellPhasedThreshold         ,99.0
ResultFolderPath            ,Results
```

