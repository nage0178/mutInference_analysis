

echo gene,probMult,meanTime,L_HPD,H_HPD,mean_1,L_HPD_1,H_HPD_1,mean_2,L_HPD_2,H_HPD_2,GBR,LWK,CHS,GBRCHS,LWKGBRCHS,GBR1,LWK1,CHS1,GBRCHS1,LWKGBRCHS1,GBR2,LWK2,CHS2,GBRCHS2,LWKGBRCHS2 > summary
for gene in ASIP MATP MCIR_2 OCA2 SLC24A5 TYR
#for gene in OCA2 
do
#	continue
	probMult=$(grep multiple out$gene | awk '{print $5}')
	mean=$(grep mean_time out$gene | awk '{print $2}')
	low=$(grep 1_mut_02.5_HPD out$gene | awk '{print $2}')
	high=$(grep 1_mut_97.5_HPD out$gene | awk '{print $2}')

	mean2=$(grep 2_mut_time_2 out$gene | awk '{print $2}')
	low2=$(grep 2_mut_02.5_HPD_2 out$gene | awk '{print $2}')
	high2=$(grep 2_mut_97.5_HPD_2 out$gene | awk '{print $2}')

	mean1=$(grep 2_mut_time_1 out$gene | awk '{print $2}')
	low1=$(grep 2_mut_02.5_HPD_1 out$gene | awk '{print $2}')
	high1=$(grep 2_mut_97.5_HPD_1 out$gene | awk '{print $2}')

	GBR=$(grep "1_mut_pop_GBR\s" out$gene | awk '{print $2}')
	LWK=$(grep "1_mut_pop_LWK\s" out$gene | awk '{print $2}')
	CHS=$(grep 1_mut_pop_CHS out$gene | awk '{print $2}')
	GBRCHS=$(grep 1_mut_pop_GBRCHS out$gene | awk '{print $2}')
	LWKGBRCHS=$(grep 1_mut_pop_LWKGBRCHS out$gene | awk '{print $2}')


	# These are all marginal -> you need the joint distribution
	GBR1=$(grep "2_mut_pop_1_GBR\s"  out$gene | awk '{print $2}')
	LWK1=$(grep "2_mut_pop_1_LWK\s"  out$gene | awk '{print $2}')
	CHS1=$(grep 2_mut_pop_1_CHS  out$gene | awk '{print $2}')
	GBRCHS1=$(grep 2_mut_pop_1_GBRCHS  out$gene | awk '{print $2}')
	LWKGBRCHS1=$(grep 2_mut_pop_1_LWKGBRCHS out$gene | awk '{print $2}')

	GBR2=$(grep "2_mut_pop_2GBR\s"  out$gene | awk '{print $2}')
	LWK2=$(grep "2_mut_pop_2LWK\s"  out$gene | awk '{print $2}')
	CHS2=$(grep 2_mut_pop_2CHS  out$gene | awk '{print $2}')
	GBRCHS2=$(grep 2_mut_pop_2GBRCHS  out$gene | awk '{print $2}')
	LWKGBRCHS2=$(grep 2_mut_pop_2LWKGBRCHS out$gene | awk '{print $2}')

#	echo $mean1
#	echo $mean2
#	echo $low1
#	echo $low2
#	echo $high1
#	echo $high2
#
	echo ${gene},${probMult},${mean},${low},${high},${mean1},${low1},${high1},${mean2},${low2},${high2},${GBR},${LWK},${CHS},${GBRCHS},${LWKGBRCHS},${GBR1},${LWK1},${CHS1},${GBRCHS1},${LWKGBRCHS1},${GBR2},${LWK2},${CHS2},${GBRCHS2},${LWKGBRCHS2} >> summary
done

#exit
for gene in ASIP MATP  MCIR_2 OCA2 SLC24A5 TYR
do
	echo pop1,pop2,prob > jointPopProb$gene
	for pop in 1 2 3 4 5
	do
		#tail -n 8 out${gene} |head -6 
		pop2=$(tail -n 8 out${gene} |head -1 | awk -v var=$pop '{print $var}')
		#echo
		((col=pop+1))
		tail -n 8 out${gene} |head -6 | awk -v var=$pop2 -v var2=$col '{if (NR > 1) {print $1"," var "," $var2}}' >> jointPopProb$gene
		#exit
	done
done
