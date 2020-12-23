#!/bin/sh

alsactl restore
pactl set-sink-port 0 analog-output-headphones

