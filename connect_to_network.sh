#!/bin/bash
SSID=$1
PASSWD=$2

su -c 'wpa_supplicant -B -i wlo1 -c <(wpa_passphrase $SSID \
  "$PASSWD") && \
dhcpcd wlo1'
