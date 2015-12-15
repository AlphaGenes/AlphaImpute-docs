===========
AlphaImpute
===========

.. contents:: Table of Contents
   :depth: 5

Introduction
============

|ai| is a software package for imputing and phasing genotype data in populations with pedigree information available. The program uses segregation analysis and haplotype library imputation (**SAHLI**) to impute alleles and genotypes. A complete description of the methods is given in Hickey *et al*., (2012) [1]_. |ai| consists of a single program however it calls both **AlphaPhase1.1** (Hickey *et al*., 2011 [2]_) and **GeneProbForAlphaImpute** (Kerr and Kinghorn, 1996 [3]_). All information on the model of analysis, input files and their layout, is specified in a single parameter file.

Please report bugs or suggestions on how the program / user interface / manual could be improved or made more user friendly to `John.Hickey@roslin.ed.ac.uk <John.Hickey@roslin.ed.ac.uk>`_ or `Roberto.Antolin@roslin.ed.ac.uk <roberto.antolin@roslin.ed.ac.uk>`_.

Availability
------------

|ai| is available from `AlphaGenes <http://www.alphagenes.roslin.ed.ac.uk/software-packages/alphaimpute/>`_ website.

Material available comprises the compiled programs for 64 bit Linux and Mac OSX machines, together with this document and a suite of worked examples.

Conditions of use
-----------------

|ai| is available to the scientific community free of charge. Users are required, however, to credit its use in any publications. Commercial users should contact John Hickey. 

Suggested Citation: 

  Hickey, J. M., Kinghorn, B. P., Tier, B., van der Werf, J. H. J. and Cleveland, M. A., (2012). *A phasing and imputation method for pedigreed populations that results in a single-stage genomic evaluation*. Genetics Selection Evolution **44:9**

Disclaimer
----------

While every effort has been made to ensure that |ai| does what it claims to do, there is absolutely no guarantee that the results provided are correct. Use of |ai| is entirely at your own risk!

Advertisement
-------------

Your welcome to check out our Gibbs sampler (`AlphaBayes <http://www.alphagenes.roslin.ed.ac.uk/software-packages/alphabayes/>`_) specifically designed for GWAS and Genomic Selection.

Description of methods
----------------------

The method implemented in |ai| is described in detail in Hickey *et al*. (2011).

Quickstart
==========

|ai| comes with two different flavors: *Standard* and *Cluster*. The `standard version`_ of |ai| is thought to be run in machines where the user has no restrictions about the device resources in terms of memory or number of processors. For users who want to use |ai| in servers where jobs are controlled by queuing systems, the `cluster version`_ is recomended.

.. _`standard version`: 

Standard version
----------------

To run |ai|, just type ``AlphaImpute`` on the console and press *ENTER*. After welcoming the user with this message::

                               ***********************
                               *                     *
                               *     AlphaImpute     *
                               *                     *
                               ***********************

                     Software For Phasing and Imputing Genotypes

   Written by John Hickey, Matt Cleveland, Andreas Kranis, and Brian Kinghorn

|ai| looks for input parameters within the file ``AlphaImputeSpec.txt`` in the same folder the |ai| binary is located. An example of ``AlphaImputeSpec.txt`` is shown here::

  = BOX 1: Input Files ================================================================
  PedigreeFile                        ,MyPedrigree.txt
  GenotypeFile                        ,MyGenos.txt
  TrueGenotypeFile                    ,None
  = BOX 2: Sex Chromosome =============================================================
  SexChrom                            ,No
  = BOX 3: SNPs =======================================================================
  NumberSnp                           ,1000
  MultipleHDPanels                    ,0
  HDAnimalsThreshold                  ,90.0
  = BOX 4: Internal Editing ===========================================================
  InternalEdit                        ,No
  EditingParameters                   ,95.0,2.0,99.0,EditedSnpOut
  = BOX 5: Phasing ====================================================================
  NumberPhasingRuns                   ,4
  CoreAndTailLengths                  ,250,500,750,1000
  CoreLengths                         ,200,450,700,900
  PedigreeFreePhasing                 ,No
  GenotypeError                       ,0.0
  NumberOfProcessorsAvailable         ,8
  = BOX 6: Imputation =================================================================
  InternalIterations                  ,3
  ConservativeHaplotypeLibraryUse     ,No
  WellPhasedThreshold                 ,90.0
  = BOX 7: Hidden Markov Model ========================================================
  HMMOption                           ,No
  TemplateHaplotypes                  ,200
  BurnInRounds                        ,5
  Rounds                              ,20
  ParallelProcessors                  ,8,
  Seed                                ,-123456789
  ThresholdForPhasedAnimals           ,90.0
  ThresholdImputed                    ,90.0
  WindowLength                        ,150
  = BOX 8: Running options ============================================================
  PreprocessDataOnly                  ,No
  PhasingOnly                         ,No
  UserDefinedAlphaPhaseAnimalsFile    ,None
  PrePhasedFile                       ,None
  BypassGeneProb                      ,No
  RestartOption                       ,0

|ai| has to be run in 4 times in order to: 1) compute genotype probabilities; 2) phase animals genotyped at high-density; 3) impute and phase genotype data of all individuals in the population; and 4) summarise results and write the outputs. The four different steps in which |ai| is run are controlled by the option ``RestartOption`` in the ``AlphaImputeSpec.txt`` file (see section `RestartOption`_). 

Compute Genotype Probabilities
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The first time |ai| is run, ``RestartOption`` has to be set to ``1``. This causes |ai| to create the folder structure::
    
  GeneProb/
  InputFiles/
  IterateGeneProb/
  Miscellaneous/
  Phasing/
  Results/

After creating the folders, |ai| computes the genotype probabilities. To speed up this computation, |ai| splits chromosomes into non-overlapping blocks of markers of the same size, and it computes genotype probabilities for each block in parallel. The size of these blocks depends on the number of processors specified in the spec file (``NumberOfProcessorsAvailable``). For each processor, a folder ``GeneProb/GeneProbX`` is created containing:

* ``GeneProbSpec.txt``: The file of parameters or commonly the *spec* file
* **GeneProbForAlphaImpute**: The executable of GeneProb. 

|ai| automatically runs **GeneProbForAlphaImpute** for each ``GeneProbX`` folder according to the spec file.

Phase animals gentoyped at HD
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The second time |ai| is run, ``RestartOption`` has to be set to ``2``. This causes |ai| to phase the haplotypes of those individuals genotyped at high-density. Phasing is computed across all markers according to the phasing strategies that have been set by parameters ``CoreAndTailLengths`` and ``CoreLengths``. For each core in the spec file, |ai| computes two phasing rounds by running AlphaPhase in ``Offset`` and ``NotOffset`` mode (Hickey *et al*. (2011) [2]_).

|ai| runs the phasing rounds in different parallel processes. It is worth to notice that the number of processors has to be equal to ``NumberOfProcessorsAvailable`` :math:` = 2 \times` ``NumberPhasingRuns``. For each processor, a folder ``Phasing/PhaseX`` is created containing:

* ``AlphaPhaseSpec.txt``: The spec file of parameters.
* **AlphaPhase1.1**: The executable of AlphaPhase. 

|ai| automatically runs **AlphaPhase** for each ``PhaseX`` folder according to the spec file.

Impute genotype data for all individuals
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The third time |ai| is run, ``RestartOption`` has to be set to ``3``. This makes |ai| to impute genotypes for all the individuals in the pedigree file. Imputation is based on the phased haplotypes of the individuals genotyped at high-density (`Phase HD animals`_). 

In some situations, imputation thresholds are not met and markers cannot be imputed. To overcome this, |ai| offers two different solutions: To run GeneProbs or to apply a hidden Markov model.

The default solution is to run **GeneProbForAlphaImpute** to calculate genotype probabilities based on the new genotype information. |ai| creates the folder structure ``IterateGeneProb/GeneProbX``. Each ``GeneProbX`` folder contains:

* ``GeneProbSpec.txt``: The file of parameters or commonly the *spec* file
* **GeneProbForAlphaImpute**: The executable of GeneProb. 

A more sophisticated approach is to impute the missing genotypes with a hidden Markov model. To use the Markov model after the imputation process, ``HMMOption`` has to be set to ``Yes`` and ``RestartOption`` to ``3``. The hidden Markov model is controlled by the five parameters in option ``HmmParameters``. These five parameters are referred to (in order):

* *number of haplotypes*
* *number of burn-in rounds*
* *number of rounds*
* *number of processors available*
* *seed*

The parameters shown in the example spec file work well for most cases, but the user can set other values (see `HMMParameters`_ section for more information about how to set optimal parameters).

Once the hidden Markov model has finished, |ai| outputs the most likely genotypes, genotype dosages and genotype probabilities into different files:

* ``ImputeGenotypes.txt``
* ``ImputeGenotypesHMM.txt``
* ``ImputeGenotypesProbabilities.txt``
* ``GenotypeProbabilities.txt``

|ai| provides similar information for phasing results and allele probabilities:

* ``ImputePhase.txt``
* ``ImputePhaseHMM.txt``
* ``ImputePhaseProbabilities.txt``

Summarise results and write the outputs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If the segregation analysis approach (i.e. **GeneProbForAlphaImpute**) was used during the imputation step, results have to be summarised. So, |ai| has to be run a final time with the ``RestartOption`` set to ``4``. This writes out files with the most likely genotypes, genotype dosages and genotype probabilities

* ``ImputeGenotypes.txt``
* ``ImputeGenotypesProbabilities.txt``
* ``GenotypeProbabilities.txt``

|ai| provides similar information for phasing results and allele probabilities:

* ``ImputePhase.txt``
* ``ImputePhaseProbabilities.txt``

.. _`cluster version`:

Cluster version
---------------

To run |ai|, just type ``AlphaImpute`` on the console and press *ENTER*. After welcoming the user with this message::

                               ***********************
                               *                     *
                               *     AlphaImpute     *
                               *                     *
                               ***********************

                     Software For Phasing and Imputing Genotypes

   Written by John Hickey, Matt Cleveland, Andreas Kranis, and Brian Kinghorn

|ai| looks for input parameters within the file ``AlphaImputeSpec.txt`` in the same folder the |ai| binary is located. An example of ``AlphaImputeSpec.txt`` is shown here::

  = BOX 1: Input Files ================================================================
  PedigreeFile                        ,MyPedrigree.txt
  GenotypeFile                        ,MyGenos.txt
  TrueGenotypeFile                    ,None
  = BOX 2: Sex Chromosome =============================================================
  SexChrom                            ,No
  = BOX 3: SNPs =======================================================================
  NumberSnp                           ,1000
  MultipleHDPanels                    ,0
  HDAnimalsThreshold                  ,90.0
  = BOX 4: Internal Editing ===========================================================
  InternalEdit                        ,No
  EditingParameters                   ,95.0,2.0,99.0,EditedSnpOut
  = BOX 5: Phasing ====================================================================
  NumberPhasingRuns                   ,4
  CoreAndTailLengths                  ,250,500,750,1000
  CoreLengths                         ,200,450,700,900
  PedigreeFreePhasing                 ,No
  GenotypeError                       ,0.0
  NumberOfProcessorsAvailable         ,8
  = BOX 6: Imputation =================================================================
  InternalIterations                  ,3
  ConservativeHaplotypeLibraryUse     ,No
  WellPhasedThreshold                 ,90.0
  = BOX 7: Hidden Markov Model ========================================================
  HMMOption                           ,No
  TemplateHaplotypes                  ,200
  BurnInRounds                        ,5
  Rounds                              ,20
  ParallelProcessors                  ,8,
  Seed                                ,-123456789
  ThresholdForPhasedAnimals           ,90.0
  ThresholdImputed                    ,90.0
  WindowLength                        ,150
  = BOX 8: Running options ============================================================
  PreprocessDataOnly                  ,No
  PhasingOnly                         ,No
  UserDefinedAlphaPhaseAnimalsFile    ,None
  PrePhasedFile                       ,None
  BypassGeneProb                      ,No
  RestartOption                       ,0

|ai| has to be run in 4 times in order to: 1) compute genotype probabilities; 2) phase animals genotyped at high-density; 3) impute and phase genotype data of all individuals in the population; and 4) summarise results and write the outputs. The four different steps in which |ai| is run are controlled by the option ``RestartOption`` in the ``AlphaImputeSpec.txt`` file (see section `RestartOption`_). 

Compute Genotype Probabilities
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The first time |ai| is run, ``RestartOption`` has to be set to ``1``. This causes |ai| to create the folder structure::
    
  GeneProb/
  InputFiles/
  IterateGeneProb/
  Miscellaneous/
  Phasing/
  Results/

To speed up this computation, |ai| splits chromosomes into non-overlapping blocks of markers of the same size, and prepares the folder structure to compute the genotype probabilities for each block in parallel. The size of these blocks depends on the number of processors specified in the spec file (``NumberOfProcessorsAvailable``). For each processor, a folder ``GeneProb/GeneProbX`` is created containing:

* ``GeneProbSpec.txt``: The file of parameters or commonly the *spec* file
* **GeneProbForAlphaImpute**: The executable of GeneProb. 

Because each cluster system is potentially different, |ai| does not run **GeneProbForAlphaImpute** for each ``GeneProbX`` automatically, and after creating the folders, |ai| stops with this message:

.. warning:: ``Restart option 1 stops program before Geneprobs jobs have been submitted``

The user is supposed to do so according to his/her cluster characteristics. The easiest way to run all the GeneProb processes is to create a script file that automatically send them to the system queue.

Phase animals gentoyped at HD for clusters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The second time |ai| is run, ``RestartOption`` has to be set to ``2``. This causes |ai| to phase the haplotypes of those animals genotyped at high-density.

As before, |ai| split the chromosome into different cores in order to phase the haplotypes of individuals genotyped at high-density in different parallel processes. Phasing is computed across all markers according to the phasing strategies that have been set by parameters ``CoreAndTailLengths`` and ``CoreLengths``. For each core in the spec file, two phasing rounds are computed by running **AlphaPhase** in ``Offset`` and ``NotOffset`` mode (Hickey *et al*. (2011) [2]_).

It is worth to notice that the number of processors has to be equal to ``NumberOfProcessorsAvailable``:math:` = 2 \times` ``NumberPhasingRuns``. For each processor, a folder ``Phasing/PhaseX`` is created containing: 

* ``AlphaPhaseSpec.txt``: The spec file of parameters.
* **AlphaPhase1.1**: The executable of AlphaPhase. 

However, |ai| stops before processing the phasing with the message:

.. warning:: ``Restart option 2 stops program before Phasing has been managed``

and does not run **AlphaPhase1.1** in the different ``PhaseX`` folders. The user is supposed to do so according to his/her cluster characteristics. The easiest way to run all the GeneProb processes is to create a script file that automatically send them to the system queue.

Impute genotype data for all individuals
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The third time |ai| is run, ``RestartOption`` has to be set to ``3``. This causes |ai| to impute genotypes for all the individuals in the pedigree file. Imputation is based on the phased haplotypes of the individuals genotyped at high-density (`Phase animals gentoyped at HD for clusters`_). 

In some situations, imputation thresholds are not met and markers cannot be imputed. To overcome this, |ai| offers two different solutions: to run GeneProbs or to apply a hidden Markov model.

The default solution is to run **GeneProbForAlphaImpute** to calculate genotype probabilities based on the new genotype information. |ai| creates the folder structure ``IterateGeneProb/GeneProbX``. Each ``GeneProbX`` folder contains:

* ``GeneProbSpec.txt``: The file of parameters or commonly the *spec* file
* **GeneProbForAlphaImpute**: The executable of GeneProb. 

|ai| does not compute the genotype probabilities automatically and it stops with the message:

.. warning:: ``Restart option 3 stops program before Iterate Geneprob jobs have been submitted``

The user is supposed to do so according to his/her cluster characteristics. The easiest way to run all the GeneProb processes is to create a script file that automatically send them to the system queue.

A more sophisticated approach is to impute the missing genotypes with a hidden Markov model. To use the Markov model after the imputation process, ``HMMOption`` has to be set to ``Yes`` and ``RestartOption`` to ``3``. The hidden Markov model is controlled by the five parameters in option ``HmmParameters``. These five parameters are referred to (in order):

* *number of haplotypes*
* *number of burn-in rounds*
* *number of rounds*
* *number of processors available*
* *seed*

The parameters shown in the spec file above work well for most cases, but the user can set other values (see `HMMParameters`_ section for more information about how to set optimal parameters).

Once the hidden Markov model has finished, |ai| outputs the most likely genotypes, genotype dosages and genotype probabilities into different files:

* ``ImputeGenotypes.txt``
* ``ImputeGenotypesHMM.txt``
* ``ImputeGenotypesProbabilities.txt``
* ``GenotypeProbabilities.txt``

|ai| provides similar information for phasing results and allele probabilities:

* ``ImputePhase.txt``
* ``ImputePhaseHMM.txt``
* ``ImputePhaseProbabilities.txt``

Summarise results and write the outputs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If the segregation analysis approach (i.e. **GeneProbForAlphaImpute**) was used during the imputation step, results have to be summarised. So, |ai| has to be run a final time with the ``RestartOption`` set to ``4``. This writes out files with the most likely genotypes, genotype dosages and genotype probabilities

* ``ImputeGenotypes.txt``
* ``ImputeGenotypesProbabilities.txt``
* ``GenotypeProbabilities.txt``

|ai| provides similar information for phasing results and allele probabilities:

* ``ImputePhase.txt``
* ``ImputePhaseProbabilities.txt``


Using AlphaImpute
=================

.. note:: |ai| works for single chromosomes at a time only.

.. note:: |ai| seeks to maximise the correlation between true and imputed markers while minimising the percentage of markers imputed incorrectly. It does not seek to maximise the percentage of markers correctly imputed as this would involve “cheating” and “guessing”, therefore it is not advisable to evaluate the performance of the program based on the percentage of alleles correctly imputed. For a discussion on this topic please consult Hickey *et al*., (2011) [4]_.


Input files
-----------

AlphaImputeSpec.txt
^^^^^^^^^^^^^^^^^^^

An example of ``AlphaImputeSpec.txt`` is shown in Figure 1. Everything to the left of the comma should not be changed. The program is controlled by changing the input to the right of the comma::

  = BOX 1: Input Files ================================================================
  PedigreeFile                        ,MyPedrigree.txt
  GenotypeFile                        ,MyGenos.txt
  TrueGenotypeFile                    ,None
  = BOX 2: Sex Chromosome =============================================================
  SexChrom                            ,No
  = BOX 3: SNPs =======================================================================
  NumberSnp                           ,1000
  MultipleHDPanels                    ,0
  HDAnimalsThreshold                  ,90.0
  = BOX 4: Internal Editing ===========================================================
  InternalEdit                        ,No
  EditingParameters                   ,95.0,2.0,99.0,EditedSnpOut
  = BOX 5: Phasing ====================================================================
  NumberPhasingRuns                   ,4
  CoreAndTailLengths                  ,250,500,750,1000
  CoreLengths                         ,200,450,700,900
  PedigreeFreePhasing                 ,No
  GenotypeError                       ,0.0
  NumberOfProcessorsAvailable         ,8
  = BOX 6: Imputation =================================================================
  InternalIterations                  ,3
  ConservativeHaplotypeLibraryUse     ,No
  WellPhasedThreshold                 ,90.0
  = BOX 7: Hidden Markov Model ========================================================
  HMMOption                           ,No
  TemplateHaplotypes                  ,200
  BurnInRounds                        ,5
  Rounds                              ,20
  ParallelProcessors                  ,8,
  Seed                                ,-123456789
  ThresholdForPhasedAnimals           ,90.0
  ThresholdImputed                    ,90.0
  WindowLength                        ,150
  = BOX 8: Running options ============================================================
  PreprocessDataOnly                  ,No
  PhasingOnly                         ,No
  UserDefinedAlphaPhaseAnimalsFile    ,None
  PrePhasedFile                       ,None
  BypassGeneProb                      ,No
  RestartOption                       ,0
  
Below is a description of what each line does. It is important to note that ``AlphaImputeSpec.txt`` is case sensitive. Before proceeding, it is worth pointing out that internally |ai| divides all the animals in the pedigree into two groups, one called a high-density group and the other the low-density group. The high-density group is the group of animals that have been genotyped for enough SNP that they can have their haplotypes resolved by AlphaPhase1.1. The low-density group are all remaining animals in the pedigree and comprise animals that are not genotyped at all, are genotyped at low density, or are genotyped at high density but have a proportion (greater than a threshold the user can set) of their SNP missing (e.g. not called by the genotype calling algorithm). This partitioning is done because placing animals with too many SNP missing into AlphaPhase1.1 can result in dramatic increases in computational time and dramatic reduction in the accuracy of phasing (see AlphaPhase1.1 user manual for more information).

PedigreeFile
""""""""""""
Gives the name of the file containing the pedigree information. Details on the format are given in the `Data format`_ section.

GenotypeFile
""""""""""""
Gives the name of the file containing the genotypes. Details on the format are given in the `Data format`_ section.


SexChrom
""""""""
Specifies whether the program should impute sex chromosomes or not. The two options are ``Yes`` or ``No``. 

Impute sex chromosome requires to specify the file containing the sex chromosomes and the heterogametic status. They are provided just after the ``Yes`` string and separated by comas. For the heterogametic status the options are ``Male`` or ``Female``. Below is a sample of how the specification file should look::

  PedigreeFile                          ,MyPedrigree.txt
  GenotypeFile                          ,MyGenos.txt
  SexChrom                              ,Yes,MySexChromosomeFile.txt,Male


NumberOfSnp
"""""""""""
Gives the number of SNP in the genotype file.

InternalEdit
""""""""""""
Specifies whether the program should edit the data internally or not. The two options are ``Yes`` or ``No``. Editing the data allows the program to remove SNP that are missing in too many animals and/or remove animals from the high-density group that have too many SNP that are missing. Editing the data may increase the speed and accuracy of the imputation. It is particularly important not to allow too many missing genotypes to enter the phasing step in AlphaPhase1.1 as this can dramatically increase the time required to complete the phasing and reduce the phasing accuracy.

EditingParameters
"""""""""""""""""
Controls the internal editing that is invoked the ``InternalEdit`` option described above. The three numerical parameters control the internal editing while the case sensitive qualifier controls the final output of the results with regard to the editing. The internal editing involves three steps run in sequence (Step 1, Step 2, and Step 3).

The first numerical parameter controls Step 1, which divides the animals in the data into two initial groups, the high-density group, and the low-density group. Animals in the data set that are genotyped for more than XX.X% (in figure 1 this value is 95.0%) of the SNP enter the high-density group, with the remainder entering the low-density group. 

The second numerical parameter controls Step 2, which removes some SNP from the analysis. SNP that are missing in more than XX.X% (in figure 1 this value is 2.0) of the animals placed in the high-density set by the previous parameter are removed. 

The third numerical parameter controls Step 3, which finalises the animals in the high-density group. It is similar to that of the first numerical parameter in that it divides the data into two groups, the finalised high-density group and low-density group. The animals in the data set that are genotyped for more than XX.X% (in figure 1 this value is 98.0) of the SNP that remain after Step 2 enter the finalised high-density set. The remaining animals enter the finalised low density set. The final high-density group is passed to AlphaPhase1.1 to be phased. 

The case sensitive qualifier controls the SNP for which results are outputted and it has two options ``AllSnpOut`` or ``EditedSnpOut`` (note that these are case sensitive). ``AllSnpOut`` produces output for all the SNP that are inputted. ``EditedSnpOut`` produces output only for the SNP that survive the internal editing. The SNP that survive the internal editing are outlined in the output file ``EditingSnpSummary.txt`` which is described below.

NumberOfPairsOfPhasingRounds
""""""""""""""""""""""""""""
This parameter admits two alternatives.

*Alternative 1* controls the number of pairs of phasing rounds that are performed by AlphaPhase1.1 on the high-density group. The minimum for this number is 2 and the maximum is 30::

  = BOX 1: Input Files ================================================================
  PedigreeFile                        ,MyPedrigree.txt
  GenotypeFile                        ,MyGenos.txt
  TrueGenotypeFile                    ,MyTrueGenos.txt
  = BOX 2: Sex Chromosome =============================================================
  SexChrom                            ,No
  = BOX 3: SNPs =======================================================================
  NumberSnp                           ,1000
  MultipleHDPanels                    ,0
  HDAnimalsThreshold                  ,90.0
  = BOX 4: Internal Editing ===========================================================
  InternalEdit                        ,Yes
  EditingParameters                   ,95.0,2.0,98.0,EditedSnpOut
  = BOX 5: Phasing ====================================================================
  NumberPhasingRuns                   ,10
  CoreAndTailLengths                  ,200,300,400,500,600,250,325,410,290,700
  CoreLengths                         ,100,200,300,400,500,150,225,310,190,600
  PedigreeFreePhasing                 ,No
  GenotypeError                       ,0.0
  NumberOfProcessorsAvailable         ,20
  = BOX 6: Imputation =================================================================
  InternalIterations                  ,3
  ConservativeHaplotypeLibraryUse     ,No
  WellPhasedThreshold                 ,99.0
  = BOX 7: Hidden Markov Model ========================================================
  HMMOption                           ,No
  TemplateHaplotypes                  ,200
  BurnInRounds                        ,5
  Rounds                              ,20
  ParallelProcessors                  ,8,
  Seed                                ,-123456789
  ThresholdForPhasedAnimals           ,90.0
  ThresholdImputed                    ,90.0
  WindowLength                        ,150
  = BOX 8: Running options ============================================================
  PreprocessDataOnly                  ,No
  PhasingOnly                         ,No
  UserDefinedAlphaPhaseAnimalsFile    ,None
  PrePhasedFile                       ,None
  BypassGeneProb                      ,No
  RestartOption                       ,2

It is worth pointing out that a pair of rounds comprises one round with AlphaPhase1.1 in ``Offset`` mode and the other in ``NotOffset`` mode. Different phasing rounds are required so that each SNP are phased multiple times as a part of cores that span different SNP. Additionally the different core spans and ``Offset``/``NotOffset`` modes create overlaps between cores. This helps to partially remove the small percentages of phasing errors that AlphaPhase1.1 makes. The concept of cores (and their tails) is outlined in Hickey *et al*. (2011) [2]_. ``Offset/NotOffset`` mode is described below.

*Alternative 2* can be used to read in data sets that have been previously phased by AlphaPhase1.1::

  = BOX 1: Input Files ================================================================
  PedigreeFile                        ,MyPedrigree.txt
  GenotypeFile                        ,MyGenos.txt
  TrueGenotypeFile                    ,MyTrueGenos.txt
  = BOX 2: Sex Chromosome =============================================================
  SexChrom                            ,No
  = BOX 3: SNPs =======================================================================
  NumberSnp                           ,1000
  MultipleHDPanels                    ,0
  HDAnimalsThreshold                  ,90.0
  = BOX 4: Internal Editing ===========================================================
  InternalEdit                        ,Yes
  EditingParameters                   ,95.0,2.0,98.0,EditedSnpOut
  = BOX 5: Phasing ====================================================================
  NumberPhasingRuns                   ,PhaseDone,"/Users/john/Proj/Test/PhaseOld/",20
  CoreAndTailLengths                  ,200,300,400,500,600,250,325,410,290,700
  CoreLengths                         ,100,200,300,400,500,150,225,310,190,600
  PedigreeFreePhasing                 ,No
  GenotypeError                       ,0.0
  NumberOfProcessorsAvailable         ,20
  = BOX 6: Imputation =================================================================
  InternalIterations                  ,3
  ConservativeHaplotypeLibraryUse     ,No
  WellPhasedThreshold                 ,99.0
  = BOX 7: Hidden Markov Model ========================================================
  HMMOption                           ,No
  TemplateHaplotypes                  ,200
  BurnInRounds                        ,5
  Rounds                              ,20
  ParallelProcessors                  ,8,
  Seed                                ,-123456789
  ThresholdForPhasedAnimals           ,90.0
  ThresholdImputed                    ,90.0
  WindowLength                        ,150
  = BOX 8: Running options ============================================================
  PreprocessDataOnly                  ,No
  PhasingOnly                         ,No
  UserDefinedAlphaPhaseAnimalsFile    ,None
  PrePhasedFile                       ,None
  BypassGeneProb                      ,No
  RestartOption                       ,2

This allows users to read in results of previous phasing work. Three parameters are required here. 

The first is the case sensitive qualifier ``PhaseDone``. This specifies that the phasing rounds have been done previously. 

The second is the complete path to where these phasing rounds are stored. This path must be surrounded by quotations (e.g. ``“/here/is/the/full/path/”``). 

The third is the number of phasing jobs that are to be read from the folder. The folders containing each of the phasing rounds must be labelled Phase1, Phase2, ..., PhaseN, where N is the number of phasing rounds. It is important to realise that *Alternative 1* (described above) for ``NumberOfPhasingRounds`` sets a number that is half the actual number of phasing rounds carried out (because of it specifes the number of pairs of rounds rather than individual rounds). Therefore it is good to check how many phasing rounds are actually in the folder you are reading in. 

The second alternative can be used in conjunction with ``PreProcessDataOnly`` (described below) to give greater control on the computational time required to perform the phasing. An example of how this works is given in detail in the `Examples`_ section (``PreProcessDataExample``).


CoreAndTailLengths
""""""""""""""""""
Gives the overall length in terms of numbers of SNP in the core and its adjacent tails for each of the phasing runs. The concept of cores and tails is outlined in Hickey *et al*. 2011. For example if the CoreLengths (described below) value is 100 and the ``CoreAndTailLengths`` is 300, the core is 100 SNP long and the tails are the 100 SNP adjacent to each end of the core. Thus the length of the core and tail is 300 SNP. At the end of a chromosome, the tail can only extend in one direction. In this case the core and tail length would only be 200 SNP, the 100 SNP in the core, and the 100 SNP adjacent to one end of the core. The total number of ``CoreAndTailLengths`` specified must equal the number specified for ``NumberOfPairsOfPhasingRounds`` (i.e. in figure 1 there are 10 rounds of phasing specified and there are 10 ``CoreAndTailLengths`` specified).


CoreLengths
"""""""""""
Gives the overall length in terms of numbers of SNPs of each core. The ``CoreLengths`` can never be longer than its corresponding ``CoreAndTailLengths``. The total number of ``CoreLengths`` specified must equal the number specified for ``NumberOfPairsOfPhasingRounds`` (i.e. in figure 1 there are 10 rounds of phasing specified and there are 10 ``CoreLengths`` specified).

The order of the ``CoreAndTailLengths`` must correspond to the order of the ``CoreLengths`` (i.e. in figure 2 the ``CoreAndTailLenghts`` 200 is for the first pair of phasing runs and corresponds to the ``CoreLenths`` 100.


PedigreeFreePhasing
"""""""""""""""""""
Tells the program to perform the long-range phasing step of AlphaPhase1.1 without using pedigree information. In some cases this may be quicker and more accurate, but it is not likely to be commonly applicable. The command options to the right of the comma are a case sensitive ``No`` or ``Yes``.


GenotypeErrorPercentage
"""""""""""""""""""""""
Gives the percentage of SNP that are allowed to be missing or in conflict across the entire core and tail length during the surrogate definition in AlphaPhase1.1. A value of 1.00 (i.e. 1%) means that across a ``CoreAndTailLengths`` of 300 SNPs, 3 of these SNP are allowed to be missing or in disagreement between two otherwise compatible surrogate parents. Thus these two individuals are allowed to be surrogate parents of each other in spite of the fact that 1% of their genotypes are missing or are in conflict (i.e. opposing homozygotes). Small values are better (e.g. <1.0%). See the manual for AlphaPhase1.1 for more details.


NumberOfProcessorsAvailable
"""""""""""""""""""""""""""
Sets the number of processors used to compute the genotype probabilities and Phasing rounds. The more processors, the shorter the computational time, however ``NumberOfProcessorsAvailable`` should not be larger than the number of processors available because it might lead to inefficient performances.


InternalIterations
""""""""""""""""""
Controls the number of iterations of the internal haplotype matching and imputation steps. A good number for this parameter is ``3``.


PrepocessDataOnly
"""""""""""""""""
Has two options ``Yes`` or ``No``.

``Yes`` sets the program so that it stops after it has pre-processed the data and set up the files for the analysis.
  
``No`` sets the program to do a complete imputation run.

The ``Yes`` option is useful for getting to know your data set. The different data ``EditingParameters`` alter the number of SNP to be included in the analysis, and alter the numbers of animals that are included in the high-density group that is passed to AlphaPhase1.1. These numbers are printed to the screen. It is best to try different editing options to tune to each data set. Pre-processing the data creates the files for the genotype probabilities and phasing rounds. The phasing rounds can then be run external to |ai| to see if the phasing parameters (``CoreLengths``, ``CoreAndTailLengths``, ``GenotypeErrorPercentage``) are appropriate in terms of speed and phasing yield for the ``EditingParameters`` used on the data set.

The phasing rounds can be then run directly by the user by first running the program with ``PreProcessDataOnly`` set to ``Yes`` and ``RestartOption`` set to ``2`` (see `RestartOption`_ for more details), then renaming the folder Phase to something else (e.g. ``PhasePreProcess`` because the folder ``Phase`` gets deleted each time you run the program) and then the program can be rerun with ``PreProcessDataOnly`` set to ``No``, ``RestartOption`` set to ``2`` and having the ``NumberOfPhasingRuns`` altered so that it reads the Phasing rounds in the ``PhasePreProcess`` folder (N.B. Check the number of folders in this folder, you don’t want to leave phase rounds behind!). This option allows the user to tweak the phasing parameters.


UserDefinedAlphaPhaseAnimalsFile
""""""""""""""""""""""""""""""""
Gives the user an option to read in a list of individuals that are phased using long-range phasing in |ai|. Specify ``None`` to the right of the comma if no file is to be read in, or specify the name of the file to the right of the comma if a file is to be read in. The file to be read in should contain a single column of the ID’s of the individuals to be sent to |ai|. This option is useful for routine runs involving large data sets.


PrePhasedFile
"""""""""""""
Gives the option to read in pre-phased data (e.g. phased by a previous round of |ai| or by another program such as a half-sib haplotyping program). Specify ``None`` to the right of the comma if no file is to be read in, or specify the name of the file to the right of the comma if a file is to be read in. The file to be read in should contain two lines for each individual, the first line being its phased paternal gamete (alleles coded as 0 or 1 or another integer (e.g. 3) for missing alleles) and the second line being the phased maternal gamete. The first column should be a the ID’s of the individuals. The file takes the same format as ``ImputePhase.txt`` in the Results section of |ai|. Care must be taken here to ensure that only reliable phased individuals are included when using this option.

RestartOption
"""""""""""""

.. note:: This option behaves differently depending on the |ai| version. Two different version of |ai| have been distributed, the *standard* version and the *cluster* version. If not specified otherwise, the *standard* version is explained in this section.

The program can be run in three different and consecutive steps: 1) calculate genotype probabilities; 2) haplotype phasing; and 3) impute genotypes. ``RestartOption`` controls which step is being processed at each time.

``RestartOption`` set to ``1`` calculates the genotype probabilities in different parallel processes. The number of parallel processes is given by ``NumberOfProcessorsAvailable``. The program stops after all the processes have finished.

.. note:: In the *cluster* version, the user is responsible for creating a script which manages the computation of the genotype probabilities rounds accordingly to the number of processors set in ``NumberOfProcessorsAvailable`` and to the cluster specifications. The program stops immediately before the script has been executed.

``RestartOption`` set to ``2`` runs the Phasing rounds in parallel processes. The number of parallel processes is given by ``NumberOfProcessorsAvailable``. The program stops after all Phasing rounds have finished. AlphaPhase1.1 is used for computing the Phasing rounds by default, but Phasing rounds can also be run by any external program.

.. note:: In the *cluster* version, the user is responsible for creating a script which computes the haplotype phasing accordingly to the number of processors specified in ``NumberOfPhasingRuns`` and to the cluster specifications. |ai| stops before the script has been executed.

``RestartOption`` set to ``3`` runs the program to impute the missing genotypes. The program has two different built-in imputation algorithms. One is a heuristic method based on a segregation analysis and haplotype library imputation (**SAHLI**). The second is based on a hidden Markov model (HMM) (see `HMMOptions`_ and `HMMParameters`_ for more information about how to set optimal parameters).

``RestartOption`` ``0`` runs the whole stepwise process, i.e. it computes genotype probabilities, performs haplotype phasing and imputes genotypes consecutively.

.. note:: ``RestartOption`` = ``0`` is disabled in the *cluster* version. However, the user can create a script to simulate this option by running |ai| with ``RestartOption`` set to ``1``, ``2`` and ``3`` consecutively.

There are two reasons as to why a user might want to run the program in consecutive steps. Firstly the pre-processing steps can be used to observe how different parameters settings affect the partitioning of the data into the high-density group/low-density group and the removal of SNP from the analysis. Secondly the major bottleneck in the program is the computational time required to do the phasing. Running the program using a different step may help to speed up the entire process.

``PhaseOnly``, ``BypassGenProb`` and ``PrepocessDataOnly`` might modify the ``RestartOption`` behaviour. For more details please, see `PhaseOnly`_, `BypassGenProb`_ and `PrepocessDataOnly`_ options, respectively.

PhaseOnly
"""""""""
Tells the program to skip the imputation run. The command options are a case sensitive ``No`` or ``Yes``. ``Yes`` will stop the program immediately after the genotypes have been phased. ``No`` sets the program to do the imputation run.


ConservativeHaplotypeLibraryUse
"""""""""""""""""""""""""""""""
Tells the program to avoid the further population of the haplotype library during the imputation step. The haplotype library was previously created during the LRPHI phasing process. The command options are a case sensitive ``No`` or ``Yes``.


WellPhasedThreshold
"""""""""""""""""""
Controls the final imputation quality of the individuals. Those individuals with an imputation accuracy above ``WellPhasedThreshold`` will be outputted in the ``WellPhasedIndividuals.txt`` file.


BypassGenProb
"""""""""""""
Tells the program to avoid the computation of the Genotype probabilities. ``BypassGenProb`` has two options ``Yes`` or ``No``.

``Yes`` sets the program to skip the computation of genotype probabilities rounds during the pre-processing data step, and stops the program before the final computation of genotype dosages during the final step of writing the results.

``No`` sets the program to run normally.


HMMOptions
""""""""""
Controls the imputation algorithm during the imputation step (``RestartOption`` set to ``3``). ``HMMOptions`` has three possible values: ``No``, ``Yes`` and ``Only``.
 .. and ``Prephase``.

``No`` makes |ai| to compute the heuristic imputation method explained in Hickey *et al*., (2012) [1]_. This is the standard imputation.

.. ``Prephase`` uses pre-phased information to run the HMM imputation algorithm. Haplotypes are chosen at random from the prephased data, and possible missing heterozygous loci are phased arbitrarily.
 
``Only`` makes |ai| to compute imputation with the hidden Markov model (HMM) explained in Li *et al*., 2009 [5]_. The haplotype template of the HMM method is populated with genotype data from individuals picked at random. Unambiguous alleles are phased from homozygous loci, whereas heterozygous loci are phased arbitrarily. This option is useful when phasing information is not available or when imputation is required in unrelated populations (Marchini and Howie, 2010) [6]_.

``Yes`` causes |ai| to compute imputation in two steps. In the first step, the program uses the standard imputation method to guarantee very accurate genotype imputation and haplotype phasing. Haplotypes obtained at the phasing step will be used to feed the haplotype template of the HMM method. During the generation of the template, haplotypes are chosen at random and possible missing heterozygous loci are phased arbitrarily. This stepwise approach is the most accurate but also the most computationally expensive in terms of time.

.. Options ``PrePhase`` and ``Yes`` require the haplotypes to be previously phased, e.g. running the program with ``RestartOption`` set to ``2`` (see `RestartOption`_ option for more details).

HMMParameters
"""""""""""""
Where heuristic methods fail if rules are not met, HMM algorithms are very flexible performing well in unrelated samples and being applicable in most genome regions computing genotype dosages. HMM imputation methods try to explain the genotype of a particular locus as generated by a hidden state conditional to the previous state. HMM methods are defined by the transition probabilities between states, i.e. the probability of getting a state given the previous one, and the emission probabilities, i.e. probability of observing a genotype given a particular state. Commonly, the number of states determines the computational complexity of HMM algorithms.

|ai| implements the Markov model described in Li *et al*., 2009 [5]_. This model is defined by the number of states, :math:`H^2`, the crossovers parameters, :math:`\theta_i, i = {1,\ldots,M}`, and the error parameters, :math:`\varepsilon_j, j = {1,\ldots,M}`; where :math:`H` is the number of haplotypes in the haplotype template, and :math:`M` is the number of markers. The crossovers define the transition probabilities from one state to the next, giving an estimation of the recombination rates across haplotypes. The errors define the emission probabilities, giving an estimation of the gene conversion events and recurrent mutations. In order to determine the specific model that best fits the data, crossovers and error parameters have to be estimated. For this purpose, crossovers and errors are updated based on the recombination rates and allele frequencies in consecutive runs of the HMM model. The initial values of the model parameters are set to :math:`\theta_i=0.01; \, \varepsilon_j=0.00000001`, but other parameters such as number of haplotypes in the template or number of runs have to be set by the user (see HMMParameters option).

The first numerical parameter of ``HMMParameters`` is the number of gametes used to create the haplotype template. Imputation accuracy is highly influenced by this parameter, and better results are obtained when larger templates are used. However, the computational time grows quadratically with the number of haplotypes. This can be partially solved by increasing the number of parallel processes, which is controlled by the last parameter in this section.

The second numerical parameter sets the number of rounds dismissed before the parameters of the HMM model have stabilised. ``10`` is a good value for this parameter.

The third numerical parameter is the total number of rounds that the HMM will be computed. A greater number of rounds lead to better results. However, the user is discouraged from using more than 50 rounds, as imputation accuracy tends to be only slightly better than when a lesser number of rounds are used.

The last numerical parameter controls the number of parallel processes used to complete the genotype imputation. Valid values are integer greater than ``0``. Each processor is responsible for computing the HMM model for a single individual. Setting this parameter to ``1`` will compute the HMM imputation in serial.

TrueGenotypeFile
""""""""""""""""
If you want to test the program ``TrueGenotypeFile``, gives the name of the file containing the true genotypes. For example this file could contain the true genotypes of a set of animals that have a proportion of their genotypes masked. If no such file is available you can set the parameter to ``None``. Testing the program can be useful when applying the program to a new population, perhaps the user should mask some SNP in a small percentage of the animals and see how it performs imputing them!::

  = BOX 1: Input Files ================================================================
  PedigreeFile                        ,MyPedrigree.txt
  GenotypeFile                        ,MyGenos.txt
  TrueGenotypeFile                    ,MyTrueGenos.txt
  = BOX 2: Sex Chromosome =============================================================
  SexChrom                            ,No
  = BOX 3: SNPs =======================================================================
  NumberSnp                           ,1000
  MultipleHDPanels                    ,0
  HDAnimalsThreshold                  ,90.0
  = BOX 4: Internal Editing ===========================================================
  InternalEdit                        ,Yes
  EditingParameters                   ,95.0,2.0,98.0,EditedSnpOut
  = BOX 5: Phasing ====================================================================
  NumberPhasingRuns                   ,PhaseDone,"/Users/john/Proj/Test/PhaseOld/",20
  CoreAndTailLengths                  ,200,300,400,500,600,250,325,410,290,700
  CoreLengths                         ,100,200,300,400,500,150,225,310,190,600
  PedigreeFreePhasing                 ,No
  GenotypeError                       ,0.0
  NumberOfProcessorsAvailable         ,20
  = BOX 6: Imputation =================================================================
  InternalIterations                  ,3
  ConservativeHaplotypeLibraryUse     ,No
  WellPhasedThreshold                 ,99.0
  = BOX 7: Hidden Markov Model ========================================================
  HMMOption                           ,No
  TemplateHaplotypes                  ,200
  BurnInRounds                        ,5
  Rounds                              ,20
  ParallelProcessors                  ,8,
  Seed                                ,-123456789
  ThresholdForPhasedAnimals           ,90.0
  ThresholdImputed                    ,90.0
  WindowLength                        ,150
  = BOX 8: Running options ============================================================
  PreprocessDataOnly                  ,No
  PhasingOnly                         ,No
  UserDefinedAlphaPhaseAnimalsFile    ,None
  PrePhasedFile                       ,None
  BypassGeneProb                      ,No
  RestartOption                       ,2

Advice on values for parameters
-------------------------------

For a data set comprised of 10,000 animals, of which 3000 animals are genotyped for 3129 SNP (on chromosome 1, thus equivalent to 50k density) and 1000 animals are genotyped for (180 SNP on chromosome 1, thus equivalent to some low density chip) a good way to proceed would be with the parameters outlined in figure 1. However a full example of how to apply the program to a real data set is given below in the examples.

Data format
-----------
The program generally requires two input files, a pedigree file and a genotype file.

Pedigree file
^^^^^^^^^^^^^

The pedigree file should have three columns, individual, father, and mother. It should be separated with space or comma with for missing parents coded as 0. No header line should be included in the pedigree file. Both numeric and alphanumeric formats are acceptable. The pedigree does not have to be sorted in any way as the program automatically does this.

Genotype file
^^^^^^^^^^^^^

The genotype information should be contained in a single file containing 1 line for each individual. The first column of this file should contain the individual’s identifier with numeric and alphanumeric formats being acceptable. The next columns should contain the SNP information with a single column for each SNP where the genotypes are coded as ``0``, ``1``, or ``2`` and missing genotypes are coded as another integer between ``3`` and ``9`` (e.g. ``3``), with ``0`` being homozygous ``aa``, ``1`` being heterozygous ``aA`` or ``Aa``, and ``2`` being homozygous ``AA``. The genotype file should not have a header line.

Output
------
The output of |ai| is organised into a number of sub folders (``Results and Miscellaneous``, and in the case of when a true genotype data file is supplied ``TestAlphaImpute``). A description of what is contained within these folders is given below.

Results
^^^^^^^

The folder ``Results`` contains four files.

Genotype data
"""""""""""""

``ImputeGenotypeProbabilities.txt`` is the primary genotype output file. It contains, for each SNP and each animal in the pedigree, a real number, the genotype probability, which is the sum of the two allele probabilities (i.e. the genotype) at that locus. Therefore genotypes are coded as real numbers between 0 and 2. The first column is the Animal Id, with the subsequent columns being for each SNP. 

``ImputeGenotypes.txt`` is the secondary genotype output file. It contains a genotype for each SNP and each animal in the pedigree where it was possible to match it to a haplotype or was already genotyped. SNP that could not be matched or were not genotyped are denoted as being missing by a 9 (in the previous file these missing values were replaced with genotype probabilities). The first column is the Animal Id, with the subsequent columns being for each SNP.

Phased data
"""""""""""

``ImputePhaseProbabilities.txt`` is the primary output file containing phased data. It contains an allele probability for each of the two alleles of each SNP and each animal in the pedigree. The first column is the Animal Id, with the subsequent columns being for each SNP. Each animal has two rows, with the first of these being for the paternal gamete and the second being for the maternal gamete. Alleles are coded as real numbers between 0 and 1 (i.e. probability of allele being a 1).

``ImputePhase.txt`` is the secondary output file containing phased data. It contains an allele for each of the two alleles of each SNP and each animal in the pedigree where it was possible to match it to a haplotype. Alleles that could not be matched these are denoted by a 9 as being missing. The first column is the Animal Id, with the subsequent columns being for each SNP. Each animal has two rows, with the first of these being for the paternal gamete and the second being for the maternal gamete. Alleles are coded as integers either 0 or 1 with missing alleles set to 9 (in the previous file these missing values were replaced with allele probabilities).

Miscellaneous
"""""""""""""

``Miscellaneous`` contains files that summarise the editing of the data. ``EditingSnpSummary.txt`` contains three columns, the first being the sequential number of the SNP, the second being the count of animals that are missing each SNP in the high-density set, and the third being an indicator of whether the SNP was included in the analysis or not (``1`` = included / ``0`` = excluded). ``Timer.txt`` contains the time takes to complete the task.

TestAlphaImpute
"""""""""""""""

``TestAlphaImpute`` is only invoked if a ``TrueGenotypeFile`` is supplied. The resulting folder contains four files.

``IndividualAnimalAccuracy.txt`` contains a row for each animal in the test file. The first column is the animals ID, the second a classifier as to what genotyping status its ancestors had ``1`` being both parents genotyped, ``2`` being sire and maternal grandsire genotyped, ``3`` being dam and paternal grandsire genotyped, ``4`` being sire genotyped, ``5`` being dam genotyped, and ``6`` being any other scenario. An ancestor is considered genotyped if it was genotyped for more than 50% of the SNP. The next columns are for each of the SNP, with ``1`` if the SNP is correctly imputed, ``2`` the SNP is incorrectly imputed, ``3`` if the SNP is not imputed, and ``4`` if the SNP was already genotyped.

``IndividualSummaryAccuracy.txt`` summarises the information in ``IndividualAnimalAccuracy.txt``. Columns 1 and 2 are the same as the previous file, column 3 is the percentage of SNP to be imputed that were imputed correctly for this animal, column 4 is the percentage imputed incorrectly, column 5 is the percentage not imputed, column 6 is the percentage of paternal alleles that were imputed or phased, and column 7 is the percentage of maternal alleles that were imputed or phased.

``IndividualSummaryYield.txt`` summarises the yield in terms of the percentage of paternal/maternal alleles that have been imputed or phased for all animals in the pedigree. Column 1 is the ID, column 2 is an indicator as to whether it was genotyped for more than 50% of the SNP or not (``1`` = was genotyped, ``0`` = was not genotyped), column 3 is the percentage of paternal alleles imputed or phased, column 4 is the percentage of maternal alleles imputed or phased.

Offset/NotOffset mode
=====================

AlphaPhase1.1 can be run in an *Offset* mode or a *NotOffset* mode. The *NotOffset* mode means that the cores start at the first SNP. The *Offset* mode is designed to create overlaps between cores therefore the start of the first core is shifted 50% of its length (i.e. if the core length is 100, then the first core starts at SNP 51). First running the program in *NotOffset* phases several cores, then running the program in *Offset* mode moves the start of the cores to halfway along the first core, thereby creating 50% overlaps between cores for the *NotOffset* mode and the *Offset* mode.

Examples
========

In the download there is a directory called ``Examples``. In ``Examples`` the example outlined here is contained.

The data is from a Pig population (courtesy of PIC). It comprises a pedigree of 6473 animals in the file ``RecodedPicPedigree.txt``. The genotypes are in the file ``PicGenotypeFile.txt`` and comprise 3509 animals, of which 3209 were genotyped for all 3129 SNP and a further 300 were genotyped for a subset of the SNP. The genotyped SNP are coded as ``0``, ``1``, ``2`` and the missing SNP as ``9``. ``PicTrueGenotypeFile.txt`` is a file containing the unmasked genotypes for the animals genotyped for the subset of SNP. This can be used as the ``TrueGenotypeFile`` in the examples that test the program.

Four example scenarios are given.

#. Run the program to impute genotype.
#. Run the program to first pre-process the data and then run it by reading in previously phased data.
#. Run the program to impute genotypes and test the imputation accuracy.
#. Run the program to impute genotypes and test the imputation accuracy on a sex chromosome.

.. warning:: Beginners should focus on Example 2

Example 1. How to run the program to impute genotypes
-----------------------------------------------------

We call this Example 1 and it is store in the directory Example/Example1 of the download. This example shows how you would run the program to do imputation in the pedigree described above. The folder contains ``AlphaImputeSpec.txt`` which has suitable parameters set to achieve the goal.

  = BOX 1: Input Files ================================================================
  PedigreeFile                        ,Pedrigree.txt
  GenotypeFile                        ,Genos.txt
  TrueGenotypeFile                    ,TrueGenos.txt
  = BOX 2: Sex Chromosome =============================================================
  SexChrom                            ,No
  = BOX 3: SNPs =======================================================================
  NumberSnp                           ,1000
  MultipleHDPanels                    ,0
  HDAnimalsThreshold                  ,90.0
  = BOX 4: Internal Editing ===========================================================
  InternalEdit                        ,Yes
  EditingParameters                   ,95.0,2.0,98.0,EditedSnpOut
  = BOX 5: Phasing ====================================================================
  NumberPhasingRuns                   ,10
  CoreAndTailLengths                  ,200,300,400,500,600,250,325,410,290,700
  CoreLengths                         ,100,200,300,400,500,150,225,310,190,600
  PedigreeFreePhasing                 ,No
  GenotypeError                       ,0.0
  NumberOfProcessorsAvailable         ,20
  = BOX 6: Imputation =================================================================
  InternalIterations                  ,3
  ConservativeHaplotypeLibraryUse     ,No
  WellPhasedThreshold                 ,99.0
  = BOX 7: Hidden Markov Model ========================================================
  HMMOption                           ,No
  TemplateHaplotypes                  ,200
  BurnInRounds                        ,5
  Rounds                              ,20
  ParallelProcessors                  ,8,
  Seed                                ,-123456789
  ThresholdForPhasedAnimals           ,90.0
  ThresholdImputed                    ,90.0
  WindowLength                        ,150
  = BOX 8: Running options ============================================================
  PreprocessDataOnly                  ,No
  PhasingOnly                         ,No
  UserDefinedAlphaPhaseAnimalsFile    ,None
  PrePhasedFile                       ,None
  BypassGeneProb                      ,No
  RestartOption                       ,1

The parameters of interest are described below.

``InternalEdit`` is set to ``Yes`` so that the program attempts to edit the data internally using the parameters outlined in ``EditingParameters``. The final group of high density animals are genotyped for more than 98% of the SNP and any SNP, missing in more than 2% of the animals initially defined as being in the high-density group has been removed. The original high-density group were genotyped for more than 95% of the SNP. All of the SNP will be included in the output because the ``AllSnpOut`` qualifier has been set. (Actually this data set has already been edited externally so editing will not change it!)

``NumberPhasingRounds`` is set to ``10`` meaning that 10 pairs of phasing rounds (20 in total because of Offset/NotOffset) are performed by AlphaPhase1.1, on the high-density group of animals. The results of the Phasing rounds are stored in the directory ``Phasing``.

The core and tail lengths varied between 200 and 700, and the tail lengths varied between 100 and 600. The choice of these lengths creates a nice amount of overlap between cores and means that each SNP is phased multiple times as part of the cores spanning different SNP. 

The genotype error percentage is assumed to be very low (i.e. 0%). This is suitable here because the data is very clean, however data sets with less favourable call rates may require this value to be set slightly higher (e.g. 1%). Higher number can slow the program down and reduce the phasing accuracy.

It is assumed that 20 processors are available. This means that all 20 phasing rounds can be run in parallel. If this number was set to ``1`` it would mean they would have to be done in sequence, thus slowing the process dramatically.

The number of internal iterations has been set to ``3``.

No true genotype is supplied hence this parameter is set to ``None``.

Example 2. How to run the program to first pre-process the data and then run it by reading in previously phased data
--------------------------------------------------------------------------------------------------------------------

Phasing can be a very computationally expensive task. However with appropriate tuning of the parameters for AlphaPhase1.1 considerable reductions can be achieved. Therefore until the user is familiar with their data set and the phasing parameters that are useful it is probably better to first run |ai| with the ``PreprocessDataOnly`` set to ``Yes``, which prepares the data files and directory structure needed for AlphaPhase1.1, next the user can run the AlphaPhase1.1 rounds directly while tuning the parameters for the different rounds to ensure a high yield in terms of the percentage of alleles phased coupled with short computational times. Once the phasing rounds are completed the user can re-run |ai| with the ``PreprocessDataOnly`` set to ``No`` and the ``NumberPhasingRounds`` set to ``PhaseDone``.

A full worked example of this is given in the directory Examples/Example2 of the download. The folder contains ``AlphaImputeSpec.txt`` which is completely empty but will be filled appropriately as we proceed.

To perform the first run of the program the contents of ``Run1AlphaImputeSpec.txt`` should be copied into ``AlphaImputeSpec.txt``. This set of parameters is exactly the same as the set of parameters used to run Example1 with one difference, the ``PreprocessDataOnly`` is set to ``Yes``. This causes the program to edit the data and set up the data sets and folder structure required to run the program. Then the program stops.

The next thing that must be done is that the directory ``Phasing`` should be renamed to something like ``PhasingByHand``. In this directory 20 subdirectories have been created (2 directories for each of the 10 pairs of Phasing rounds). In these directories a parameter file for controlling AlphaPhase1.1 called ``AlphaPhaseSpec.txt`` has been placed. This contains the parameters that control the phasing. Each of the phasing rounds should now be run by the user, who can then tweak the parameters of the ``AlphaPhaseSpec.txt`` files as appropriate to ensure a good phasing yield in a short amount of time.

Once the phasing rounds have been finished |ai| can be rerun. The parameters to do this are in ``Run2AlphaImputeSpec.txt`` and these can now be copied into ``AlphaImputeSpec.txt`` in place of the previously parameters.

Example 3. How to run the program to impute genotypes and test the imputation accuracy
--------------------------------------------------------------------------------------

Run the program in pre-processing mode with the parameters shown here::

  = BOX 1: Input Files ================================================================
  PedigreeFile                        ,Pedrigree.txt
  GenotypeFile                        ,Genos.txt
  TrueGenotypeFile                    ,TrueGenos.txt
  = BOX 2: Sex Chromosome =============================================================
  SexChrom                            ,No
  = BOX 3: SNPs =======================================================================
  NumberSnp                           ,1000
  MultipleHDPanels                    ,0
  HDAnimalsThreshold                  ,90.0
  = BOX 4: Internal Editing ===========================================================
  InternalEdit                        ,Yes
  EditingParameters                   ,95.0,2.0,98.0,EditedSnpOut
  = BOX 5: Phasing ====================================================================
  NumberPhasingRuns                   ,PhaseDone,"PhaseOld/",20
  CoreAndTailLengths                  ,200,300,400,500,600,250,325,410,290,700
  CoreLengths                         ,100,200,300,400,500,150,225,310,190,600
  PedigreeFreePhasing                 ,No
  GenotypeError                       ,0.0
  NumberOfProcessorsAvailable         ,20
  = BOX 6: Imputation =================================================================
  InternalIterations                  ,3
  ConservativeHaplotypeLibraryUse     ,No
  WellPhasedThreshold                 ,99.0
  = BOX 7: Hidden Markov Model ========================================================
  HMMOption                           ,No
  TemplateHaplotypes                  ,200
  BurnInRounds                        ,5
  Rounds                              ,20
  ParallelProcessors                  ,8,
  Seed                                ,-123456789
  ThresholdForPhasedAnimals           ,90.0
  ThresholdImputed                    ,90.0
  WindowLength                        ,150
  = BOX 8: Running options ============================================================
  PreprocessDataOnly                  ,No
  PhasingOnly                         ,No
  UserDefinedAlphaPhaseAnimalsFile    ,None
  PrePhasedFile                       ,None
  BypassGeneProb                      ,No
  RestartOption                       ,1

Rename the ``Phase`` folder to ``PhaseOld`` and then rerun the program with the pre-processing turned off as shown below::

  = BOX 1: Input Files ================================================================
  PedigreeFile                        ,Pedrigree.txt
  GenotypeFile                        ,Genos.txt
  TrueGenotypeFile                    ,TrueGenos.txt
  = BOX 2: Sex Chromosome =============================================================
  SexChrom                            ,No
  = BOX 3: SNPs =======================================================================
  NumberSnp                           ,1000
  MultipleHDPanels                    ,0
  HDAnimalsThreshold                  ,90.0
  = BOX 4: Internal Editing ===========================================================
  InternalEdit                        ,Yes
  EditingParameters                   ,95.0,2.0,98.0,EditedSnpOut
  = BOX 5: Phasing ====================================================================
  NumberPhasingRuns                   ,PhaseDone,"PhaseOld/",20
  CoreAndTailLengths                  ,200,300,400,500,600,250,325,410,290,700
  CoreLengths                         ,100,200,300,400,500,150,225,310,190,600
  PedigreeFreePhasing                 ,No
  GenotypeError                       ,0.0
  NumberOfProcessorsAvailable         ,20
  = BOX 6: Imputation =================================================================
  InternalIterations                  ,3
  ConservativeHaplotypeLibraryUse     ,No
  WellPhasedThreshold                 ,99.0
  = BOX 7: Hidden Markov Model ========================================================
  HMMOption                           ,No
  TemplateHaplotypes                  ,200
  BurnInRounds                        ,5
  Rounds                              ,20
  ParallelProcessors                  ,8,
  Seed                                ,-123456789
  ThresholdForPhasedAnimals           ,90.0
  ThresholdImputed                    ,90.0
  WindowLength                        ,150
  = BOX 8: Running options ============================================================
  PreprocessDataOnly                  ,No
  PhasingOnly                         ,No
  UserDefinedAlphaPhaseAnimalsFile    ,None
  PrePhasedFile                       ,None
  BypassGeneProb                      ,No
  RestartOption                       ,2

Note that ``NumberPhasingRuns`` has now got the full path and that the number of phasing rounds is 20 instead of the 10 (to account for the ``Offset``/``NotOffest``).

For this data set 10 Phasing rounds were done (effectively 20 as each of the 10 is in fact a pair of 2). The ``CoreLengths`` ranged from 100 SNP to 700 SNP in length while the ``CoreAndTailLengths`` ranged from 200 to 800 SNP in length. Shorter cores and tails would have increased the computational time considerably as would have increasing the ``GenotypeErrorPercenatage`` above the value of 0.05% used. The ``EditingParameters`` ensured that the final high-density data set was genotyped for more than 98% of the SNP and that all SNP were outputted.


Example 4. How to run the program to impute genotypes and test the imputation accuracy on a sex chromosome
----------------------------------------------------------------------------------------------------------

Contact `John.Hickey@roslin.ed.ac.uk <John.Hickey@roslin.ed.ac.uk>`_

An extensive example file is downloadable from the `AlphaGenes <http://www.alphagenes.roslin.ed.ac.uk/software-packages/alphaimpute/>`_ website.

The example comprises the PIC data set described in Hickey *et al*. 2012 [1]_. It consists of a pedigree of 6473 animals, of which 3209 are genotyped for almost all of the 3129 SNP (50k density) and 300 animals (at the end of the pedigree) are genotyped for a subset of XXX of the SNP (Xk density).

Background reading
==================
.. [1] Hickey, J. M., Kinghorn, B. P., Tier, B., van der Werf, J. HJ. and Cleveland, M. A. (2012) `A phasing and imputation method for pedigreed populations that results in a single-stage genomic evaluation <http://www.gsejournal.org/content/44/1/9>`_. Genetics Selection Evolution 44:9

.. [2] Hickey, J. M., Kinghorn, B. P., Tier, B., Wilson, J. F., Dunstan, N. and van der Werf, J. HJ. (2011) `A combined long-range phasing and long haplotype imputation method to impute phase for SNP genotypes <http://www.gsejournal.org/content/43/1/12>`_. Genetics Selection Evolution 43:12

.. [3] Kerr, R. J. and Kinghorn, B. P., (1996). `An efficient algorithm for segregation analysis in large populations <http://onlinelibrary.wiley.com/doi/10.1111/j.1439-0388.1996.tb00636.x/abstract>`_. Journal of Animal Breeding and Genetics 113: 457-469

.. [4] Hickey, J. M., Crossa, J., Babu, R. and de los Campos, G. (2011) `Factors Affecting the Accuracy of Genotype Imputation in Populations from Several Maize Breeding Programs <https://www.crops.org/publications/cs/abstracts/52/2/654>`_. Crop Science 52(2): 654-663

.. [5] Li, Y., Willer, C.J., Ding, J., Scheet, P., Abecasis, G.R. (2010). `MaCH: using sequence and genotype data to estimate haplotypes and unobserved genotypes <http://onlinelibrary.wiley.com/doi/10.1002/gepi.20533/full>`_. Genetic Epidemiology 34(8): 816-834.

.. [6] Marchini, J. and Howie, B. (2010). `Genotype imputation for genome-wide association studies <http://www.nature.com/nrg/journal/v11/n7/full/nrg2796.html>`_. Nature Reviews Genetics 11: 499-511. Also see `Supplementary table S2: Comparison of imputation methods <http://www.nature.com/nrg/journal/v11/n7/extref/nrg2796-s2.xls>`_ and `Supplementary S3: Imputation information measures <http://www.nature.com/nrg/journal/v11/n7/extref/nrg2796-s3.pdf>`_.


.. #. Hickey, J.M., Kinghorn, B. P. and van der Werf, J.H.J. Long range phasing and haplotype imputation for improved genomic selection calibrations. Statistical Genetics of Livestock for thePost-Genomic Era. University of Wisconsin - Madison, USA May 4-6, 2009

.. #. Hickey, J.M., Kinghorn, B.P., Tier, B., and van der Werf, J.H.J. (2009) Phasing of SNP data by combined recursive long range phasing and long range haplotype imputation. Proceedings of AAABG. Pages 72 – 75.

.. #. Kinghorn, B.P., Hickey, J.M., and van der Werf, J.H.J. (2009) A recursive algorithm for long range phasing of SNP genotypes. Proceedings of AAABG. Pages 76 – 79.

.. #. Hickey, J.M., Kinghorn, B.P., Cleveland, M., Tier, B. and van der Werf, J.H.J. (2010) Recursive Long Range Phasing And Long Haplotype Library Imputation: Application to Building A Global Haplotype Library for Holstein cattle. (Accepted at 9 th WCGALP).

.. #. Kinghorn, B.P., Hickey, J.M., and van der Werf, J.H.J. Reciprocal recurrent genomic selection (RRGS) for total genetic merit in crossbred individuals. 2010. (Accepted at 9 th WCGALP).

.. #. Hickey, J.M., Kinghorn, B.P., Tier, B., and van der Werf, J.H.J. Determining phase of genotype data by combined recursive long range phasing and long range haplotype imputation. (To be submitted)


.. |ai| replace:: **AlphaImpute1.3**
