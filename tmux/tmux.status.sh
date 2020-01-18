#!/usr/bin/env sh

client_width="$1"

# battery color declaration
max_r=00
max_g=ff
max_b=a0
min_r=ff
min_g=00
min_b=60

# battery info
if [ -x "$(command -v acpi)" ]; then
	acpi=$(acpi)
	battery="$(echo "$acpi" | grep -Po '\d+\%' | grep -Po '\d+')"
	if (echo "$acpi" | grep 'Charging'); then
		battery_str="$battery%+"
	else
		battery_str="$battery% "
	fi
else
	battery=50
	battery_str="n/a "
fi

# battery color calculation
battery_inv=$((100 - $battery))
r=$(( ($battery * 0x$max_r + $battery_inv * 0x$min_r ) / 100 ))
g=$(( ($battery * 0x$max_g + $battery_inv * 0x$min_g ) / 100 ))
b=$(( ($battery * 0x$max_b + $battery_inv * 0x$min_b ) / 100 ))

# building status string
time_str="$(date +"%A %m/%d/%Y %T")"
padding=$(( ($client_width - ${#time_str}) / 2 - ${#battery_str} ))
format_str=$(printf '#[fg=#%02x%02x%02x bold]' "$r" "$g" "$b")
printf "%s%${padding}s%s%s\n" "$time_str" '' "$format_str" "$battery_str"
