DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
PARENT_DIR="$(dirname "$DIR")"

msgf=$PARENT_DIR/software/MSGFPlus/MSGFPlus.jar
mzml_folder=$PARENT_DIR/cptc-xfer.uis.georgetown.edu/publicData/Phase_II_Data/TCGA_Colorectal_Cancer_S_022/TCGA-A6-3807-01A-22_Proteome_VU_20121019/TCGA-A6-3807-01A-22_Proteome_VU_20121019_mzML/
mzml=$PARENT_DIR/cptc-xfer.uis.georgetown.edu/publicData/Phase_II_Data/TCGA_Colorectal_Cancer_S_022/TCGA-A6-3807-01A-22_Proteome_VU_20121019/TCGA-A6-3807-01A-22_Proteome_VU_20121019_mzML/TCGA-A6-3807-01A-22_W_VU_20121019_A0218_4I_R_FR01.mzML
filename=`basename $mzml`
fasta_path=$PARENT_DIR/examples
fasta_target=$fasta_path/AUP000005640_sp.fasta
fasta_file=`basename $fasta_target`

#Create Decoy database with mimic
$PARENT_DIR/software/bin/mimic $fasta_target > $fasta_path/Decoy_$fasta_file
fasta_decoy=$fasta_path/Decoy_$fasta_file

modification=$PARENT_DIR/examples/Mods.txt

mkdir $mzml_folder/target
mkdir $mzml_folder/decoy

# BuildSA
java -Xmx4000M -cp $msgf edu.ucsd.msjava.msdbsearch.BuildSA -d $fasta_target -tda 0
java -Xmx4000M -cp $msgf edu.ucsd.msjava.msdbsearch.BuildSA -d $fasta_decoy -tda 0
 
# Search MS-GF+
filemzid_target=$mzml_folder/target/$filename.mzid
java -Xmx24000M -jar $msgf \
	-s $mzml \
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

filemzid_decoy=$mzml_folder/decoy/$filename.mzid
java -Xmx24000M -jar $msgf \
	-s $mzml \
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


msgf2pin -F $fasta_target,$fasta_path/Decoy_AUP000005640_sp.fasta --min-length 7 -o $fasta_path/pin.tsv $mzml_folder/target/$filename.mzid $mzml_folder/decoy/$filename.mzid
percolator $fasta_path/pin.tsv -f $fasta_target > $fasta_path/pout.tsv
