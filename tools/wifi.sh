#!/bin/sh  

wifi=`iwconfig | grep -o '^wl\w*'`  
echo "Wifi interface: $wifi"  
gw=`ip addr show $wifi | head -3 | tail -1 | awk '{print $2}'`  
echo "Wifi IP: "$gw  
gw=`echo $gw | awk -F. '{printf("%s.%s.%s.1",$1,$2,$3)}'`  
echo "Wifi gateway: "$gw  
echo "Set the Wifi gateway as the default gw now"  
route delete default  
route add default gw $gw  
echo "Set the Wifi gateway as the default gw end"  
