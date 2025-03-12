
for recomb in mid high
do
	cd $recomb

	for rep in {1..2}
	do
		cd rep${rep}
		rm -f bpp_seq.txt
	
		# loop for loci
		for locus in {1..2}
		do
			# These programs are all by loci
			# Prepare argweaver files
			# Argweaver can use fasta file
			
			# Prepare GEVA files
			# Need to prepare vcf file

			# Prepare tsdate/tsinfer
			# Make vcf file, convert to vcf zarr

			# Prepare relate
			# looks like you can extract from vcf with their script

			# prepare bpp files

			echo 60 5000 >> bpp_seq.txt
			if [[ "$locus" -lt 11 ]]; then
				cd l$locus
				sed 's/=/ /g' interval.txt | sed 's/\./ /g' | awk '{print $2 ":" $5 ":" $8 }' | awk -F : '$3 > 499999' > interval_process.txt
				for line in $(cat interval_process.txt) 
				do
					#echo $line
					if [[ "$breakLine" -eq 1 ]]; then
						breakLine=0
						cd ../
						break
					fi
					tree=$(echo $line | awk -F : '{print $1}')
					start=$(echo $line | awk -F : '{print $2}')
					end=$(echo $line | awk -F : '{print $3}')
					
					#echo $tree $start $end
					for site in $(grep Branch mut_${tree}.txt | sed 's/,//g' | awk '{print $4}')
					do
						#echo $tree $start $end
						#echo $site
						# Check coords

						((alignSite=start+site))
						if [ "$alignSite" -gt 499999 ]; then
							# Check site is polymorphic
							firstSite=$(grep -v ">" seq${tree}.fa | awk -v k=$site  '{ print substr( $0, k, 1 ) }'  | uniq | wc | awk '{print $1}')

							if [ $firstSite != 1 ]; then
								numMut=$(grep -E "\sSite:\s$site," mut_${tree}.txt | wc | awk '{print $1}')
								time=$(grep -E "\sSite:\s$site," mut_${tree}.txt | sed 's/,//g'|  awk '{print $6}' )
								echo $time
								grep -E "\sSite:\s$site," mut_${tree}.txt 
								if [ $numMut = 1 ]; then 

									count=$(grep -v ">" seq${tree}.fa | awk -v k=$site  '{ print substr( $0, k, 1 ) }'  | sort | uniq -c )
									base1=$(echo $count | awk '{print $1}')
									base2=$(echo $count | awk '{print $3}')
									echo $count
									if [ "$base1" -gt "$base2" ]; then
										anc=$(echo $count | awk '{print $2}')
									else
										anc=$(echo $count | awk '{print $4}')
									fi

									((alignSite=start+site))
									((finalStart=alignSite-2500))
									 ((finalEnd=alignSite+2499))
									echo Recomb $recomb Rep $rep Locus $locus Start $start Site $site finalSite $alignSite $finalStart $finalEnd Ancestral $anc
									breakLine=1

									# Now cut alignment
									awk -v k=$finalStart '{if(!/^>/){ print substr ($0, k, 5000 ) }else{print $0}}' seq.fa > cut_seq.fa
							

									break;
								fi	
							fi
						fi
					done

					
					
				done	


				cat l$locus/cut_seq.fa >> bpp_seq.txt
			else
				cat l$locus/seq.fa >> bpp_seq.txt
			fi


		done

		sed -i 's/>/^/g' bpp_seq.txt

		cd ../
	done
	cd ../
done
