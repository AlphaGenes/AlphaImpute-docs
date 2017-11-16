\clearpage

# Example 1: AlphaImpute tutorial

This chapter will guide you through using AlphaImpute and reading output.

To re-iterate from the introduction, 
AlphaImpute both *phases* and *imputes* alleles, which are then combined to impute missing genotypes. 
This occures in two steps: 
  1. *Long-range phasing*\index{long-range phasing} and *haplotype library construction*\index{haplotype library construction} of animals genotyped with high-denisty SNP panels.\index{Step 1}
  1. *Imputation* of missing genotypes by matching haplotypes.\index{Step 2}

This might be important.


Files for this example is available in the zip file containing the file `AlphaImpute`, in the folder `examples/01`.
  
\etocsetnexttocdepth{2}
\localtableofcontents

## Before you begin

Unzip the zip file containing the AlphaImpute executable. There should be a sub-directory names `examples`.
For this example, we will be using `examples/01`.

**Note for Windows users:** Any forward slash (`/`) used in filename and directory paths should be replaced with
Windows' filepath separator, backslash (`\`).

Copy the AlphaImpute executable into the `example/01` directory^[Optional, but if not, prepend any call to AlphaImpute with `../../`.].

The spec file is named `AlphaImputeSpec.txt`; AlphaImpute will expect this filename if not given any other.
The file's contents should be

```
= BOX 1: Input Files ==========================================================
PedigreeFile                ,Pedigree.txt
GenotypeFile                ,Genotypes.txt
= BOX 4: Phasing ================================================================
NumberPhasingRuns           ,4
CoreAndTailLengths          ,300,350,400,450
CoreLengths                 ,250,300,350,400
= BOX 5: Imputation =========================================================
InternalIterations          ,1
```

We have specified a single round in `InternalIterations` to speed up the process for the example.
For proper research, use more rounds.

## Run AlphaImpute with the simple command

`./AlphaImpute` (Linux, Mac OSX) 

or 

`AlphaImpute.exe` (Windows). 

## AlphaImpute's output to stdout

You should expect to see the following output.

------

``` 
                               ***********************                         
                               *                     *                         
                               *     AlphaImpute     *                         
                               *                     *                         
                               ***********************                         
                                                                               
                     Software For Phasing and Imputing Genotypes               
 
                               Commit:   v1.9.8                     
                               Compiled: Nov 16 2017, 10:46:24
 
 
 
 
 is not valid for the AlphaImpute Spec File.
 
 NOTE: Number of Genotyped animals:         1100
             0  errors in the pedigree due to Mendelian inconsistencies
             0  snps changed across individuals
  
  
          1000  indiviudals passed to AlphaPhase
          1500  snp remain after editing
  
  Data editing completed
  
  Running AlphaPhase
  Finished Running AlphaPhase
 Phasing Completed
  
  Imputation of base animals completed
  
 Performing imputation loop           1
  
  Parent of origin assigmnent of high density haplotypes completed
  
  Imputation from high-density parents completed at: 151738.936
  
  Haplotype library imputation completed at: 151739.888
  
  Internal imputation from parents haplotype completed at: 
 151741.444                                                                     
                                                                        
  Internal imputation from own haplotype completed at: 
 151747.172                                                                     
                                                                        
  
  Internal haplotype library imputation completed at: 
 151747.608                                                                     
                                                                        
  
  Imputation by detection of recombination events completed
 
 
 
 Genotype Yield  0.9978533    
 
 
 
                               ***********************                         
                               *                     *                         
                               *     AlphaImpute     *                         
                               *                     *                         
                               ***********************                         
                                                                               
                     Software For Phasing and Imputing Genotypes               
 
                                   No Liability
 
                 Analysis Finished                         

Time Elapsed  Hours  0  Minutes  5  Seconds 57.75
```

------

### Output for step 1

For step 1 we see the following output (numbers to the right are inserted for this example):

```
 NOTE: Number of Genotyped animals:         1100                         (1)
             0  errors in the pedigree due to Mendelian inconsistencies  (2)
             0  snps changed across individuals                                     
  
  
          1000  indiviudals passed to AlphaPhase                         (3)
          1500  snp remain after editing                                 (4)
  
  Data editing completed
  
  Running AlphaPhase                                                     (5)
  Finished Running AlphaPhase
 Phasing Completed
```

It provides us some usefull information:

1. Number of rows read by AlphaImpute in the genotype file.
2. AlphaImpute will check that parents and offspring have 'compatible' genotypes. 
   I.e\. if both parents are homozogous at a SNP position, the offspring should also be.
   If any inconsistencies were found, the SNP is masked as missing, and reported in
   `Miscellaneous/snpMistakes.txt`\index{Files!snpMistakes.txt} and 
   `Miscellaneous/PedigreeMistakes.txt`\index{Files!PedigreeMistakes.txt}.
3. Number of animals that are genotyped above `HDAnimalsThreshold` and thus usable for long-range phasing and haplotype library construction.
   Adjust the setting `HDAnimalsThreshold` if the reported number is too low.
4. Result of using `InternalEdit` and `EditingParameters`.
5. Signals AlphaImput has completed reading the data and is ready to perform 
   long-range phasing and haplotype library construction^[This was formerly performed by an external executable.].
   AlphaImpute can be stopped at this point by specifying `PreprocessDataOnly ,Yes`
   in order to fine-tune the settings of box 1-4.
   

### Output for step 2

```
  Imputation of base animals completed
  
 Performing imputation loop           1
  
  Parent of origin assigmnent of high density haplotypes completed
  
  Imputation from high-density parents completed at: 151738.936
  
  Haplotype library imputation completed at: 151739.888
  
  Internal imputation from parents haplotype completed at: 
 151741.444                                                                     
                                                                        
  Internal imputation from own haplotype completed at: 
 151747.172                                                                     
                                                                        
  
  Internal haplotype library imputation completed at: 
 151747.608                                                                     
```

Imputation.

This will loop a number of times as specified by `InternalIterations`.
The odd-looking numbers given at the end of each line is a timestamp in the
form `HHMMSS.ms`.

-----

```
  
  Imputation by detection of recombination events completed
  
```

When using `ModelRecomb ,Yes` (default), recombination events are modelled after the *last*
imputation loop, and this message is printed.
Alleles that are affected by recombination events are masked as missing. 
This correction can increase imputation accuracy, but at the expense of yield.

The updated imputation is written to `Results/ModelRecomb.txt` with recombination information
written to `Results/Recombination*.txt`

-----

```
 Genotype Yield  0.9978533  
```

This is the proportion of non-missing genotypes after imputation.
Can be used as a benchmark, but it is calculated across *all* animals, including high-density genotyped animals.

------

After the imputation, a boilerplate similar to the one we say in the beginning is outputted.
After that,
```
   Time Elapsed  Hours  0  Minutes  5  Seconds 57.75
```
is written. This line is also written to `Miscellaneous/Timer.txt` \index{Files!Timer.txt}.
If AlphaImpute ended succesfully, this file will be present and updated.


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

Note: Despite some files are named ‘Probabilities’^[The name 'probabilities' has been retained for legacy.], they contain the allele dosages\index{genotype dosages}\index{allele dosages|see {genotype dosages}}. 
These are averages of the imputed allele across all cores. They cannae be regarded as probabilities, as they do not necessarily sum to 1.

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

The 4 files highlighted here are 
`ImputePhase.txt`, `ImputePhaseProbabilities.txt`, `ImputeGenotypeProbabilities.txt`, and `ImputeGenotypes.txt`. 
Their format is in common with the genotype input format, i.e\. first column is ID for individual, 
followed by a column for each SNP position. 
`ImputePhase*.txt` files have two rows per individual, first (second) row comprising imputed sequence of alleles inherited on the paternal (maternal) gamete. 

Files `ImputePhaseProbabilities.txt` and `ImputeGenotypeProbabilities.txt` contain allele and genotype dosages. 
These are the average allele for each SNP position across all cores. 
These are never missing as the worst imputed value approximates the allele frequency among the known genotypes. 

Files `ImputePhase.txt` and `ImputeGenotypes.txt` contain 'called' alleles and genotypes, 
where the imputed allele was in agreement across all cores. 
If no agreement was found, `9` is used as a missing value.

## Summary
With just three files and the AlphaImpute executable, we have demonstrated how to impute missing genotypes, 
and how to read the outputted data. 

Use of other settings where not demonstrated here, but allows greater control over 
e.g.\ which individuals are considered high-density genotyped, 
imputing between multiple high-density and low-density genotype panels, or reusing previous phasing when these have been computation expensive.
