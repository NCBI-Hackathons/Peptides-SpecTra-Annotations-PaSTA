#--------------------------------------------------------------------------------------------------------------------------------
#
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
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
PARENT_DIR="$(dirname "$DIR")"

msgf=$PARENT_DIR/software/MSGFPlus/MSGFPlus.jar
mzml=$PARENT_DIR/cptc-xfer.uis.georgetown.edu/publicData/Phase_II_Data/TCGA_Colorectal_Cancer_S_022/TCGA-A6-3807-01A-22_Proteome_VU_20121019/TCGA-A6-3807-01A-22_Proteome_VU_20121019_mzML
fasta_path=$DIR
fasta_target=$DIR/AUP000005640_sp.fasta
fasta_file=`basename $fasta_target`

#Create Decoy database with mimic
$PARENT_DIR/bin/mimic $fasta_target> $fasta_path/Decoy_$fasta_file
fasta_decoy=$fasta_path/Decoy_$fasta_file

modification=~/data/TCGA_CC/Mods.txt
cd $mzml

mkdir $mzml/target
mkdir $mzml/decoy

#BuildSA
java -Xmx4000M -cp $msgf edu.ucsd.msjava.msdbsearch.BuildSA -d $fasta_target -tda 0
java -Xmx4000M -cp $msgf edu.ucsd.msjava.msdbsearch.BuildSA -d $fasta_decoy -tda 0

#Search MS-GF+
for file in *.mzML; do
	filemzid_target=target/$file.mzid
	java -Xmx24000M -jar $msgf \
		-s $file \
		-d $fasta_target \
		-inst 1 \
		-t 10ppm \
		-e 1 \
		-ti 0,1 \
		-ntt 2 \
		-tda 0 \
		-o $filemzid_target \
		-addFeatures 1 \
		-mod $modification \
		-minLength 7

	filemzid_decoy=decoy/$file.mzid
	java -Xmx24000M -jar $msgf \
		-s $file \
		-d $fasta_decoy \
		-inst 1 \
		-t 10ppm \
		-e 1 \
		-ti 0,1 \
		-ntt 2 \
		-tda 0 \
		-o $filemzid_decoy \
		-addFeatures 1 \
		-mod $modification \
		-minLength 7
done

for i in 0{1..9} {10..10}; do
    msgf2pin -F $fasta_target,$fasta_path/Decoy_AUP000005640_sp.fasta --min-length 7 -o $fasta_path/pin$i.tsv $mzml/target/TCGA-A6-3807-01A-22_W_VU_20121019_A0218_4I_R_FR$i.mzML.mzid $mzml/decoy/TCGA-A6-3807-01A-22_W_VU_20121019_A0218_4I_R_FR$i.mzML.mzid
done

for i in {11..15}; do
    msgf2pin -F $fasta_target,$fasta_path/Decoy_AUP000005640_sp.fasta --min-length 7 -o $fasta_path/pin$i.tsv $mzml/target/TCGA-A6-3807-01A-22_W_VU_20121020_A0218_4I_R_FR$i.mzML.mzid $mzml/decoy/TCGA-A6-3807-01A-22_W_VU_20121020_A0218_4I_R_FR$i.mzML.mzid
done

for i in 0{1..9} {10..15}; do
    percolator $fasta_path/pin$i.tsv -f $fasta_target > $fasta_path/pout$i.tsv
done
