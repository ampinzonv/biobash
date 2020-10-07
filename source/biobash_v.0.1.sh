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
#-----------------------------------------------------------------
# COMMON
#-----------------------------------------------------------------
bb_create_tmp_file(){
	local F="/tmp/$RANDOM"
	echo $F
}
function bb_count_fasta_seqs(){
	if [ -z "$1" ] ; then
		echo "
		MODIFIED
		bb_count_fasta_seqs: Counts the number of fasta sequences in a file.
		Usage: bb_count_fasta_seqs [INPUT FILE]
		"			
	fi


	if [ "${1##*.}" = "fasta" ] || [ "${1##*.}" = "fa" ]; then

	   grep -c '>' $1

    fi

	if [ "${1##*.}" = "fastq" ] || [ "${1##*.}" = "fq" ]; then

	   x=$(grep -c '>' $1) 
	   echo $x/4 | bc -l
	  
    else
		echo "ERROR: Unable to process input file."
		echo "It seems your file is not fasta (.fasta, .fa) or fatsq (.fastq, .fq) file."
	fi

	
	
}
bb_count_residues(){
	#This function is  called by bb_get_GC_content!!!!!!
	if [ -z "$1" ] ; then
		echo "
		bb_count_residues: counts the number of residues in a file, without taking into account
		fasta headers.
		Usage: bb_count_residues [INPUT FILE]
		"
	fi
	# first colum is obtained from result, otherwise an space appears at left.
	cat $1 | sed -e '/^>/d' | tr -d '\n' | wc -m | awk '{print $1}'
	
}
#Usually this function would remove all windows characters from end of line...
#not sure about it, maybe get it out or create a more robust one.
bb_dos2unix () {
	if [ -z "$1" ] ; then
		echo "
		bb_dos2unix: removes windows characters from end of line.
		Usage: bb_dos2unix [INPUT FILE]
		"
	fi
		cat $1 | col -b
}
#Comments: this can be helpful,Extracts from line 5 to 10 in input.txt file: sed -n '5,10 p' input.txt
function bb_extract_fasta_entry() {
	
	
	if [ -z "$2" ] ; then
		echo "
		bb_extract_fasta_entry: Extracts a single fasta sequence from a multiple fasta file.
		Usage: bb_extract_fasta_entry [INPUT FILE] [SEQUENCE ID]
		"
	fi
		
	#anchor finds the row number of the sequence to extract, it comes in the form:
	#line_number:fasta_header
	#120:>Prodigal Gene 2 # 2901 # 3311 # 1 is extracted with "cut"	
	header=$(grep -nw $2 $1)
	
	if [ -z "$header" ]; then
			
	 		echo "Pattern not found. Leaving process."
		 		
	fi
		 	
	anchor=$(echo "$header" | cut -d ':' -f1)
	
	#restore fasta header, taking out the line number and dots.
	header=$(echo "$header" | sed -e 's/'$anchor'://')
 	
	#It is necessary to sum 1 to anchor because when evaluated if ">" is present
	#there will be no output, since anchor has the ">" character
	anchor=$((anchor+1))
	
	echo "$header"
	sed -n "$anchor"',$p' $1 | 
	while read line; do
		
		#read/buffer until you find a ">" character
		#if regexp present then isNewSeq = 1
	 	isNewSeq=$(echo "$line" | grep -c '>')
	 	if [ $isNewSeq -lt 1 ]; then
	 		echo "$line"
		 		
	 	else
	 		exit
	 	fi
	done 
}
function bb_get_fasta_headers(){
	if [ -z "$1" ] ; then
		echo "
		bb_get_fasta_headers: ouputs a list of all fasta headers in a file.
		Usage: bb_get_fasta_headers [INPUT FILE]
		"
	fi
	grep '>' $1  | sed -e 's/>//'
	
}
function bb_get_freq_from_list(){
	if [ -z "$1" ] ; then
		echo "
		bb_get_freq_from_list: given a one column list of items, this function outputs
		three columns: Col1 frequency of item, Col2 Relative percentage, Col3 the item itself.
		Usage: bb_get_freq_from_list [INPUT FILE]
		"
	fi
	
	FILE=$(bb_create_tmp_file)
	FILE2=$(bb_create_tmp_file)
	cat $1 | sort | uniq -c > $FILE
	numCat=$(wc -l $1 | awk '{print $1}') #number of items in list
	while read line
		do	
			#get first colum: frequency. At this point each row in FILE variable looks like:
			#    2 A
			#So we will get the first column (2) and second one (A),
			freq=$(echo $line | awk '{print $1}') 
			freq=$(echo $freq "	") #put a tab after the column
			col2=$(echo $line | cut -d " " -f2-) #get everything from second column on.
			#More on the "scale" special variable and other bc stuff:
			#https://www.gnu.org/software/bc/manual/html_mono/bc.html
			perc=$(echo "scale=2;($freq*100)/$numCat" | bc -l)
			perc=$(echo $perc "	")
			echo "$freq" "$perc" "$col2" >> $FILE2
	
	done < $FILE
	sort -gr $FILE2 #gr numerical sort in reverse order.

}
function bb_get_GC_content(){
	
	if [ -z "$1" ] ; then
		echo "
		bb_get_GC_content: gets the GC percentage of a file.
		Usage: bb_get_GC_content [INPT FILE]
		"
	fi
	isMultiple=$(grep -c '>' $1)
	if [ "$isMultiple" -gt "1" ] ; then
		echo "This is a multiple fasta file. You need a single fasta file."
		exit
	fi
	numResidues=$(bb_count_residues $1)
	g=$(cat $1 | sed -e '/^>/d' | tr -d '\n' | grep -oi 'G' | wc -l | awk '{print $1}')
	c=$(cat $1 | sed -e '/^>/d' | tr -d '\n' | grep -oi 'C' | wc -l | awk '{print $1}')
	perc=$(echo "(($g+$c)*100)/$numResidues" | bc)
	echo "$perc"
	#brute force algorithm above, can be improved using AWK's split function:
	#http://stackoverflow.com/questions/8009664/split-string-to-array-using-awk
	#or with the following code corrected (take out end of line chars)
	#noHead=$(bb_remove_fasta_header $1)
	#nonAT=$(echo "$noHead" | tr -d 'AaTt\n')
	#echo "$nonAT"
	#echo "$nonAT" | wc -m
		
	
}
function bb_get_nr_list(){
	if [ -z "$1" ] ; then
		echo "
		bb_get_nr_list: Given a one colum file with a  list of items, this function outputs a
		new version of the list where redundant items are removed from the list. This means that
		if the file has the items: A, B, A, B, D, C and D. The output will be: A, B, C and D (in
		one column format).
		Usage: bb_get_nr_list [INPUT FILE]
		"
	fi
	
	FILEA=$(bb_create_tmp_file)
	FILEB=$(bb_create_tmp_file)
	FILEC=$(bb_create_tmp_file)
	
	cat $1 | sort  > $FILEA
	uniq -u $FILEA > $FILEB
	uniq -d $FILEA > $FILEC
	cat $FILEB $FILEC | sort
	
}
function bb_remove_empty_lines(){
	if [ -z "$1" ] ; then
		 echo "
		 bb_remove_empty_lines: removes empty lines from a file.
		 Usage: bb_remove_empty_lines [INPUT FILE]
		 "
	fi
		sed '/^$/d' $1

}
function bb_remove_fasta_header(){
	if [ -z "$1" ] ; then
		echo "
		bb_remove_fasta_header: removes all fasta headers from a multipe o single fasta file. Useful to concatenate a multiple fasta file.
		If you want to create a list of all fasta headers in a file use: bb_get_fasta_headers.
		Usage: bb_remove_fasta_headers [INPUT FILE]
		"
	fi
		sed '/>/d' $1

}
