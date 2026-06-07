for p in $(ls *.sh); do
	P=$(echo "${p}" | cut -d . -f 1)
	PN=$(grep "^${P}" ../packages.csv | cut -d , -f 1)
    # Use wdiff with terminal color codes to highlight changes
	echo "${P} - ${PN}"
	if [[ "$A" != "$B" ]]; then
		echo "Different here"
	fi
done
