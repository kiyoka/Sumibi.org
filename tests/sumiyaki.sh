#!/bin/bash

HOUR=`date +'%H'`
GO=0

for i in 1 2 3 4 5 6 7 8 9
do
  if [ $i = $HOUR ] ; then
    GO=1
  fi
done

if [ $GO = 1 ] ; then
  ../sumiyaki $*
else
  echo "skip" $*
fi
