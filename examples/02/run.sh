#!/bin/bash
#$ -cwd
#$ -j y
#$ -N AlphaImpute01

../../AlphaImpute Spec_1.txt || exit 1
mv Phasing Phasing_0
../../AlphaImpute Spec_2.txt
