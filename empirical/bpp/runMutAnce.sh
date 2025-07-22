# Runs MutAnce for all of the the loci of interest
cd sat_1_l1000
for gene in ASIP  MATP MCIR_2  OCA2  SLC24A5  TYR
do 
	MutAnce ../${gene}_l1000.ctl &> out$gene & 
done
cd ../


cd sat_1_l5000
for gene in ASIP  MATP MCIR_1 MCIR_2  OCA2  SLC24A5  TYR
do 
	MutAnce ../${gene}.ctl &> out$gene & 
done
cd ../

cd sat_1_l10000
for gene in ASIP  MATP  OCA2  SLC24A5  TYR
do 
	MutAnce ../${gene}_10000.ctl &> out$gene & 
done
cd ../
