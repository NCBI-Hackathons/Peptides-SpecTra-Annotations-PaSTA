
msgf=~/kavee/MSGFPlus.v2018.07.17/MSGFPlus.jar
mzml=~/data/TCGA_CC/TCGA-A6-3807
fasta_path=~/kavee/test/database
fasta_target=~/kavee/test/database/AUP000005640_sp.fasta
fasta_file=`basename $fasta_target`

#Create Decoy database with mimic
/tmp/install/bin/mimic $fasta_target> $fasta_path/Decoy_$fasta_file
fasta_decoy=$fasta_path/Decoy_$fasta_file

modification=~/data/TCGA_CC/Mods.txt
cd $mzml
mkdir target
mkdir decoy

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

#msgf2pin 
#msgf2pin -F $fasta_target,$fasta_decoy --min-length 7 
