#!/bin/bash

grep 'OK DOWNLOAD' Downloads/cdlinux.ftp.log | cut -d '"' -f 2,4 | cut -d '/' -f  1,6 | grep '\.iso$' | uniq | cut -d '/' -f 2 > tmpfile
cut -d  ' ' -f 1,7,9 Downloads/cdlinux.www.log | grep '200$' | cut -d '/' -f 1,6 | cut -d ' ' -f 1,2 | grep '\.iso$' | uniq | cut -d '/' -f 2 >> tmpfile
sort tmpfile | uniq -c | sort -k 1n > outfile
zip OlivierStankiewicz193454.zip outfile
