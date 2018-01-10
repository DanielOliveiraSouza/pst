#!/bin/bash
dns_file=$(cat /etc/resolvconf/resolv.conf.d/head)
case "$dns_file" in 
	*'nameserver 8.8.8.8'*)
		echo "O DNS já está configurado"
	exit 1
	;;
esac

echo "nameserver 8.8.8.8" >> /etc/resolvconf/resolv.conf.d/head
resolvconf -u