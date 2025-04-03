
for dir in {mid,high}/rep{1..30}
do

	echo $dir
	mkdir ${dir}/{1,2}
	cp inference.ctl ${dir}/1/
	cp inference.ctl ${dir}/2/

	# UPDATE SEEDS and other things
	sed -i 's/seed = 1/seed = 2/g' ${dir}/2/inference.ctl

done
