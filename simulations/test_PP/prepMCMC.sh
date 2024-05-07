#!/bin/bash

for ((rep=1;rep<=50;rep++));
do
	mkdir rep${rep}_1
	mkdir rep${rep}_2
	sed "s/seed = 1/seed = ${rep}/g" simulate.ctl > rep${rep}_1/simulate.ctl
	sed "s/seed = 1/seed = ${rep}/g" simulate.ctl > rep${rep}_2/simulate.ctl

	cp inference.ctl rep${rep}_1/
	sed "s/seed = 1/seed = 2/g" inference.ctl > rep${rep}_2/inference.ctl


done
