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
executables=/home/rrthakk2/lustre/RAxML-Optimization/profile/executables
dataset=/home/rrthakk2/lustre/RAxML-Optimization/profile/dataSets

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
sed -i "4i #PBS -N thread_1" thread_1/prof.pbs
sed -i "9i #PBS -l nodes=nano4:ppn=1" thread_1/prof.pbs
sed -i "11i cd /home/rrthakk2/lustre/RAxML-Optimization/profile/SingleNodeTests/thread_1/" thread_1/prof.pbs
sed -i "14i amplxe-cl -collect advanced-hotspots -knob collection-detail=stack-and-callcount -data-limit=0 ./raxmlHPC -m GTRCAT -n 23S.E.ALL -s 23S.E/R0/cleaned.alignment.fasta -j -p 6154307" thread_1/prof.pbs
#sed -i "14i amplxe-cl -collect hotspots -data-limit=0 ./raxmlHPC -m GTRCAT -n 23S.E.ALL -s 23S.E/R0/cleaned.alignment.fasta -j -p 6154307" thread_1/prof.pbs
#sed -i "17i amplxe-cl -collect-with runsa -knob enable-call-counts=true -knob event-config=CPU_CLK_UNHALTED.REF_TSC:sa=1800000,CPU_CLK_UNHALTED -data-limit=0 ./raxmlHPC -m GTRCAT -n 23S.E.ALL -s 23S.E/R0/cleaned.alignment.fasta -j -p 6154307" thread_1/prof.pbs

mkdir thread_1_AVX
#mkdir thread_1_AVX/results
cp $templatePBSScript/prof.pbs thread_1_AVX/
cp -r $dataset/23S.E/ thread_1_AVX/
cp $executables/raxmlHPC-AVX thread_1_AVX/
sed -i "4i #PBS -N thread_1_AVX" thread_1_AVX/prof.pbs
sed -i "9i #PBS -l nodes=nano4:ppn=1" thread_1_AVX/prof.pbs
sed -i "11i cd /home/rrthakk2/lustre/RAxML-Optimization/profile/SingleNodeTests/thread_1_AVX/" thread_1_AVX/prof.pbs
sed -i "14i amplxe-cl -collect advanced-hotspots -knob collection-detail=stack-and-callcount -data-limit=0 ./raxmlHPC-AVX -m GTRCAT -n 23S.E.ALL -s 23S.E/R0/cleaned.alignment.fasta -j -p 6154307" thread_1_AVX/prof.pbs
#sed -i "14i amplxe-cl -collect hotspots -data-limit=0 ./raxmlHPC-AVX -m GTRCAT -n 23S.E.ALL -s 23S.E/R0/cleaned.alignment.fasta -j -p 6154307" thread_1_AVX/prof.pbs
#sed -i "17i amplxe-cl -collect-with runsa -knob enable-call-counts=true -knob event-config=CPU_CLK_UNHALTED.REF_TSC:sa=1800000,CPU_CLK_UNHALTED -data-limit=0 ./raxmlHPC-AVX -m GTRCAT -n 23S.E.ALL -s 23S.E/R0/cleaned.alignment.fasta -j -p 6154307" thread_1_AVX/prof.pbs

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

	sed -i "4i #PBS -N thread_$temp" thread_$temp/prof.pbs

	if [ $temp -le 4 ]
	then
		sed -i "9i #PBS -l nodes=nano4:ppn=$temp" thread_$temp/prof.pbs
	elif [ $temp -le 8 ]
	then
		sed -i "9i #PBS -l nodes=nano5:ppn=$temp" thread_$temp/prof.pbs
	else	
		sed -i "9i #PBS -l nodes=nano7:ppn=$temp" thread_$temp/prof.pbs
	fi

	sed -i "11i cd /home/rrthakk2/lustre/RAxML-Optimization/profile/SingleNodeTests/thread_$temp/" thread_$temp/prof.pbs
	sed -i "14i amplxe-cl -collect advanced-hotspots -knob collection-detail=stack-and-callcount -data-limit=0 ./raxmlHPC-PTHREADS-AVX -m GTRCAT -n 23S.E.ALL -s 23S.E/R0/cleaned.alignment.fasta -j -T $temp -p 6154307" thread_$temp/prof.pbs
#	sed -i "14i amplxe-cl -collect hotspots -data-limit=0 ./raxmlHPC-PTHREADS-AVX -m GTRCAT -n 23S.E.ALL -s 23S.E/R0/cleaned.alignment.fasta -j -T $temp -p 6154307" thread_$temp/prof.pbs
#	sed -i "17i amplxe-cl -collect-with runsa -knob enable-call-counts=true -knob event-config=CPU_CLK_UNHALTED.REF_TSC:sa=1800000,CPU_CLK_UNHALTED -data-limit=0 ./raxmlHPC-PTHREADS-AVX -m GTRCAT -n 23S.E.ALL -s 23S.E/R0/cleaned.alignment.fasta -j -T $temp -p 6154307" thread_$temp/prof.pbs

	threadCount=`expr $threadCount + 1`
done

echo -e "\033[0;32m-------------------------------------------------------------------------------------------------------"
echo -e "\033[1;32mProfiling directories have been setup correctly. Make changes to the template strcuture as you see fit."
echo -e "\033[0;32m-------------------------------------------------------------------------------------------------------\033[0m"

echo ""
echo -e "Please enter y/Y to submit the pbs scripts or enter n/N to perform furthure inspections of setup files: \c"
while true
do
	read char
	if [ "$char" == "y" -o "$char" == "Y" ]
	then
		sh submit.sh
		exit
	elif [ "$char" == "n" -o "$char" == "N" ]
	then
		exit
	fi
	echo -e "Please enter a valid input. y/Y if you want to run or n/N if you want to exit: \c"
done
