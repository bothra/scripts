#!/bin/bash

for i in $(ls /dev/sd*|sort -n); do
	echo -n "$i = "
	eval "scsi_id -g -u ${i}"
done
