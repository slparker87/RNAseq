###################################################
#       RNAseq analysis pipeline                  #
#       Michelle Percharde, PhD 2016              #
#        michelle.percharde@ucsf.edu              #
#                v1.1                             #
###################################################

#~~~~~~~~~~EDIT BELOW THIS LINE ~~~~~~~~~~~~~~~~~~#

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Script that takes input with name "sample.fq" or "sample.fq.gz" and generates sorted bams
Bam files can then be DLed and fed into FeatureCounts in R

Usage: ./runRNAseq.sh [options] [-i path/to/folder/]

FOLDERS NEEDED IN ROOT:
	raw/ (where raw files are)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Usage: ./runRNAseq2.sh [-h] [-g] [-c] [-i <path/to/files/>]

    -h        Help mode, prints Usage
    -g        Input FASTQ is .gz compressed
    -c        Libraries are CLONTECH
    -i        input file directory/. use ./ for current dir (not recommended)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

KEY NOTES:
1. Remember to make a file where your raw files are kept. Raw files should end .fq or .gz NOT .fastq
2. If your file is compressed as .fq.gz, remember to specify -g
3. If your libraries are clontech, remember to use -c

Good luck!

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~