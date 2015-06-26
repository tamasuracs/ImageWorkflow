BEST_DIR='gui/'
SRC_DIR_BASE="/mese"
DST_DIR_BASE=~/test

i=0

ITEMS_TO_PROCESS=`find $SRC_DIR_BASE \( -name '*.pbd' -o -name '*.cs' \) -path "*$BEST_DIR*" | wc -l`


find $SRC_DIR_BASE \( -name '*.pbd' -o -name '*.cs' \) -path "*$BEST_DIR*" | while read FILE; do
	((i++))
	echo $i"/"$ITEMS_TO_PROCESS": processing $FILE"
	FULL_DIRNAME=`dirname "$FILE"`
	#Picking the path suffix
	DIRNAME=${FULL_DIRNAME#$SRC_DIR_BASE}
	FILENAME=${FILE#$SRC_DIR_BASE}
	
	#Constructing the new dest dir and filename
	DST_DIR="$DST_DIR_BASE/$DIRNAME/"
	DST_FILE="$DST_DIR_BASE/$FILENAME"
	
	#If the destination direcotry not exists 
	if [ ! -d "$DST_DIR" ]; then
		#it gets created	
		mkdir -p "$DST_DIR"
	fi
	
	#if destination file exists	
	if [ -f "$DST_FILE" ]
	then
		cmp -s "$DST_FILE" "$FILE" > /dev/null
		
		#If SRC and DST file differs - copy is made (existing one backed up)
		if [[ $? -eq 1 ]]
		then
			echo "File exists: $DST_FILE "
			cp -v --backup=numbered "$FILE" "$DST_DIR"
		fi
	else
		#Simply copying the file
		cp "$FILE" "$DST_DIR"
	fi
done
