#!/bin/bash

LINK=$(
curl -Ls 'http://www.socksproxylist24.top/search/label/Socks%20Proxy%20List' | egrep -o 'http....+socksproxylist24.+proxy\-list\.html' | grep -v blogger | head -1)

curl -Ls ${LINK} | egrep -o '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\:[0-9]+' | sort | uniq > stmp.txt

function checkSOCKS {
	#echo -en "$1, "
	RES=$(curl -s -m3 --socks5 $1 'https://api.ipify.org?format=json' | egrep 'ip.:.' | wc -l)
	if [ $RES -ge 1 ]; then
		echo -en "\033[999D\033[K\r\n" 1>&2
		echo -en "\033[0;32m200 OK:\033[0m $1\n"
	else
		echo -en "\033[999D\033[K\r" 1>&2
		echo -en "[$2] Timeout $1"
	fi
}

i=0
COUNT=0
echo -e "Trying SOCKS:"
while read line
do
	if [ $COUNT -lt 11 ]; then
		checkSOCKS $line $i &
		COUNT=$[$COUNT+1]
		i=$[$i+1]
	else
		COUNT=0;
		sleep 5
	fi
done<stmp.txt
