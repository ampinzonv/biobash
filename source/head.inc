#!/bin/bash
#
# March 13th 2015
#
# BIOBASH(BB) V0.1
# This is a set of functions written in BASH intended to perform common
# analysis in boinformatics. Most of them can also be perform in any 
# high level language such as Python or perl, but the idea behind BB
# is that all this routines can be integrated into the regular bash
# environment and be used as a regular bash function without the need
# of any dependencies beyond regular bash libraries.
# 
# This set of functions are divided into the following categories:
# 
# LIST MANIPULATION
# General manipulation of lists, such as gettin non redundant lists
# counting number of items etc.
#
# FASTA MANIPULATION
# Routines for G/C counting content, headers removal, pattern finding, 
# amongst others.
#
# 
# By default, each routine outputs to STDOUT so it is necessary to redirect
# the output to the desire file, unless you just want to check the results 
# directly on your screen.
#
#  CREDITS
#  BIOBASH is developed by: 
#  Andres Pinzon Ph. D. [ampinzonv@unal.edu.co] 
#  Bioinformatics and Systems Biology Group 
#  Institute for Genetics - National University of Colombia
#  Tel: +57 1 3165000 Ext. 11618
#
#
# TODOs
# Code to separate reads in a fastq file.
# source (https://github.com/Bioinformatics-Support-Unit/bash-scripts)
# sed -n '1~4p' stranded_mix.fastq | grep '/1$'| grep -A 3 --no-group-separator -F -x -f - stranded_mix.fastq > stranded_mix_1.fastq
# sed -n '1~4p' stranded_mix.fastq | grep '/2$'| grep -A 3 --no-group-separator -F -x -f - stranded_mix.fastq > stranded_mix_2.fastq
# 
# code to split a multiple fasta file into single fasta files.
#
# Check the grep part of the bb_get_fasta_entry, perhaps it can be improved using the -f, -f and -x options.
# Change the remove the ELSE in all scripts to simplify, as it was done in bb_dos2unix.
# Get scripts from here: https://github.com/sdwfrost/biobash
# RESOURCES
# http://wiki.bash-hackers.org/doku.php
# https://github.com/lh3/bioawk
#
#
#
