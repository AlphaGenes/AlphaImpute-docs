#!/bin/bash

START=$(pwd)

for d in `ls -d */`; do
  cd $d
  qsub run.sh
  cd $START
done

