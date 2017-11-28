#!/bin/bash
#$ -cwd
#$ -j y
#$ -N AlphaImpute02

rm -rf Phasing_1
rm -rf Results_1
../../AlphaImpute Spec_1.txt || { echo 'An error occured running AlphaImpute!' ;  exit 1; }

mv Phasing Phasing_1 
mv Results Results_1 

echo 
echo '======================================================================'
echo '===  Now running AlphaImpute with previous phasing information     ==='
echo '======================================================================'
echo 

../../AlphaImpute Spec_2.txt

