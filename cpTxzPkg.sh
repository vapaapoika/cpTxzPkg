#! /bin/bash

if [ "$1" ]; then
    from="$1"
else
    from="/var/cache/pacman/pkg/"
fi

if [ "$2" ]; then
    to="$2"
else
    to="txzPkgs"
fi

if [ -f "$to" ]; then
    echo "There is a file named '$to'. You should remove it"
    exit 1
elif [ ! -d "$to" ]; then
    mkdir "$to"
fi

cd "$to"

echo "Starting"

errs=0

for pkg in `find "$from" -name \*.tar.xz`; do
    filename="`echo "$pkg" | awk -F/ ' { print ( $(NF) ) } '`"
    echo -n "${filename}... "
    if [ -f "$filename" ]; then
	echo "exist"
    else
	if cp "$pkg" .; then
	    echo "ok"
	else
	    echo "error"
	    errs=$[$errs+1]
	fi
    fi
done

errmes="errors"

if [ $errs -eq 0 ]; then
    errs="No"
elif [ $errs -eq 1 ]; then
    errmes="error"
fi

echo "Finished. $errs $errmes"
