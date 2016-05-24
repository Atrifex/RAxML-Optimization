#!/bin/bash

# This script is to be used coupled with the setup.sh script. 
# Once the setup and modifications are done correctly, you can execute this script to start the profiling
# 
# Author: Rishi Thakkar
#

count=1
while [ $count -le 32 ]
do

	sleep 2
       	qsub thread_1_$count/prof.pbs
	if [ $? -eq 1 ]
	then 
		echo "There was a problem with the job submission. Please check your script before trying again."
		exit
	fi

	count=`expr $count + 1`
done
