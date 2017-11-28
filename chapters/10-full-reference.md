
# Full settings reference

This section describes the accepted file formats, settings and their acceptable values for the spec file, and the output files written by AlphaImpute.


\etocsetnexttocdepth{2}
\localtableofcontents

## Specification file, 'spec file'

The settings\index{settings|see {spec file}} for AlphaImpute are set with a single text file, referred to as a *spec file*\index{spec file}. 
By default, AlphaImpute expects the spec file to be named `AlphaImputeSpec.txt`, but other filenames can be provided as the first command line argument when calling AlphaImpute.

The spec file is a text file comprising two comma separated columns. 
Lines starting with `=` are ignored. The name of the setting is left of the comma and is case insensitive. 
The value to the right of the comma, is case insensitive *with the exception of filenames* (dependent on the operating system).

Placeholders are used in this manual to describe the accepted values of settings and are summarized in Table @tbl:arguments. 
These appear enclosed either in angular bracket (<, >) or parentheses. 
Any other text must be provided as-is. 
Arguments given with angular brackets denote type of value, e.g. integers (`<integer>`) or filenames (`<fn>`).
Strings given in parentheses are options and must be given as-is (e.g. `(Yes/No)`).

Table: Placeholder syntax used in manual. {#tbl:arguments}

**Placeholder	** |  **Expected value**
-----------------|----------------------------------------------------------------
`<fn>`           | A filename, absolute or relative to current working directory. Do not use quotation marks. **NB!** Filenames and paths are case sensitive in OSX and Linux!
`<integer>`      | An integer value.
`<real>`         | A real value (e.g. `0.8`).
`<RealPct>`      | A percentage, given without '%' (e.g. `95.0` for 95%)
`(Yes/No)`       | Literal strings, either Yes or No are accepted (case insensitive).
`(a,b,c)`        | One of three literal strings expected.



### Box 1: Input data \index{input data|textbf}

**Settings:**
`PedigreeFile`, `GenotypeFile`, `TrueGenotypeFile`, `SexChrom`, `PlinkInputfile`

AlphaImpute requires a single ID field to identify individuals. Both numeric and alphanumeric formatted IDs are accepted.

#### `PedigreeFile ,<fn>  ` \index{PedigreeFile|textbf}\index{Files!Pedigree}
\label{setting-PedigreeFile}

Default value: `Pedigree.txt`

The pedigree file requires three columns in the following order: the individual’s ID, the ID of the individual’s sire, and the ID of the individual’s dam. 
Missing IDs must be coded as 0.

Columns must be space or comma separated, and no header line may be included. Do not use quotes for filename.

The pedigree may include more individuals than provided in the input genotype file. 
These extra individuals will by default be imputed as well and written to output files, unless `OutputOnlyGenotypedAnimals` \settingref{OutputOnlyGenotypedAnimals} is explicitly set to `No`. 
The pedigree is not required to include all individuals provided in the input genotype file.

There is no need to sort the pedigree prior to using it in AlphaImpute. 
This is done internally, and the reordering is printed to file `Miscellaneous/InternalDataRecoding.txt`\index{Files!InternalDataRecoding.txt}.

#### `GenotypeFile ,<fn>`  \index{GenotypeFile|textbf}\index{Files!Genotype file}
\label{setting-GenotypeFile}

Default: `Genotypes.txt`

The genotype file must contain one line for each individual. 
First column corresponds to the individual’s ID. 
Following columns correspond to each SNP position for the individual. 
The number of SNP columns must correspond to the number given in `NumberSnp` \settingref{NumberSnp}, if the setting is specified.

SNPs must be encoded as integer values between 0 and 9. `0`, `1`, and `2` correspond, respectively to homozygous aa, heterozygous aA or Aa, and homozygous AA, respectively. 
Major and minor allele, A and a, are without reference to a reference genome, but must consistent throughout the input data file. Missing values are coded with values 3 – 9.

Columns must be space or comma separated, and no header line may be included. Do not use quotes for filename.

**Special cases:**

If the input data is a sex chromosome, see setting `SexChrom` \settingref{SexChrom}.

AlphaImpute by default assumes two SNP density panels; one high-density and one low-density. 
If multiple, not fully overlapping high-density panels are used, see setting `MultipleHdPanels` \settingref{MultipleHdPanels}.
See `PlinkInputfile` \settingref{PlinkInputfile} for using PLINK1.9 formatted files for pedigree and genotype input.

#### `TrueGenotypeFile ,<fn>` \index{TrueGenotypeFile|textbf}\index{Files!True genotype file}
\label{setting-TrueGenotypeFile}

Default: `None`

Filename of genotype file with true genotypes of all or subset of individuals. 
When present, AlphaImpute calculates imputation accuracies and outputs to standard output. 
Does not work when using PLINK 1.9 formatted input files.

#### `SexChrom ,No` \index{SexChrom|textbf}

Default variant. Input data is *not* assumed to be a sex chromosome.

#### `SexChrom ,Yes,<fn>,(Male/Female)` \index{SexChrom|textbf}\index{Imputing sex chromosomes}

\label{setting-SexChrom}

Input data is a sex chromosome. 

Requires an additional file (`<fn>`) listing which individuals are male or female as a two-column text file with ID in first column and sex (`1` = Male, `2` = Female) in second. 
When last argument is `Male`, males are assumed heterogametic, and females are assumed homogametic. 
When last argument is `Female` males are assumed homogametic, and females are assumed heterogametic.

#### `PlinkInputfile ,binary,<fn>` \index{PlinkInputfile!binary format|textbf}\index{Files!PLINK 1.9, binary}
\label{setting-PlinkInputfile}

Use PLINK 1.9 binary formatted input files [@purcell_plink:_2007,@chang_second-generation_2015]. When used, AlphaImpute will iterate over each chromosome.

AlphaImpute reads genotype data from `<fn>.bim` and `<fn>.bed`, and pedigree from `<fn>.ped`.

#### `PlinkInputfile ,text,<fn>` \index{PlinkInputfile!text format|textbf}\index{Files!PLINK 1.9, text}

Use PLINK 1.9 text formatted input files [@purcell_plink:_2007,@chang_second-generation_2015]. When used, AlphaImpute will iterate over each chromosome.

AlphaImpute reads genotype data from `<fn>.map` and pedigree from `<fn>.ped`.
*Do not* intermix ordinary input formats (`PedigreeFile` and `GenotypeFile`) with `PlinkInputfile`. 
If both sets of settings are found in the spec file, the last one listed in the spec file takes precedence.

**NB!** AlphaImpute does not output the PLINK 1.9 file format. 
**NB!** The family ID used in the PLINK  1.9 file format is ignored by AlphaImpute.

See <https://www.cog-genomics.org/plink/1.9/input> for more information on the PLINK1.9 formats.


### Box 2: SNPs

**Settings:**
`NumberSnp`, `MultipleHDPanels`, `NumberSnpxChip`

#### `NumberSnp ,<integer>` \index{NumberSnp|textbf}
\label{setting-NumberSnp}

Default value estimated from `GenotypeFile` \settingref{GenotypeFile}.

Number of SNPs in input files. If not given, number is automatically detected.

**Special case:** If several different high-density panels were used, refer to setting `MultipleHDPanels` \settingref{MultipleHdPanels}.

#### `MultipleHdPanels ,<integer>` \index{MultipleHdPanels|textbf}\index{Multiple high-density panels|see {MultipleHdPanels and NumberSnpxChip}}
\label{setting-MultipleHdPanels}

Default value: `0`

Sets number of different high-density SNP panels used for genotyping high-density genotyped animals. Requires setting `NumberSnpxChip` \settingref{NumberSnpxChip} when larger than 1.

#### `NumberSnpxChip ,<int>,<int>,...` \index{NumberSnpxChip|textbf}
\label{setting-NumberSnpxChip}

Specifies the number of SNPs on the 1st, 2nd, etc. high-density SNP panel. Required when `MultipleHdPanels` \settingref{MultipleHdPanels} is larger than 1.

### Box 3: Filtering
\index{Filtering, box 3}

**Settings:**
`InternalEdit`, `EditingParameters`

Removes SNPs that are missing in too many individuals, and removes individuals from high-density group with too many missing SNPs.

**Note:** Incompatible with `MultipleHdPanels ,Yes` \settingref{MultipleHdPanels}.


#### `InternalEdit ,(Yes/No)` \index{InternalEdit|textbf}
\label{setting-InternalEdit}

Default value: `No`

When `Yes`, enables filtering of SNPs and individuals in high-density group. When `Yes`, setting `EditingParameters` \settingref{EditingParameters} is required.


#### `EditingParameters ,<RealPct>,<RealPct>,<RealPct>,(AllSnpOut/EditedSnpOut)` \index{EditingParameters|textbf}
\label{setting-EditingParameters}

Default value: `90.0,0.0,0.0,AllSnpOut`

First argument is same as `HDAnimalsThreshold` \settingref{HDAnimalsThreshold} that sets the threshold of non-missing SNPs for including an individual in the high-density group.

Second argument sets threshold of missing SNPs among individuals in high-density group. SNPs missing above this threshold are excluded from further analysis.

Third argument sets threshold for non-missing SNPs for including an individuals, as first argument, but applied after removing missing SNPs.

Fourth argument causes AlphaImpute to output either all inputted SNPs (`AllSnpOut`) or only those that remained after editing SNPs (`EditedSnpOut`).


### Box 4: Phasing \index{Phasing, box 4}

**Settings:**
`HDAnimalsThreshold`, `NumberPhasingRuns`, `CoreAndTailLengths`, `CoreLengths`, `PedigreeFreePhasing`, 
`GenotypeError`, `LargeDatasets`, `PhasingOnly`, `UserDefinedAlphaPhaseAnimalsFile`, `PrePhasedFile`

These settings affect which animals are regarded as high-density genotyped, and how they are phased. These settings are used during long-range phasing and haplotype library construction (step 1).

#### `HDAnimalsThreshold ,<RealPct>` \index{HDAnimalsThreshold|textbf}
\label{setting-HDAnimalsThreshold}

Default value: `90.0` (i.e.\ 90%)

Animals whose proportion of genotyped SNPs are above this threshold are regarded as high-density genotyped SNPs.

**Note:** This setting is also set by first argument of `EditingParameters` \settingref{EditingParameters}. 
`HDAnimalsThreshold` may be overridden by later occurences of `EditingParameters` in the spec file. 

#### `NumberPhasingRuns ,<integer>` \index{NumberPhasingRuns\textbf}
\label{setting-NumberPhasingRuns}

Default value: `4`.

Standard setup for AlphaImpute to perform phasing. 
Accepts integers between 2 and 40. This must correspond to the number of cores given in `CoreAndTailLengths` and `CoreLengths` \settingref{CoreLengths}.

#### `NumberPhasingRuns ,PhaseDone,<fn>,<integer> ` \index{NumberPhasingRuns}

AlphaImpute re-uses phasing from a previous session and will not perform additional phasing. 

`<fn>` points to path ***(which output)***? 

`<integer>` is a whole integer between 2 and 40. This must correspond to the number of cores given in `CoreAndTailLengths` and `CoreLengths` \settingref{CoreLengths}. 
`NumberPhasingRuns` must not exceed that used during phasing. `CoreAndTailLengths` and `CoreLengths` must be the same as used during phasing.

#### `CoreAndTailLengths` and `CoreLengths` \index{CoreAndTailLengths|textbf}\index{CoreLength|textbf}\index{cores|textbf}
\label{setting-CoreLengths}

```
CoreAndTailLengths ,<integer>,<integer>,... 
CoreLengths        ,<integer>,<integer>,... 
```

Default values: Estimated from number of SNPs.

Specifies the sizes of cores used for phasing, haplotype library construction, and imputation. 
Each positional argument of the two settings comprises a pair, where the latter value cannot be greater than the former. The sizes used cannot exceed the number of SNPs in the input data.

Accepts between 2 and 40 integers that must correspond to `NumberPhasingRuns` \settingref{NumberPhasingRuns}.

The positioning of cores and their tails is displayed in Figure @fig:cores. 
The combined core and tails are used exclusively for inferring surrogate parents who passed on the haplotype. 
The cores are used for phasing, haplotype library construction, and imputation. In-depth description of the cores can be found in Hickey et al. [-@hickey_combined_2011].

![Core- and tail length (A) and position of adjacent cores of different sizes (B).](figures/cores.png){#fig:cores}

**Example:** Small chromosome, few cores
```
= BOX 3: SNPs ===============================================================
NumberSnp                   ,1500
= BOX 5: Phasing ============================================================
NumberPhasingRuns           ,4
CoreAndTailLengths          ,300,350,400,450
CoreLengths                 ,250,300,350,400
```
There is no requirement to have only few cores on a small chromosome.

**Example:** Large chromosome, many cores
```
= BOX 3: SNPs ===============================================================
NumberSnp                   ,15000
= BOX 5: Phasing ============================================================
NumberPhasingRuns           ,10
CoreAndTailLengths          ,200,300,400,500,600,250,325,410,290,1700
CoreLengths                 ,100,200,300,400,500,150,225,310,190,1000
```
There is no requirement that large a chromosome should be phased and imputed with a large number of cores.

**Example:** Re-using previous phasing

The user has run a phasing using settings shown in Example 2 in another directory. Now the user imputes an updated dataset, but reuses the phasing from Example 2.
```
 = BOX 3: SNPs ==============================================================
NumberSnp                   ,15000
= BOX 5: Phasing ============================================================
NumberPhasingRuns           ,PhaseDone,../Example 2/Phasing,10
CoreAndTailLengths          ,200,300,400,500,600,250,325,410,290,1700
CoreLengths                 ,100,200,300,400,500,150,225,310,190,1000
```

<! --
See Section 3: Example X for more information on reusing phasing information.

> **Stefan TODO**
-->

#### `PedigreeFreePhasing ,(Yes/No)` \index{PedigreeFreePhasing|textbf}
\label{setting-PedigreeFreePhasing}

Default value: `No`

Use pedigree information in long-range phasing. In some cases this may be quicker and more accurate if pedigree information is unreliable.

#### `GenotypeError ,<RealPct> ` \index{GenotypeError|textbf}
\label{setting-GenotypeError}

Default value: `0.0`

Threshold for allowed disagreement between cores of two surrogate parents during surrogate parent identification. Use values between `0.0` and `100.0`.

A value of `1.00` (i.e. 1%) means that across a `CoreAndTailLengths` of 300 SNPs, 3 of these SNP are allowed to be missing or in disagreement between two otherwise compatible surrogate parents. 
Thus these two individuals are allowed to be surrogate parents of each other in spite of the fact that 1% of their genotypes are missing or are in conflict (i.e.\ opposing homozygotes). 
Small values are better (e.g.\ <1.0%).

#### `LargeDatasets ,No ` \index{LargeDatasets|textbf}

Default variant.

Phasing is performed on all individuals assigned to high-density group, cf.\ `HDAnimalsThreshold` \settingref{HDAnimalsThreshold} and `EditingParameters` \settingref{EditingParameters}.

#### `LargeDatasets ,Yes,<int>,<int>,(RandomOrder/Off/InputOrder)` \index{LargeDatasets}

Splits phasing of large datasets into multiple subsets. First argument controls number of subsets. Second argument controls maximum number of subsets each animal may appear in. Third argument controls how individuals are distributed among subsets. 

When third argument is `RandomOrder`, the subsets are populated by sampling animals.

When third argument is `Off`, each animal is phased independently, effectively same as setting number of subsets to number of animals.

When third argument is `InputOrder`, animals are divided into subsets based on the order they are read in and they will only be used in a single subset.


#### `UserDefinedAlphaPhaseAnimalsFile ,<fn> ` \index{UserDefinedAlphaPhaseAnimalsFile|textbf}
\label{setting-UserDefinedAlphaPhaseAnimalsFile}

Default value: `None`

Specifies which animals are regarded as high-density genotyped; overrides settings `HDAnimalsThreshold` \settingref{HDAnimalsThreshold} and `EditingParameters` \settingref{EditingParameters}. 

`<fn>` points to file with single column of IDs. Specify `None` to ignore.



#### `AlphaPhaseOutput ,(No/Yes/Binary/Verbose) ` \index{AlphaPhaseOutput|textbf}
\label{setting-AlphaPhaseOutput}

Default value: `No`

When `No`, no files are written out.

When `Yes`, haplotype libraries are written to the `Phasing` directory in user readable form. This enables re-use of phasing and haplotype library construction. 
When `Binary`, haplotype libraries are written to the `Phasing` directory in bary form. This enables re-use of phasing and haplotype library construction. 
When `Verbose`, haplotype libraries are written to the `Phasing` directory in user readable form as well as output of debugging statements. This enables re-use of phasing and haplotype library construction and allows for debugging phasing errors.

#### `PrephasedFile ,<fn> ` \index{PrephasedFile|textbf}
\label{setting-PrephasedFile}

Default value: `None`

Provides pre-phased data to haplotype library construction. Specify `None` to ignore. Phasing is still performed, but phases of animals given in this file are overwritten.

The expected file format is as the general AlphaImpute genotype file format \settingref{GenotypeFile}, but with *two lines per animal*. 
First line corresponds to sequence of alleles on the paternal gamete, second line corresponds to sequence of alleles on the maternal gamete. First column is animals ID, followed by a column for each SNP position.

Phased alleles are encoded as integer values 0 or 1, corresponding to minor allele a or major allele A, respectively. Missing values are encoded as values between 3 and 9.

#### `UseFerdosi ,(Yes/No)` \index{UseFerdosi|textbf}\index{Ferdosi}
\label{setting-UseFerdosi}

Default value: `No`

Uses the algorithm of Ferdosi et al. [-@ferdosi_hsphase:_2014,-@ferdosi_detection_2014] to derive the phase of a sire that has many progeny genotyped at high-density.
Using the positions and linkage between positions that are opposing homozygote in the offspring, the algorithm defines the positions that the sire is heterozygous and phases them.
As a by-product of this process, the possible locations of recombination points in the offspring and the phase of the offspring are derived.

Requires at least 5-10 high-density genotyped progeny per sire to be effective.


### Box 5: Imputation \index{Imputation, box 5}

**Settings:**
`InternalIterations`, `ConservativeHaplotypeLibraryUse`, `ModelRecomb`

Imputation is performed after phasing in step 1 using a heuristic method described in Hickey et al. [-@hickey_phasing_2012]. 
The phasing step and imputation step can be run as two separate processes, but not in parallel as the imputation step requires a completed phasing. 
This is controlled with the setting `RestartOption` \settingref{RestartOption}. 
If the phasing is computation expensive, the phasing information can be reused if the low-density genotyped animals have been updated with new animals.

An alternative to the default heuristic imputation method is the probabilistic method based on a hidden Markov model [@li_mach:_2010,@antolin_hybrid_2017]. 
It has an advantage over the heuristic method when pedigree information is inconsistent, but is more computational expensive. 
The heuristic method and probabilistic method can be used either exclusively or in combination. 
The settings for the probabilistic method is described in Box 6 \settingref{HMMOption}.

#### `InternalIterations ,<integer>` \index{InternalIterations|textbf}
\label{setting-InternalIterations}

Default value: `5`

The imputation is iterated several times, so that alleles that could not be imputed might be imputed with a haplotype that was found in a subsequently imputed individual. 
Using numbers as low as just 1 or 2 is possible, as AlphaImpute will finish quicker, but at the expense of lower imputation accuracies and yields.
Higher numbers will prolong AlphaImpute's running time with marginal increases in imputation accuracies and yields in return.

#### `ConservativeHaplotypeLibraryUse ,(Yes/No)` \index{ConservativeHaplotypeLibraryUse|textbf}
\label{setting-ConservativeHaplotypeLibraryUse}

Default value: `No`

When `No`, new haplotypes inferred during imputations are added to the haplotype library during imputation when new haplotypes may be inferred. 

When `Yes`, new haplotypes inferred during imputation are not used to impute other genotypes.

#### `ModelRecomb ,(Yes/No)` \index{ModelRecomb|textbf}

Default value: `Yes`

When `Yes`, AlphaImpute performs additional correction after the last imputation iteration and writes imputed genotypes to `Results/ModelRecomb.txt` \index{Files!ModelRecomb.txt}. 
During this correction, recombination events are modelled, and alleles that are affected by recombination events are masked as missing. This correction can increase imputation accuracy, but at the expense of yield.

**Output files:** 
`Results/ModelRecomb.txt`, 
`Results/RecombinationInformationNarrowR.txt` \index{Files!RecombinationInformationNarrowR.txt}, 
`Results/RecombinationInformationNarrow.txt` \index{Files!RecombinationInformationNarrow.txt}, 
`Results/RecombinationInformationR.txt` \index{Files!RecombinationInformationR.txt}, 
`Results/RecombinationInformation.txt` \index{Files!RecombinationInformation.txt}







### Box 6: Hidden Markov model \index{Hidden Markov model, box 6}\index{HMM, see {Hidden Markov model}}

**Settings:**
`HMMOption`, `TemplateHaplotypes`, `BurnInRounds`, `Rounds`, `Seed`, `PhasedAnimalsThreshold`, `WellImputedThreshold`

An alternative to the default heuristic imputation method is the probabilistic method based on a hidden Markov model [@li_mach:_2010,@antolin_hybrid_2017].
It has an advantage over the heuristic method when pedigree information is inconsistent or unreliable, but is however more computational expensive.
The heuristic method and HMM method can be used either exclusively or in combination, see `HMMOption` \settingref{HMMOption}. Full details of the algorithm and implementation is given in Antolin et al. [-@antolin_hybrid_2017].

Using HMM does not use the pedigree. If imputation is performed in conjunction with long-range phasing (step 1) and the heuristic imputation algorithm, a pedigree might be required for those computations.

The HMM works by populating a pool of template haplotypes based on the observed genotypes or phases.
These template haplotypes correspond to those in the entire population that could lead to the observed genotypes.
For each animal, the most likely pair of haplotypes are found, taking into account genotype errors and recombination events.
The genotype errors and recombination events are model hyperparameters that are estimated within the model.
If an animal is phased, a haploid model is used to find each parental haplotype independently. If not, a diploid model is used to find the pair of parental haplotypes (see `WellImputedThreshold`).

To reduce computational time, only a subset of all possible haplotypes is sampled for the template haplotypes (see `TemplateHaplotypes`).
If the entire population is well-phased (see `PhasedAnimalsThreshold`), all animals can be used to sample haplotypes, with the added benefit of using the faster haploid model.
If not, only high-density genotyped animals are used to sample haplotypes, using only their observed genotypes.

AlphaImpute utilizes a Monte-Carlo procedure that succeedingly samples haplotypes, estimates the hyperparameters, and finds the most likely pairs of haplotypes.
The final estimate is found by summarizing over a number of rounds (`Rounds`\index{Rounds|textsl}), after discarding a number of initial ‘burn-in rounds’ (`BurnInRounds`).

When using HMM for imputation, AlphaImpute also outputs `ImputePhaseHMM.txt` \index{Files!ImputePhaseHMM.txt} and `ImputeGenotypesHMM.txt` \index{Files!ImputeGenotypesHMM.txt} with the HMM imputed phases and genotypes,
and *updates* `ImputePhaseProbabilities.txt` \index{Files!ImputePhaseProbabilities.txt} and `ImputeGenotypeProbabilities.txt` \index{Files!ImputeGenotypeProbabilities.txt} with HMM derived allele dosages and genotypes dosages.



#### `HMMOption ,(No/Only/Yes/NGS) ` \index{HMMOption|textbf}
\label{setting-HMMOption}

Default value: `No`

When `Only`, AlphaImpute does not perform long-range phasing and haplotype library construction (step 1), and only performs imputation with the HMM.
This option is useful when phasing information is not available or when imputation is required in unrelated populations [@marchini_genotype_2010].

When `Yes`, AlphaImpute performs standard heurestic imputation *and* performs the HMM imputation as an additional step *after* the last heuristic imputation.

When `NGS`, AlphaImpute does not perform long-range phasing and haplotype library construction (step 1), and only performs imputation with the HMM as in `Only` option.
This option takes as impute sequence data in the form of the number of reads for both the reference and alternative alleles.

#### `TemplateHaplotypes ,<int>  ` \index{TemplateHaplotypes|textbf}
\label{setting-TemplateHaplotypes}

Default value: `0`

Sets the number of template haplotypes that the HMM samples.
Larger numbers can improve imputation accuracy, but at a cost of computation.
Computational time is quadratic on number of template haplotypes, i.e.\ $O(n^2)$.
Can be combined with an increased number of processors (`ParallelProcessors`) to counter increased computational time.

<!--
> **How does this compare to the number of animals?** Can it exceed the number of animals??
-->

#### `BurnInRounds ,<int> ` \index{BurnInRounds|textbf}
\label{setting-BurnInRounds}

Default value: `0`

See setting `Rounds` \settingref{Rounds}

#### `Rounds       ,<int> ` \index{Rounds|textbf}
\label{setting-Rounds}

Default value: `1`

Sets the total number of rounds that the HMM is computed.
For each round, the template haplotypes are re-sampled from eligible animals and model parameters updated, to produce new estimates of imputed phases.
The final verdict is summarized across all rounds, after discarding the estimates from the first number of rounds cf.\ `BurnInRounds` \settingref{BurnInRounds}.
The default value, `0`, makes AlphaImpute to consider all individuals in the population to sample haplotypes.

A value exceeding 50 rarely improves imputation accuracy.

#### `Seed ,<int> ` \index{Seed|textbf}
\label{setting-Seed}

Default value: `-123456789`

Value to seed random number generation. Must be negative.

#### `PhasedAnimalsThreshold ,<RealPct> ` \index{PhasedAnimalsThreshold|textbf}
\label{setting-PhasedAnimalsThreshold}

Default value: `0.90`

The threshold is compared to the overall proportion of phased alleles after long-range phasing (step 1) and heuristic imputation; if this threshold is met, both high-density and imputed animals can be sampled for the template haplotypes.
If the threshold is not met, only high-density genotyped animals are sampled for the template haplotypes.

#### `ThresholdImputed ,<RealPct> ` \index{ThresholdImputed|textbf}
\label{setting-ThresholdImputed}

Default value: `0.50`

The threshold is compared to the proportion of imputed alleles of each animal; if the threshold is met the animal is imputed with faster, haploid HMM.
If the threshold is not met, the animal is imputed with the diploid HMM.

<!--
>> How is this behavior affected when HMMOption is set to ‘Only’?
-->

The haploid HMM estimates each parental haplotype independently when the animal is well-phased.
If the animal is not well-phased, a diploid HMM is used where the parental haplotypes are estimated in tandem.
Both models utilize the same pool of template haplotypes.

<!-- #### `HaplotypesList ,<fn> ` \index{HaplotypesList|textbf}
\label{setting-HaplotypesList}

Default value: `None`
 -->

<!--
***???***
> Daaaaavid??? David! Or Stefan?
> From AlphaImputeSpecFileModule, l. 655.
--->


### Box 7: Runtime options

**Settings:**
`ParallelProcessors`, `PreprocessDataOnly`, `RestartOption`

#### `ParallelProcessors ,<integer>` \index{ParallelProcessors|textbf}
\label{setting-ParallelProcessors}

Default value: `8`

Allows for parallelization during phasing and imputation. More processors reduces computational time. Should be set when run on a grid (e.g. SGE GridEngine)
However, `ParallelProcessors` should not be larger than the number of processors available because it might lead to inefficient performance, due to increased context switches between threads. 


#### `PreprocessDataOnly ,(Yes/No)` \index{PreprocessDataOnly|textbf}
\label{setting-PreprocessDataOnly}

Default value: `No`

When `Yes`, AlphaImpute stops after preprocessing input data. Use option to check data and examine e.g.\ grouping of high-density and low-density animals.

#### `RestartOption ,(0,1,2)` \index{RestartOption|textbf}
\label{setting-RestartOption}

Default value: `0`

Sets AlphaImpute to run all, or first or second step only. 

When `0` (default), AlphaImpute will run through preprocessing, phasing, and imputation.

When `1`, AlphaImpute only runs through preprocessing and phasing. 

When `2`, AlphaImpute only runs through imputation. The latter requires phasing to have run, and this options allows the user impute an updated low-density set without re-running phasing.

To only run preprocessing, set `PreprocessDataOnly ,Yes`.






### Box 8: Output

**Settings:**
`WellPhasedThreshold`, `ResultFolderPath`, `OutputOnlyGenotypedAnimals`

These settings modify the extent of files written to disk.

#### `WellPhasedThreshold ,<RealPct>` \index{WellPhasedThreshold|textbf}
\label{setting-WellPhasedThreshold}

Default value: `99.0`

Individuals with an imputation quality above this threshold have their imputed phases written to `Results/WellPhasedIndividuals.txt` \index{Files!WellPhasedIndividuals.txt}. 
The imputation quality is defined as the proportion of non-missing alleles on both phases.

#### `ResultFolderPath ,<path>` \index{ResultFolderPath|textbf}
\label{setting-ResultFolderPath}

Default: `Results`

Specify a different directory instead of ‘Results’. ***See section Results p. 7.***

#### `OutputOnlyGenotypedAnimals ,(Yes/No)` \index{OutputOnlyGenotypedAnimals|textbf}
\label{setting-OutputOnlyGenotypedAnimals}
 
Default: `No`

When `Yes`, additional animals found in pedigree file \settingref{PedigreeFile} are *not* written to output files.






















