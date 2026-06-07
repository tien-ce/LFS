#!/bin/bash
CHAPTER="$1"
PACKAGE="$2"
cat packages.csv | grep -i "^$PACKAGE" | grep -i -v "\.patch" | while read line; do
	echo  PACKAGE $line
	#NAME="$(echo "$line" | cut -d',' -f1)" 
	VERSION="$(echo "$line" | cut -d',' -f2)" 
	# Pass the extracted VERSION to sed to replace the @ placeholder
	URL="$(echo "$line" | cut -d',' -f3 | sed "s|@|$VERSION|g")" 
	#MD5="$(echo "$line" | cut -d',' -f4)" 
	CACHEFILE="$(basename "$URL")"
	DIRNAME="$(echo "$CACHEFILE" | sed 's/\(.*\)\.tar\..*/\1/')"
	mkdir -pv "$DIRNAME"
	if [ -d "$DIRNAME" ]; then
		rm -rf "$DIRNAME"
	fi
	echo "Extracting $CACHEFILE"
	tar -xf "$CACHEFILE" -U "$DIRNAME"
	pushd "$DIRNAME"
		MV=0
		if [ "$(ls -1A | wc -l)" == "1" ]; then	
			MV=1
			pushd $(ls)
		fi
		echo "Compiling $PACKAGE"
		sleep 5
		mkdir -pv "../log/Chapter$CHAPTER/"
		
		SCRIPT_PATH="../Chapter$CHAPTER/$PACKAGE.sh"
		if [ ! -f "$SCRIPT_PATH" ]; then
			echo "Error: Script $SCRIPT_PATH not found!"
			[ $MV -eq 1 ] && popd
			popd
			exit 1
		fi

        # Catch the error if error occur in pipe
		set -o pipefail
		if ! source "$SCRIPT_PATH" 2>&1 | tee "../log/Chapter$CHAPTER/$PACKAGE.log"; then
			echo "Compiling $PACKAGE FAILED!"
			[ $MV -eq 1 ] && popd
			popd
			exit 1
		fi
		set +o pipefail
		echo "Done Compiling $PACKAGE"
		if [ $MV -eq 1 ]; then
			popd
		fi
	popd
done
