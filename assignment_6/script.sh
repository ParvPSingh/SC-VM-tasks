#!/bin/bash
city="$1"
temp="$2"
calc="$3"

url="http://weather.local/city/$city.html"
html=$(curl -s "$url")

if [ "$temp" = "min" ]; then
  temps=($(echo "$html" | sed -nE '/[0-9]{1,2}(°C){1}/p' | tr -d "[:blank:]" | cut -c 5-6,10-12 | awk 'BEGIN{FS="|"}{print $1}' ))
fi
if [ "$temp" = "max" ]; then
  temps=($(echo "$html" | sed -nE '/[0-9]{1,2}(°C){1}/p' | tr -d "[:blank:]" | cut -c 5-6,10-12 | awk 'BEGIN{FS="|"}{print $2}' ))
fi

if [ "$calc" = "average" ]; then
  sum=0
  for t in "${temps[@]}"; do
    sum=$(echo "$sum + $t" | bc)
  done
  result=$(echo "scale=3; $sum / ${#temps[@]}" | bc)
else
  mode=$(printf '%s\n' "${temps[@]}" | sort | uniq -c | sort -nr | awk '{if ($1 == max) {print $2}} {if ($1 > max) {max=$1; val=$2}} END {if (!val) {val=$2}; print val}') 
  result=$(echo "$mode" | head -n1)
fi

echo "$(printf '%.2f' $result)"
