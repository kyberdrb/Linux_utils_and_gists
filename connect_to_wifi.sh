#!/bin/bash
sudo wpa_cli -i wlo1 disconnect
su -c 'wpa_supplicant -B -i wlo1 -c <(wpa_passphrase UPC7099091 "my password is very stronk")'
sudo dhcpcd wlo1 --release
sudo dhcpcd wlo1 --exit
sudo dhcpcd wlo1 &

while true
do
    sudo route del -net 0.0.0.0 gw 192.168.0.1 netmask 0.0.0.0 dev wlo1
    REMOVE_ROUTE=$(echo $?)
    sudo route add -net 0.0.0.0 gw 192.168.0.1 metric 200 netmask 0.0.0.0 dev wlo1
    ADD_ROUTE=$(echo $?)

    if [ $REMOVE_ROUTE -eq 0 ] && [ $ADD_ROUTE -eq 0 ]; then break; fi

    route -n
done

