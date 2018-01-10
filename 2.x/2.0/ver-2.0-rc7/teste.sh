#!/bin/bash
#O objetivo deste arquivo é  testar cada modulo do PST

#Teste 1 comando --at
. /$(pwd)/main-pst.sh --i-d nautilus-open-terminal
./configure_dns.sh
. / $(pwd)/main-pst --at_hostname $(cat /etc/hostname )
./ $(pwd)/main-pst.sh --t
resolvconf -u
