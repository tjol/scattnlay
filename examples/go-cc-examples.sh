#!/bin/bash
path=$PWD
PROGRAM='scattnlay-example.bin'

echo Compile with gcc
rm -f $PROGRAM

file=example-get-Mie.cc
g++ -Ofast -std=c++11 $file ../src/nmie.cc ../src/nmie-applied.cc ./read-spectra.cc -lm -lrt -o $PROGRAM -fno-builtin-calloc -fno-builtin-realloc -fno-builtin-free -march=native -mtune=native -msse4.2

./$PROGRAM
# #result
