#!/bin/sh

set -x

alsactl kill quit
alsactl restore
pactl set-sink-port 0 analog-output-headphones

