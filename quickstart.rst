Quickstart
==========

.. contents::
   :depth: 3

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
  NumberOfProcessorsAvailable         ,20
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
  RestartOption                       ,0

|ai| has to be run in 4 times in order to: 1) compute genotype probabilities; 2) phase animals genotyped at high-density; 3) impute and phase genotype data of all individuals in the population; and 4) summarise results and write the outputs. The four different steps in which |ai| is run are controlled by the option ``RestartOption`` in the ``AlphaImputeSpec.txt`` file (see section :ref:`RestartOption`).

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

The second time |ai| is run, ``RestartOption`` has to be set to ``2``. This causes |ai| to phase the haplotypes of those individuals genotyped at high-density. Phasing is computed across all markers according to the phasing strategies that have been set by parameters ``CoreAndTailLengths`` and ``CoreLengths``. For each core in the spec file, |ai| computes two phasing rounds by running |ap| in ``Offset`` and ``NotOffset`` mode (Hickey *et al*. (2011) [1]_).

|ai| runs the phasing rounds in different parallel processes. It is worth to notice that the number of processors has to be equal to ``NumberOfProcessorsAvailable`` :math:` = 2 \times` ``NumberPhasingRuns``. For each processor, a folder ``Phasing/PhaseX`` is created containing:

* ``AlphaPhaseSpec.txt``: The spec file of parameters.
* ``AlphaPhase``: The executable of |ap|.

|ai| automatically runs |ap| for each ``PhaseX`` folder according to the spec file.

|ap| can phase hundreds of thousands of animals in under a day. To make use of this capability, the option ``LargeDatasets`` has to be set to ``Yes``. In this case, two more parameters are needed (see :ref:`LargeDatasets` section for more information).


Impute genotype data for all individuals
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The third time |ai| is run, ``RestartOption`` has to be set to ``3``. This makes |ai| to impute genotypes for all the individuals in the genotype file. Imputation is based on the phased haplotypes of the individuals genotyped at high-density (`Phase animals gentoyped at HD`_).

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
  NumberOfProcessorsAvailable         ,20
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
  RestartOption                       ,0

|ai| has to be run in 4 times in order to: 1) compute genotype probabilities; 2) phase animals genotyped at high-density; 3) impute and phase genotype data of all individuals in the population; and 4) summarise results and write the outputs. The four different steps in which |ai| is run are controlled by the option ``RestartOption`` in the ``AlphaImputeSpec.txt`` file (see section :ref:`RestartOption`).

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

As before, |ai| split the chromosome into different cores in order to phase the haplotypes of individuals genotyped at high-density in different parallel processes. Phasing is computed across all markers according to the phasing strategies that have been set by parameters ``CoreAndTailLengths`` and ``CoreLengths``. For each core in the spec file, two phasing rounds are computed by running |ap| in ``Offset`` and ``NotOffset`` mode (Hickey *et al*. (2011) [1]_).

It is worth to notice that the number of processors has to be equal to ``NumberOfProcessorsAvailable``:math:` = 2 \times` ``NumberPhasingRuns``. For each processor, a folder ``Phasing/PhaseX`` is created containing:

* ``AlphaPhaseSpec.txt``: The spec file of parameters.
* ``AlphaPhase``: The executable of |ap|.

However, |ai| stops before processing the phasing with the message:

.. warning:: ``Restart option 2 stops program before Phasing has been managed``

and does not run |ap| in the different ``PhaseX`` folders. The user is supposed to do so according to his/her cluster characteristics. The easiest way to run all the GeneProb processes is to create a script file that automatically send them to the system queue.

|ap| can phase hundreds of thousands of animals in under a day. To make use of this capability, the option ``LargeDatasets`` has to be set to ``Yes``. In this case, two more parameters are needed (see :ref:`LargeDatasets` section for more information).

Impute genotype data for all individuals
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The third time |ai| is run, ``RestartOption`` has to be set to ``3``. This causes |ai| to impute genotypes for all the individuals in the genotype file. Imputation is based on the phased haplotypes of the individuals genotyped at high-density (`Phase animals gentoyped at HD for clusters`_).

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

The parameters shown in the spec file above work well for most cases, but the user can set other values (see :ref:`HMMParameters` section for more information about how to set optimal parameters).

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

.. [1] Hickey, J. M., Kinghorn, B. P., Tier, B., Wilson, J. F., Dunstan, N. and van der Werf, J. HJ. (2011) `A combined long-range phasing and long haplotype imputation method to impute phase for SNP genotypes <http://www.gsejournal.org/content/43/1/12>`_. Genetics Selection Evolution 43:12


.. |ai| replace:: **AlphaImpute**
.. |ap| replace:: **AlphaPhase**
