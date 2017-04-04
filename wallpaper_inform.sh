#!/bin/bash

date=`date +%D`
his="/home/wierton/.wallpaper_history"
log="/home/wierton/.wallpaper_log"
record=`grep "^$date" "$log"`

if [ `grep -c "notify-send $date$" "$log"` -gt 0 ];then
	exit
fi

sleep 30

if [ `grep -c "404" $record` -gt 0 ];then
	notify-send "似乎没能连上网:("
else
	path="/home/wierton/Pictures/bing/"
	name=`cat $his`
	basename=`cat $his | sed "s/\(\.jpg\)//g"`
	notify-send -t 100000 -i $path$name "今天的壁纸是：" "$basename"
	paplay /usr/share/sounds/ubuntu/ringtones/Celestial.ogg
	echo "notify-send $date" >> $log
fi
