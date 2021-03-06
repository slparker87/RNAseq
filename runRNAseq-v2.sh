#!/bin/bash

###################################################
#       RNAseq analysis pipeline                  #
#       Michelle Percharde, PhD 2017              #
#          Copyright M Percharde2017              #
#                v.mm9                            #
###################################################

#~~~~~~~~~~EDIT BELOW THIS LINE ~~~~~~~~~~~~~~~~~~#

# Pipeline to take input dir with files "sample.fq" or "sample.fq.gz", outputs sorted bams
# Bam files can then be DLed and fed into FeatureCounts in R

#usage: ./runRNAseq0mm9E.sh [options] [-i path/to/folder/]

#FOLDERS NEEDED IN ROOT:
  #raw/ (where raw files are)

# echo "indexing the transcriptome data one time - prefix mm9" ###DO THIS FIRST TIME - run in ref folder ###
  # tophat -G /data/refs/mm9/mm9.gtf --transcriptome-index=transcriptome_data/known_genes mm9
  # tophat -G mm9.gtf --transcriptome-index=transcriptome_data/known_genes mm9 **note 10/10/17 installed latest tophat and bowtie2 w/ conda**

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

flagcheck=0

while getopts ':gchi:' flag; do
    case ${flag} in
      i) dir=$OPTARG
        flagcheck=1 ;;
        g) gz='true' ;;
        c) clontech='true' ;;
        h) echo ""
           echo "Usage: $0 [-h] [-g] [-c] [-i <path/to/files/>]"
           echo ""
           echo "    -h        Help mode, prints Usage"
           echo "    -g        Input FASTQ is .gz compressed"
           echo "    -c        Libraries are CLONTECH"
           echo "    -i        input file directory/. use "./" for current dir (not recommended)"
           echo ""
           flagcheck=1
           exit 1 ;;
        \?)
          echo ""
          echo "Invalid option, type -h for help"
          echo ""
          flagcheck=1
          exit 1 ;;
    esac
done

if [ "$flagcheck" == 0 ] ; then
  echo ""
  echo "Incorrect or no -i specified, please read help -h and try again!"
  echo ""
  exit 1
fi

if [ "$gz" == "true" ]; then
  echo ""
  echo "your file is compressed, trim and align will be run on .gz files"
fi

mkdir -p trimmed/fastqc/
mkdir -p sorted_bam/

for file in "$dir"* ; do
    echo ""
    if [ "$gz" == "true" ]; then
      name=$(basename $file .fq.gz)
      trimfile=${name}_trimmed.fq.gz
    else
      name=$(basename $file .fq)
      trimfile=${name}_trimmed.fq
    fi
    echo "analysing file: $name, trimmed will be $trimfile"

    if [ "$clontech" == "true" ]; then
      echo ""
      echo "$name is a clontech library, adaptor trimming will include clipping 3bp"
      echo ""
      trim="trim_galore --clip_R 3"
    else
      echo ""
      echo "$name is an nebnext library"
      echo ""
      trim="trim_galore"
    fi

    echo "1. trimming $name"
    echo ""
    $trim --fastqc --fastqc_args " --outdir trimmed/fastqc/" --illumina $file -o trimmed/

    echo ""
    echo "2. aligning $name to mm9 standard"
    echo ""
    mkdir -p ${name}_aligned/
    tophat -o ${name}_aligned/ -p 4 -g 20 --no-coverage-search --library-type fr-firststrand \
    --no-novel-indels --transcriptome-index=/data/refs/mm9/transcriptome_data/known_genes /data/refs/mm9/mm9 trimmed/$trimfile
    # tophat -o ${name}_aligned/ -p 4 -g 20 -G /data/refs/mm9/mm9.gtf --no-coverage-search --library-type fr-firststrand \
    # --no-novel-indels /data/refs/mm9/mm9 trimmed/$trimfile

    echo ""
    echo "3. sorting $name bam file ready for DL"
    echo ""
    samtools sort -o sorted_bam/${name}.sorted.bam ${name}_aligned/accepted_hits.bam
    echo "cleaning up: non-sorted file"
    rm ${name}_aligned/accepted_hits.bam
    echo ""
    echo "$name DONE!"
    echo ""
done
