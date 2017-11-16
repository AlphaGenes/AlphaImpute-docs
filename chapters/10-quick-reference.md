# Quick reference

The spec file is a text file comprising two comma separated columns. Lines starting with = are ignored. 

Placeholders are used in this manual to describe the accepted values of settings and are summarized in Table @tbl:quick_arguments. 
These appear enclosed either in angular bracket (<, >) or parentheses. 
Any other text must be provided as-is. 
Arguments given with angular brackets denote type of value, e.g. integers (`<integer>`) or filenames (`<fn>`).
Strings given in parentheses are options and must be given as-is (e.g. `(Yes/No)`).

Table: Placeholder syntax used in manual. {#tbl:quick_arguments}

**Placeholder	** |  **Expected value**
-----------------|----------------------------------------------------------------
`<fn>`           | A filename, absolute or relative to current working directory. Do not use quotation marks. **NB!** Filenames and paths are case sensitive in OSX and Linux!
`<integer>`      | An integer value.
`<real>`         | A real value (e.g. `0.8`).
`<RealPct>`      | A percentage, given without '%' (e.g. `95.0` for 95%)
`(Yes/No)`       | Literal strings, either Yes or No are accepted (case insensitive).
`(a,b,c)`        | One of three literal strings expected.

See table @tbl:quick_reference for an overview of the available settings.

\Begin{landscape}

Table: All settings understood by AlphaImpute. Full explanation of these can be found in the full reference manual. {#tbl:quick_reference}

**Setting**               | **Description**                | **Accepted values**
--------------------------|--------------------------------|-----------------------------
*Box 1: Input data* || 
`PedigreeFile` | Filename of inputfile, relative or absolute. No quotation marks. | Filename, max 300 characters. 
`GenotypeFile` |  | 
`TrueGenotypefile` |  |
`SexChrom` | Impute sex chromosomes. | `No` -- default
.  |  | `Yes,<fn>,(Male/Female)`
*Box 2: SNPs* | | 
`NumberSnp` |	Number of SNP positions in input files.	| `<integer>`
`MultipleHDPanels` | Multiple high-density SNP panels were used. | `(Yes/No)`
`NumberSnpxChip` | Required when `MultipleHDPanels, Yes`; number of SNPs per high-density SNP panel. | `<Integer>,<Integer>,...`
*Box 3: Filtering* ||
`InternalEdit` | Removes SNPs that are missing in too many individuals, and re-evaluates individuals in high-density group. **Note:** Incompatible when `MultipleHDPanels ,Yes`. | `(Yes/No)`
`EditingParameters` | Required when `InternalEdit ,Yes`. | `<RealPct>,<RealPct>, <RealPct>,(AllSnpOut/EditedSnpOut)`
*Box 4: Phasing* ||
`HDAnimalsThreshold` | Threshold of non-missing SNPs for including an animal in the high-density group. | `<RealPct>`
`NumberPhasingRuns` | Number of core sizes given in CoreAndTailLengths and CoreLengths. | `<integer>`
. | Re-use previous phasing. | `phasedone,<fn>,<integer>`
`CoreAndTailLengths` | Size of cores including tails. | `<integer>,<integer>,...`
`CoreLengths` | Size of core excluding tails. | `<integer>,<integer>,...`
`PedigreeFreePhasing` | Use pedigree information in long-range phasing. | `(Yes/No)`
`GenotypeError` | Threshold for allowed disagreement between cores of two surrogate parents during surrogate parent identification. | `<RealPct>`
`LargeDatasets` | Splits phasing of large datasets into multiple subsets. | `Yes,<integer>,<integer>, (RandomOrder/Off/InputOrder)`
. |  1st integer controls number of subsets. 2nd integer controls maximum number of subsets each individual may appear in. 3rd argument controls how individuals are distributed among subsets. | 
`AlphaPhaseOutput` | ? | `(No/Yes/Binary/Verbose)`
`UserDefinedAlphaPhaseAnimalsFile` | Specify which animals to use in step 1. | `<fn>`
`PrephasedFile` | Provides pre-phased data to haplotype library construction. | `<fn>`
`UseFerdosi` | Use Ferdosi algorithm to phase individuals. | `(Yes/No)`
*Box 6: Imputation* | |
`InternalIterations` | Number of iterations of imputations. | `<integer>`
`ConservativeHaplotypeLibraryUse` | When `Yes`, haplotype library is not updated with new haplotypes during imputation. | `(Yes/No)`
`ModelRecomb` | Models recombination after last imputation. | `(Yes/No)`
*Box 7: Hidden Markov model* | |
`HMMOption` | Enable or disable use of HMM something. | `(Yes/No)`
`HMMParameters` | Single line for setting following settings. | `<TemplateHaplotypes>,<BurnInRounds>, <Rounds>,<ParallelProcessors>, <Seed>`
`TemplateHaplotypes` | Number of possible gametes whose recombinations led to a given SNP genotype. | `<integer>`
`BurnInRounds` | Number of rounds to discard before sampling HMM. | `<integer>`
`Rounds` | Total number of rounds for Monte-Carlo sampling of HMM. | `<integer>`
`Seed` | Initial seed for random number generator. Must be negative. | `<integer>`
`PhasedAnimalsThreshold` | Threshold for proportion of phased animals for sampling haplotypes among both impute and high-density genotyped animal. | `<RealPct>`
`ThresholdImputed` | When the proportion of an animal’s alleles are phased above this threshold, the haploid model is used. | `<RealPct>`
`HaplotypesList` | ***????***
*Box 8: Run time options* | |
`PreprocessDataOnly` | When `Yes`, AlphaImpute stops before phasing. | `(Yes/No)`
`ParallelProcessors` | Upper limit of how many parallel processes are used for phasing and HMM. | `<integer>`
`RestartOption` | Causes AlphaImpute to run all steps (`0`), only phasing (`1`), or only imputation (`2`). | `(0,1,2)`
`Cluster` | Advanced option. Not discussed here.	| 
*Box 9: Output* | |
`ResultFolderPath` | Specify a different subdirectory for final output files. | `<path>`
`WellPhasedThreshold` | Phases of individuals with phasing quality above this threshold are written to `Results/WellPhasedIndividuals.txt` | `<Real>`

\End{landscape}


