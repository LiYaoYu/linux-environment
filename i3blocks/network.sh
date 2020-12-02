#!/usr/bin/env bash

network_file="/tmp/.network"
ifaces=$(ls /sys/class/net | grep -E '^(eno|enp|ens|enx|eth|wlan|wlp)')

rx=0
tx=0
curr_rx=0
curr_tx=0
downlink=0
uplink=0

curr_time=$(date +%s)

for iface in $ifaces; do
    read rx < "/sys/class/net/${iface}/statistics/rx_bytes"
    read tx < "/sys/class/net/${iface}/statistics/tx_bytes"
    curr_rx=$(( rx + curr_rx ))
    curr_tx=$(( tx + curr_tx ))
done

if [ -f "${network_file}" ]; then
    . $network_file

    interval=$(( $curr_time - $prev_time))

    if [ $interval -gt 0 ]; then
        downlink=$(((curr_rx - prev_rx) / interval / 125))
        uplink=$(((curr_tx - prev_tx) / interval / 125))
    fi
fi

printf "prev_time=%s\n" "$curr_time" > $network_file
printf "prev_rx=%d\n" "$curr_rx" >> $network_file
printf "prev_tx=%d\n" "$curr_tx" >> $network_file

printf "%d Kbps ↓ %d Kbps ↑\n" "$downlink" "$uplink"
