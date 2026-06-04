cat packages.csv | while read line; do
	NAME="$(echo "$line" | cut -d',' -f1)" 
	VERSION="$(echo "$line" | cut -d',' -f2)" 
	# Pass the extracted VERSION to sed to replace the @ placeholder
	URL="$(echo "$line" | cut -d',' -f3 | sed "s|@|$VERSION|g")" 
	MD5="$(echo "$line" | cut -d',' -f4)" 
	CACHEFILE="$(basename "$URL")"

	if [ ! -f "$CACHEFILE" ]; then
		echo Downloading $URL
		wget "$URL"
		if ! echo "$MD5 $CACHEFILE" | md5sum -c > /dev/null; then
			rm -f "$CACHEFILE"
			echo "Verification failed"
			exit 1
		fi
	fi
done
