#!/bin/bash

for D in `find . -maxdepth 1 -type d | cut -d. -f2,3,4,5 | cut -d/ -f2`
do
        echo $D
        SHORT=`echo $D | cut -d. -f1`
        echo $SHORT
        ln -s /var/lib/collectd/rrd/$D /usr/share/graphite/storage/rrd/collectd/$SHORT
done
