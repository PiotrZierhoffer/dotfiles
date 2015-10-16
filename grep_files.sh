#!/bin/bash
set -e
set -u

IFS=$'\n'
WHAT=$1
shift
WHERE=${*:-.}
counter=0
for entry in `grep -irHIn --color=always "$WHAT" $WHERE`
do
  echo "[$counter] $entry"

  path=`echo $entry | cut -d':' -f1 | sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g'`
  line=`echo $entry | cut -d':' -f2 | sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g'`

  paths[$counter]=$path
  lines[$counter]=$line

  counter=$((counter + 1))
done

if [ "$counter" -gt 0 ]
then
  echo -n "Podaj numer wpisu, który ma zostać otwarty: "
  read number

  vim +${lines[$number]} +/$WHAT +?$WHAT  ${paths[$number]}
fi
