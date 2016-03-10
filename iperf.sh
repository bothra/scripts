#!/bin/bash

  runs=3
  host=server.example
  shost=server
  now=$(date +%F-%R)
  log=/var/log/iperf/iperf.log
  client=$(hostname)
  sclient=$(hostname -s)
  client2=client2.example.com
  sclient2=client2
  ident=/home/mguidry/.ssh/iperf.key

    if [ -f $log ]; then
        rm $log
    fi

    ssh $host -i $ident "nice -n 19 iperf3 -s -p 5201" >/dev/null &
    ssh $client2 -i $ident "traceroute $host" >> ~/iperf/$now-tracert-$sclient2-to-$shost.log
    ssh $host -i $ident "traceroute $client" >> ~/iperf/$now-tracert-$shost-to-$sclient.log
    traceroute $host >> ~/iperf/$now-tracert-$sclient-to-$shost.log

    sleep 5

    for run in $(seq 1 $runs); do
        nice -n 19 iperf3 -c $host -f M -Z >> $log
    done

    avg=$(awk -v runs=$runs '/Bandwidth/ {getline; sum+=$7; avg=sum/runs} END {print avg}' $log)
    echo "$now,$avg"  >> bandwidth_from_uga.csv
#    echo "$now,$avg"
    rm $log

    for run in $(seq 1 $runs); do
        nice -n 19 iperf3 -c $host -f M -Z -R >> $log
    done

    avg=$(awk -v runs=$runs '/Bandwidth/ {getline; sum+=$7; avg=sum/runs} END {print avg}' $log)
    echo "$now,$avg"  >> bandwidth_to_uga.csv
#   echo "$now,$avg"
    rm $log

    for run in $(seq 1 $runs); do
    ssh $client2 -i $ident "nice -n 19 iperf3 -c $host -f M -Z" >> $log
    done

    avg=$(awk -v runs=$runs '/Bandwidth/ {getline; sum+=$7; avg=sum/runs} END {print avg}' $log)
    echo "$now,$avg"  >> bandwidth_from_ca.csv
#   echo "$now,$avg"
    rm $log

    for run in $(seq 1 $runs); do
    ssh $client2 -i $ident "nice -n 19 iperf3 -c $host -f M -Z -R" >> $log
    done

    avg=$(awk -v runs=$runs '/Bandwidth/ {getline; sum+=$7; avg=sum/runs} END {print avg}' $log)
    echo "$now,$avg"  >> bandwidth_to_ca.csv
#   echo "$now,$avg"
    rm $log

    ssh $host -i $ident "pkill iperf3" >/dev/null

    exit 0
