#!/bin/bash

START=$(pwd)

for d in `ls -d */`; do
  cd $d
  ./run.sh | tee output.txt
  cd $START
done

