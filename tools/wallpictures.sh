#!/bin/bash

html="/home/wierton/cn.bing.html"
path="/home/wierton/Pictures/bing/"
his="/home/wierton/.wallpaper_history"

date=`date +%D`
if [ `grep -c "$date" "$his"` -gt 0 ];then
	exit
fi

sleep 30

ping -q -c 4 cn.bing.com &>/dev/null
if [ "$?" != "0" ];then
	notify-send "似乎没能连上网:("
	exit 0
fi

wget -q http://cn.bing.com/ -O $html --header="User-Agent:Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36"
pa_str=`grep -o "g_img={url: \"[^\"]\+" $html`
url=`echo $pa_str | sed "s/g_img={url: \"//g"`
name=`echo $pa_str | grep -o "[^\\/]\+$"`
wget -q $url -O $path$name
gsettings set org.gnome.desktop.background picture-uri "file:"$path$name
basename=`echo $name | sed "s/\(\.jpg\)//g"`
notify-send -t 30000 -i $path$name "今天的壁纸是：" "$basename"
paplay /usr/share/sounds/ubuntu/ringtones/Celestial.ogg
echo $date >> $his
