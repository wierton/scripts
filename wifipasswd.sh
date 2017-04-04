#!/bin/bash

cd /etc/NetworkManager/system-connections/

printf "%20s - %s\n" "ssid" "passwd"
for file in *; do
	psk=`grep "psk=" "$file" 2>/dev/null |  sed "s/psk=//g"`
	if [ -r "$file" ];then
		if [ `grep -c "type=wifi" "$file"` -eq 0 ];then
			continue
		fi
	fi
	printf "%20s : " "$file"
	if [ ! -r "$file" ];then
		printf "\033[1;31mDenied\n\033[0m"
	elif [ `grep -c "key-mgmt=" "$file"` -eq 0 ]; then
		printf "\033[1;34mNone\n\033[0m"
	elif [ "$psk" == "" ]; then
		printf "\033[1;33mUnknown\n\033[0m"
	else
		printf "\033[1;32m$psk\n\033[0m"
	fi
done
