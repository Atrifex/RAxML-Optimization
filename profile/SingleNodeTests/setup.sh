#!/bin/bash

# This script is used to set up the enviornment for the profiling
# This type of set up makes it easy to do modular testing and allows of easy replication of ones tests
# 
# 
# Requirements: 
#	- script requires there to be a template pbs script to exist in the current folder
#	- executables need to be placed in a centralized locatio
#	- data set is stored in a centralized data set folder so that it can be used to set up current profile
# There are local variables that have been created to store the location of these dependencies
#
# Future edits:
#	- might want to use the commented out seperate directories for results
# 
# Author: Rishi Thakkar

# sets up folder structure for two unique cases

templatePBSScript=`pwd`						# if location is changed this change this variable
executables=/home/rrthakk2/lustre/profile/executables
dataset=/home/rrthakk2/lustre/profile/dataSets

echo -e "\033[0;31m-------------------------------------------------------------------------------------------------------"
echo -e "\033[1;31mThis script will delete all thread_* files and directories.\033[0m"
echo -e "\033[0;31m-------------------------------------------------------------------------------------------------------\033[0m"
echo -e "Please enter y/Y if you want to continue or enter n/N to exit: \c"
while true
do
	read char
	if [ "$char" == "y" -o "$char" == "Y" ]
	then
		break
	elif [ "$char" == "n" -o "$char" == "N" ]
	then
		exit
	elif [ "$char" == "c" -o "$char" == "C" ]
	then
		rm -rf thread_*
		exit
	fi
	echo -e "Please enter a valid input. y/Y if you want to continue or n/N if you want to exit: \c"
done

rm -rf thread_*

mkdir thread_1
#mkdir thread_1/results
cp $templatePBSScript/prof.pbs thread_1/
cp -r $dataset/23S.E/ thread_1/
cp $executables/raxmlHPC thread_1/

mkdir thread_1_AVX
#mkdir thread_1_AVX/results
cp $templatePBSScript/prof.pbs thread_1_AVX/
cp -r $dataset/23S.E/ thread_1_AVX/
cp $executables/raxmlHPC-AVX thread_1_AVX/

threadCount=1
while [ $threadCount -le 6 ]
do
	temp=`expr $threadCount \* 2`

	# sets up folder structure for the main folders
	mkdir thread_$temp
	#mkdir thread_$temp/results
	cp $templatePBSScript/prof.pbs thread_$temp/
	cp -r $dataset/23S.E/ thread_$temp/
	cp $executables/raxmlHPC-PTHREADS-AVX thread_$temp/

	threadCount=`expr $threadCount + 1`
done

echo -e "\033[0;32m-------------------------------------------------------------------------------------------------------"
echo -e "\033[1;32mProfiling directories have been setup correctly. Make changes to the template strcuture as you see fit."
echo -e "\033[0;32m-------------------------------------------------------------------------------------------------------\033[0m"
