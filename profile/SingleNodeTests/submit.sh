#!/bin/bash

# This script is to be used coupled with the setup.sh script. 
# Once the setup and modifications are done correctly, you can execute this script to start the profiling
# 
# Author: Rishi Thakkar
#

sleep 2
qsub thread_1/prof.pbs
if [ $? -eq 1 ]
then 
	echo "There was a problem with the job submission. Please check your script before trying again."
	exit
fi

sleep 2
qsub thread_1_AVX/prof.pbs
if [ $? -eq 1 ]
then 
	echo "There was a problem with the job submission. Please check your script before trying again."
	exit
fi

threadCount=1
while [ $threadCount -le 6 ]
do
       	temp=`expr $threadCount \* 2`

	sleep 2
       	qsub thread_$temp/prof.pbs
	if [ $? -eq 1 ]
	then 
		echo "There was a problem with the job submission. Please check your script before trying again."
		exit
	fi

       	threadCount=`expr $threadCount + 1`
done

