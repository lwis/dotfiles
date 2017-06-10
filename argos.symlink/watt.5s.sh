#!/usr/bin/env bash

BAT0_WATT=$(cat /sys/class/power_supply/BAT0/power_now)
BAT1_WATT=$(cat /sys/class/power_supply/BAT1/power_now)

SUM_WATT=$(($BAT0_WATT + $BAT1_WATT))

WATT=$(awk -v sum_watt=$SUM_WATT ' BEGIN {print sum_watt*10^-6}' )

FORMATTED=$(printf "%.1f" "$WATT")

echo "$FORMATTED"W
