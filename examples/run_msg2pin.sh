for i in 0{1..9} {10}; do
    msgf2pin -F ~/kavee/test/database/AUP000005640_sp.fasta,~/kavee/test/database/Decoy_AUP000005640_sp.fasta --min-length 7 -o ~/data/TCGA_CC/TCGA-A6-3807/pin$i.tsv ~/data/TCGA_CC/TCGA-A6-3807/target/TCGA-A6-3807-01A-22_W_VU_20121019_A0218_4I_R_FR$i.mzML.mzid ~/data/TCGA_CC/TCGA-A6-3807/decoy/TCGA-A6-3807-01A-22_W_VU_20121019_A0218_4I_R_FR$i.mzML.mzid
done

for i in {11..15}; do
    msgf2pin -F ~/kavee/test/database/AUP000005640_sp.fasta,~/kavee/test/database/Decoy_AUP000005640_sp.fasta --min-length 7 -o ~/data/TCGA_CC/TCGA-A6-3807/pin$i.tsv ~/data/TCGA_CC/TCGA-A6-3807/target/TCGA-A6-3807-01A-22_W_VU_20121020_A0218_4I_R_FR$i.mzML.mzid ~/data/TCGA_CC/TCGA-A6-3807/decoy/TCGA-A6-3807-01A-22_W_VU_20121020_A0218_4I_R_FR$i.mzML.mzid
done

for i in 0{1..9} {10..15}; do
    percolator ~/data/TCGA_CC/TCGA-A6-3807/pin$i.tsv -f ~/kavee/test/database/AUP000005640_sp.fasta > pout$i.tsv
done
