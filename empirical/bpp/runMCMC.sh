# Run all the MCMCs in the background
for rep in  {1..3}_l{1000,5000,10000}
do
	cd sat_${rep}
	bpp --cfile AsEuAfr.ctl --theta_mode 3 &> output & 
	cd ../
done
