


echo -e "Enter starting ID: \c"
read startID

threadCount=1
while [ $threadCount -le 8 ]
do
	qdel $startID.nano
		
	startID=`expr $startID + 1`
	threadCount=`expr $threadCount + 1`
done
