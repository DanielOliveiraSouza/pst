#!/bin/bash
#O objetivo deste arquivo é  testar cada modulo do PST

#Teste 1 comando --at
bash main-pst.sh --i-d nautilus-open-terminal
./configure_dns.sh
bash main-pst.sh --at_hostname $(cat /etc/hostname )
bash main-pst.sh --t
resolvconf -u
