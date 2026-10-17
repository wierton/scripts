#!/bin/bash

html="/home/wierton/cn.bing.html"
path="/home/wierton/Pictures/bing/"
his="/home/wierton/.wallpaper_history"
log="/home/wierton/.wallpaper_log"
back="/home/wierton/Pictures/Wallpapers/wallpaper.jpg"

date=`date +%D`
if [ `grep -c "^$date" "$log"` -gt 0 ];then
	exit
fi

ping -q -c 4 cn.bing.com &>/dev/null
if [ "$?" != "0" ];then
	echo "$date 404" >> $log
	exit 0
fi

wget -q http://cn.bing.com/ -O $html --header="User-Agent:Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36"
pa_str=`grep -o "g_img={url: \"[^\"]\+" $html`
url=`echo $pa_str | sed "s/g_img={url: \"//g"`
name=`echo $pa_str | grep -o "[^\\/]\+$"`
wget -q $url -O $path$name
cp $path$name $back
echo "$date 200" >> $log
echo $name > $his

#echo $date >> $log
#gsettings list-recursively org.gnome.desktop.background >> $log
#gsettings set org.gnome.desktop.background picture-uri $gs_path
#echo $gs_path >> $log
#gsettings list-recursively org.gnome.desktop.background >> $log
#echo >> $log
