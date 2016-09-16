Introduction
============

|ai| is a software package for imputing and phasing genotype data in populations with pedigree information available. The program uses segregation analysis and haplotype library imputation (**SAHLI**) to impute alleles and genotypes. A complete description of the methods is given in Hickey *et al*., (2012) [1]_. |ai| consists of a single program however it calls both **AlphaPhase** (Hickey *et al*., 2011 [2]_) and **GeneProbForAlphaImpute** (Kerr and Kinghorn, 1996 [3]_). All information on the model of analysis, input files and their layout, is specified in a single parameter file.

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

.. [1] Hickey, J. M., Kinghorn, B. P., Tier, B., van der Werf, J. HJ. and Cleveland, M. A. (2012) `A phasing and imputation method for pedigreed populations that results in a single-stage genomic evaluation <http://www.gsejournal.org/content/44/1/9>`_. Genetics Selection Evolution 44:9

.. [2] Hickey, J. M., Kinghorn, B. P., Tier, B., Wilson, J. F., Dunstan, N. and van der Werf, J. HJ. (2011) `A combined long-range phasing and long haplotype imputation method to impute phase for SNP genotypes <http://www.gsejournal.org/content/43/1/12>`_. Genetics Selection Evolution 43:12

.. [3] Kerr, R. J. and Kinghorn, B. P., (1996). `An efficient algorithm for segregation analysis in large populations <http://onlinelibrary.wiley.com/doi/10.1111/j.1439-0388.1996.tb00636.x/abstract>`_. Journal of Animal Breeding and Genetics 113: 457-469

.. |ai| replace:: **AlphaImpute**
