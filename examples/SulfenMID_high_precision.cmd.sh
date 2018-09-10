cd ~/data/SulfenM/SulfenM_mzML/
for file in *.mzML; do
    filemzid=$file.mzid
    java -Xmx3500M -jar ~/src/MSGFPlus.jar  \
	 -s ~/data/SulfenM/SulfenM_mzML/SulfenM_RKO_LCA_A01.mzML \
	 -d ~/data/SulfenMID_high_precision/UP000000560_227321.fasta \
	 -t 20ppm \
	 -ti -1,2 \
	 -ntt 2 \
	 -tda 1 \
	 -o   ~/data/SulfenMID_high_precision/$filemzid \
	 -mod ~/data/SulfenMID_high_precision/Mods.txt
done    

