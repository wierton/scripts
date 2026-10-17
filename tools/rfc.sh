#!/bin/bash

if [ $# -lt 1 ];then
	echo "argument need to be specified."
	exit -1
fi

browser=w3m
base_url="https://tools.ietf.org/html/rfc"

case $1 in
	ip)  $browser ${base_url}"791"  ;;
	dns) $browser ${base_url}"1035" ;;
	*)	 $browser ${base_url}$1     ;;
esac
