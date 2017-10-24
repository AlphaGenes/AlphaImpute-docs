Quickstart
==========

.. contents::
   :depth: 3


As of version 1.9, |ai| exists as a single version, for both *Standard* and *Cluster* systems.  


To run |ai|, just type ``./AlphaImpute`` (linux) or ``AlphaImpute.exe`` (windows) on the console and press *ENTER*. After welcoming the user with this message::

                               ***********************
                               *                     *
                               *     AlphaImpute     *
                               *                     *
                               ***********************

                     Software For Phasing and Imputing Genotypes

                                Commit:   version

   Written by John Hickey, Matt Cleveland, Andreas Kranis, and Brian Kinghorn

|ai| looks for input parameters within the file ``AlphaImputeSpec.txt`` in the same folder the |ai| binary is located. An example of ``AlphaImputeSpec.txt`` is shown here::

  = BOX 1: Input Files ================================================================
  PedigreeFile                        ,Pedrigree.txt
  GenotypeFile                        ,Genos.txt
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
  NumberPhasingRuns                   ,10
  CoreAndTailLengths                  ,200,300,400,500,600,250,325,410,290,700
  CoreLengths                         ,100,200,300,400,500,150,225,310,190,600
  PedigreeFreePhasing                 ,No
  GenotypeError                       ,0.0
  LargeDatasets                       ,No
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
  = BOX 8: Running options ============================================================
  PreprocessDataOnly                  ,No
  PhasingOnly                         ,No
  UserDefinedAlphaPhaseAnimalsFile    ,None
  PrePhasedFile                       ,None
  BypassGeneProb                      ,No
  useferdosi                          ,No
  Cluster                             ,No
  Modelrecomb                         ,Yes
  outputonlygenotypedanimals          ,No
  RestartOption                       ,0

|ai| can be split into two distinct steps: 1)  phase animals genotyped at high-density; 2) impute and phase genotype data of all individuals in the population and summarise results and write the outputs. The two different steps in which |ai| is run are controlled by the option ``RestartOption`` in the ``AlphaImputeSpec.txt`` file (see section :ref:`RestartOption`).

If ``RestartOption`` is set to ``0``, both parts will be run, and there will be no intermediate output, hence the runs will be faster.

Compute Genotype Probabilities
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The first |ai| step, where ``RestartOption`` is set to ``1``. Does the following:


first, |ai| creates the following folders::

  InputFiles/
  Miscellaneous/
  Phasing/
  Results/


Next,  |ai| has to phase the haplotypes of those individuals genotyped at high-density. Phasing is computed across all markers according to the phasing strategies that have been set by parameters ``CoreAndTailLengths`` and ``CoreLengths``. For each core in the spec file, |ai| computes two phasing rounds by running |ap| in ``Offset`` and ``NotOffset`` mode (Hickey *et al*. (2011) [1]_).

|ai| runs the phasing rounds in different parallel processes. For each phasing run, a folder ``Phasing/PhaseX`` is created which will contain the phasing output.

|ap| can phase hundreds of thousands of animals in under a day. To make use of this capability, the option ``LargeDatasets`` has to be set to ``Yes``. In this case, two more parameters are needed (see :ref:`LargeDatasets` section for more information).


Impute genotype data for all individuals
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The second |ai| step, where ``RestartOption`` is set to ``2``, makes |ai| impute genotypes for all the individuals in the genotype file. Imputation is based on the phased haplotypes of the individuals genotyped at high-density (`Phase animals gentoyped at HD`_).

In some situations, imputation thresholds are not met and markers cannot be imputed. To overcome this, |ai| offers two different solutions: 1)to run the heuristic Geneprob algorithm 2) or to apply a hidden Markov model.

By default, the heuristic geneprob algorithm is run every iteration step.

A slower, but potentially more accurate solution is to use a probabalistic HMM to impute the missing genotypes. To use the Markov model after the imputation process, ``HMMOption`` has to be set to ``Yes`` and ``RestartOption`` to ``2``. The hidden Markov model is controlled by the five parameters in option ``HmmParameters``. These five parameters are referred to (in order):

* *number of haplotypes*
* *number of burn-in rounds*
* *number of rounds*
* *number of processors available*
* *seed*

The parameters shown in the example spec file work well for most cases, but the user can set other values (see :ref:`HMMParameters` section for more information about how to set optimal parameters).

Once the hidden Markov model has finished, |ai| outputs the most likely genotypes, genotype dosages and genotype probabilities into different files:

* ``ImputeGenotypes.txt``
* ``ImputeGenotypesHMM.txt``
* ``ImputeGenotypesProbabilities.txt``
* ``GenotypeProbabilities.txt``

|ai| provides similar information for phasing results and allele probabilities:

* ``ImputePhase.txt``
* ``ImputePhaseHMM.txt``
* ``ImputePhaseProbabilities.txt``





.. [1] Hickey, J. M., Kinghorn, B. P., Tier, B., Wilson, J. F., Dunstan, N. and van der Werf, J. HJ. (2011) `A combined long-range phasing and long haplotype imputation method to impute phase for SNP genotypes <http://www.gsejournal.org/content/43/1/12>`_. Genetics Selection Evolution 43:12


.. |ai| replace:: **AlphaImpute**
.. |ap| replace:: **AlphaPhase**
