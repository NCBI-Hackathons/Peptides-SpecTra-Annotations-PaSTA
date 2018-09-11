#--------------------------------------------------------------------------------------------------------------------------------
#
# File:    SulfenMID_high_precision_human
# Purpose: Given spectra input data files, and a reference datatabase (amino acids in a fasta sequence formated file)
#          Execute the MSGF+ program on all mzML files found in the input spectra directory
#
# Input:   $modsfile <- this contains the post-translational modifications used to expand the possibile matches to database files
#          $file     <- the specific mzML spectra file
#          $database <- the reference amino acid sequence file in fasta format
#
# Output:  $filemzid <- the identified amino acid sequences that match the input spectra file to the reference database
#
# Assumptions:  The $database file has previously had it's suffix array made for it to facilitate searching by the MSGF+ program
#
# Algorithm steps:
#        cd to the $inputsubdir
#        for each file in $subdir matching with ending *.mzML do the following
#          run the program MSGF+
#          with the provided configuration parameters, especially those put in the Mods.txt file
#          output the file in a *.mzid file format.
#
#
# Next steps after:
#   Run the conversion of this file to tsv file format
#
#--------------------------------------------------------------------------------------------------------------------------------
inputsubdir=/home/ubuntu/data/SulfenM/SulfenM_mzML
outputsubdir=/home/ubuntu/data/SulfenMID_high_precision_human
modsfile=$outputsubdir/Mods.txt
database=$outputsubdir/AUP000005640_sp.fasta

echo "$inputsubdir"
echo "$outputsubdir"
echo "$database"
echo "$modsfile"

cd $inputsubdir

for file in *.mzML; do
    # construct the output file format
    
    filemzid=$file.mzid
    
    java -Xmx3500M -jar /home/ubuntu/src/MSGFPlus.jar  \
	 -s $file \
	 -d $database \
	 -t 20ppm \
	 -ti -1,2 \
	 -ntt 2 \
	 -tda 1 \
	 -o   /home/data/SulfenMID_high_precision_human/$filemzid \
	 -mod $modfile
    
done    

