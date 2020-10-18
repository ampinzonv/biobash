## BIOBASH Vb0.1

BIOBASH is a set of BASH scripts useful for common bioinformatics related tasks.
It was born by our group's necessity on performing simple rutinary tasks while working
on bioinformatics data analysis.
Therefore, these scripts cover different tasks that are not all necessarily "bioinformatics" tasks,
but "bioinformatics-related" tasks, such as data manipulation, data filtering and organization etc.

This project started as a weekend exercises in 2015 and then was kind of abandoned for several years (although the scripts developed
have shown to be useful during these years also!!!) and now we are re-taking this project and seeing how far it goes.

As for this release there are these routines:


### FASTA ANALYSIS AND MANIPULATION
* bb_count_seqs
* bb_extract_fasta_entry
* bb_get_fasta_headers
* bb_remove_fasta_header
* bb_count_residues
* bb_get_GC_content
* bb_fastq2fasta

### LISTS AND GENERAL FILE MANIPULATION
* bb_dos2unix
* bb_get_freq_from_list
* bb_get_nr_list
* bb_remove_empty_lines

By default calling any script without arguments will show help menu.

### INSTALLATION (and UNISTALLATION)
Just run the "installbiobash" script in the top folder of this release.
BY default it attempts to install all scripts in /usr/local/bin, but you can
change this install directory during the installation process.
In order to avoid any conflict between BB scripts and other tools installed
in your systems, all scripts in BB begin with the "bb_" prefix, so if you
want to know whcih BB scripts are installed in your system just type "bb_" in your shell
and hit  the "<TAB>" key.
To uninstall BB, just run the command: bb_uninstall_biobash




