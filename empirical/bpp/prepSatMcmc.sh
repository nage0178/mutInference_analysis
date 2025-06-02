mkdir -p sat_{1,2,3}_l{1000,5000,10000}

	
for length in 5000 1000 10000
do 
	for rep in 1 2 3
	do

		((start=(rep-1)*32 + 1))

		cp sat_AsEuAfr.ctl sat_${rep}_l${length}/AsEuAfr.ctl

		# Seed
		sed -i  "s/seed = 1/seed =${rep}/g" sat_${rep}_l${length}/AsEuAfr.ctl


		# Sequence file
		sed -i  "s/AsEuAfr_seq.txt/AsEuAfr_seq_${length}.txt/g" sat_${rep}_l${length}/AsEuAfr.ctl

	done
done

