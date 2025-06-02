
echo recomb,rep,locus,pop,timeG,timeMu
for recomb in  mid  high
do
	cd $recomb

	#for rep in {1..30}
	for rep in {1..30}
	do
		cd rep${rep}
	
		for locus in {1..10}
		#for locus in 8
		do
			found=0
				#echo Recomb $recomb Rep $rep Locus $locus Start $start Site $site finalSite $alignSite $finalStart $finalEnd Ancestral $anc

				# Find the interval the tree is on
				#startInt=$(awk '{print $8}' l${locus}/siteInfo)
				startInt=$(awk '{print $6}' l${locus}/siteInfo)
				finalSite=$(awk '{print $10}' l${locus}/siteInfo)


				# Find the node in the tree 
				node=$(awk '{print $2}' l${locus}/mutInfo | sed 's/,//g' | sed 's/n//g')
				#echo Node $node

				# Take the right migration table, then remove non-ascii characters, then look for lines with the right node, check the interval
				mutHist=$(sed  's/[^ -~]/ /g'  l${locus}/mig.txt | sed 's/,//g' |  awk -v node=$node '{ if ( $4 == node ) {print $0} }' | awk -v start=$finalSite '{if ( $3 >= start ) {print $0 } }' | awk -v start=$finalSite '{if ( $2 < start ) {print $0 } }')

				#echo mutHIst 1 $mutHist

				# No migration on branch, find parent nodes
				if [[ ! "$mutHist" ]]; then

					tree=$(grep $startInt l${locus}/mig.txt  | head -1 | awk '{print $1}')
					# Newick file with the tree
					treeName=$(ls l${locus}/trees/*0$tree | grep -E /0+$tree)
					

					tree=$(sed 's/:[0-9.]*/:/g' $treeName | sed "s/n${node}:/w/g")
					#echo $tree
					newTree=$(echo $tree | sed  's/(n[0-9]*:,n[0-9]*:)//g' | sed 's/()//g')

					while [ "$tree" != "$newTree" ]; do
					        tree=$newTree
					        newTree=$(echo $tree | sed  's/(n[0-9]*:,n[0-9]*:)//g' | sed 's/()//g')
					done
					#	echo $newTree
					
					parents=$(echo $newTree | sed 's/:)/\n:)/g' | awk -F ")" '{print $2}' | awk -F ":" '{print $1}')
				else
					found=1

				fi	

				# While there is no record of the parent node in the migration table and there are more parents 
				while [ "$found" == 0 ]  && [ "$parents" ]; do
					# Get next parent
					node=$(echo $parents | awk '{print $1}'  | sed 's/n//g')

					# Look for node in migration table on correct interval
					mutHist=$(sed  's/[^ -~]/ /g' l${locus}/mig.txt  | sed 's/,//g' |  awk -v node=$node '{ if ( $4 == node ) {print $0} }' | awk -v start=$finalSite '{if ( $3 >= start ) {print $0 } }' | awk -v start=$finalSite '{if ( $2 < start ) {print $0 } }')
					#echo $node $finalSite

					# If didn't find the node, update parents
					if [ ! "$mutHist" ]; then
						parents=$(echo $parents  | awk '{for (i=2; i<=NF; i++) print $i}')
					else
						found=1
					fi
				#	echo parents $parents
				done
				
				#ANNA need to figure out right time
				#choose the right migration event


				time=$(awk '{print $6}' l${locus}/mutInfo | sed 's/,//g')
				timeMu=$(awk '{print $8}' l${locus}/mutInfo | sed 's/,//g')
				if [ "$mutHist" ]; then
					echo $mutHist | awk '{
					  for (i = 1; i <= NF; i++) {
					    printf "%s%s", $i, (i % 7 == 0 || i == NF) ? "\n" : " "
					  }
					}' | sed 's/,//g'  > mutHist.txt
					
					youngest=$(awk -v time=$time '{ if (time > $7 ) { print $0 } } ' mutHist.txt | wc -l)

					oldest=$(awk -v time=$time '{ if ( time < $7 ) { print $0 } } ' mutHist.txt | wc -l)

					# All times are older
					if [ "$youngest" == "0" ]
					then

						pop=$(awk '{print $5 }' mutHist.txt | head -1)

					## All times are younger than mutation
					elif [ "$oldest" == "0" ]
					then

						pop=$(awk '{print $6 }' mutHist.txt | tail -n 1) 

					## Some times are older and some times are younger
					else

						pop=$(awk -v time=$time '{ if (time > $7 ) { print $0 } } ' mutHist.txt | tail -n 1 | awk '{print $6}')

					fi 
				else
					pop=root
				fi


				echo ${recomb},${rep},${locus},${pop},${time},${timeMu}

		done

		cd ../
	done
	cd ../
done
