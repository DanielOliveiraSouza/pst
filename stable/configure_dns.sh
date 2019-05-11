#!/bin/bash

dns_file="/etc/resolvconf/resolv.conf.d/head"


if [ -e $dns_file ];then 
	dns_data=$(cat $dns_file)
	case "$dns_data" in 
		*'nameserver 8.8.8.8'*)
			echo "O DNS já está configurado"
		exit 1
		;;
	esac

	echo "nameserver 8.8.8.8" >> /etc/resolvconf/resolv.conf.d/head
	resolvconf -u
fi