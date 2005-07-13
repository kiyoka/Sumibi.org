#!/bin/bash

HOUR=`date +'%H'`
GO=0

for i in 01 02 03 04 05 06 07 08 09
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
