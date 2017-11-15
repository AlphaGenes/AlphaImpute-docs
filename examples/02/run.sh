#!/bin/bash
#$ -cwd
#$ -j y
#$ -N AlphaImpute02

rm -rf Phasing_1
../../AlphaImpute Spec_1.txt && mv Phasing Phasing_1 && ../../AlphaImpute Spec_2.txt

echo '====================================================================='
echo '===                                                               ==='
echo '===         And now for something completely different!           ==='
echo '===       Trying a slight modification of spec file, see number   ==='
echo '===       of phasing runs.                                        ==='
echo '===                                                               ==='
echo '====================================================================='

rm -rf Phasing_1
../../AlphaImpute Spec_1.txt  && mv Phasing Phasing_1 && ../../AlphaImpute Spec_2b.txt
