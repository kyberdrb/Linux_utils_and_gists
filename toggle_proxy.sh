#!/bin/bash
FILE=/etc/environment
FILE_BAK=/etc/environment.bak
FILE_TMP=/etc/environment.tmp

sudo mv $FILE $FILE_TMP
sudo mv $FILE_BAK $FILE
sudo mv $FILE_TMP $FILE_BAK

cat $FILE
