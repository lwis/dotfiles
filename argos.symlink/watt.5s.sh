#!/usr/bin/env bash

WATT=$(awk '{print $1*10^-6 " W"}' /sys/class/power_supply/BAT1/power_now)

echo "$WATT"
