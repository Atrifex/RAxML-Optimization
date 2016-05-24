#!/bin/bash

#
# This script is to be used coupled with the setup.sh script. 
# Its main purpose is to delete all 8 submited jobs.
# Once the setup and modifications are done correctly, you can execute this script to start the profiling
# 
# Author: Rishi Thakkar
#

echo -e "Enter starting ID: \c"
read startID

threadCount=1
while [ $threadCount -le 32 ]
do
	qdel $startID.nano

	startID=`expr $startID + 1`
	threadCount=`expr $threadCount + 1`
done
