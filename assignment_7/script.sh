#!/bin/bash

if [[ $# -eq 0 ]]; then
       	echo 'Usage: ./script.sh city-name [-C min|max|current] [-W] [-S]'
	exit 0
fi

city=$1
shift

url="http://weather.local/api/v1/city/${city}.json"

while getopts "C:WS" option; do
       	case $option in
		C)
		       	case $OPTARG in
				min)
					jq -r --indent 4 '{name: .name, temp_min: .main.temp_min}' < <(curl -s "$url")
					;;
				max)
					jq -r --indent 4 '{name: .name, temp_max: .main.temp_max}' < <(curl -s "$url")
					;;
				current)
					jq -r --indent 4 '{name: .name, temp: .main.temp, F: (.main.temp * 1.8 + 32)} | {name, temp, F}' < <(curl -s "$url")
					;;
			esac
			;;
		S)
			city_name=$(jq -r '.name' < <(curl -s "$url")) 
			date=$(date +%d/%m/%Y)
			sunrise=$(date -d @$(jq -r '.sys.sunrise' < <(curl -s "$url")) +%T)
		       	sunset=$(date -d @$(jq -r '.sys.sunset' < <(curl -s "$url")) +%T)
                        #echo "[$city_name, $date, $sunrise, $sunset]"
			jq -n --arg city_name "$city_name" --arg date "$date" --arg sunrise "$sunrise" --arg sunset "$sunset" '[ $city_name, $date, $sunrise, $sunset ]'
			;;
		W)
			jq -r --indent 4 '{name: .name, speed: .wind.speed, sqrtspeed: (.wind.speed | sqrt)}' < <(curl -s "$url")
			;;
	esac
done
