#!/bin/bash 

HOUR=`date +'%H'`
GO=1

for i in 01 02 03 04 05 06 07 08
do
  if [ $i = $HOUR ] ; then
    GO=1
  fi
done

if [ $GO = 1 ] ; then
  echo "sumiyaki=>[" $* "]"
  gosh -I ../lib ../sumiyaki $*
else
  echo "skip" $*
  sleep 3600
fi
