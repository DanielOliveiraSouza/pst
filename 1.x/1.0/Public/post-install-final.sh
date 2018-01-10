#!/bin/bash
# UNIVERSIDADE FEDERAL DE MATO GROSSO
# Autor: Daniel Oliveira Souza
# Versão: 1.0
# Descrição: Script de configuração geral de linux baseado em debian
#

Repara_sistema_apt(){
	  dpkg --configure -a
	  if [ -e /var/lib/apt/lists/lock ]
	  then
	  
	  rm /var/lib/apt/lists/lock
	  fi
	  
	  if [ -e  /var/lib/dpkg/lock ]
	  then 
	  
	  rm /var/lib/dpkg/lock;
	  fi
	
}
Habilita_update_notifier(){
		if [ -e /etc/sudoers ]
		then
		cp /etc/sudoers /etc/sudoers.backup
		echo "#Instrução oficial para habilitar proxy no update-notifier" |tee -a /etc/sudoers
		echo "#Referencia: http://askubuntu.com/questions/140558/12-04-lts-flashplugin-installer-problem" |tee -a /etc/sudoers
		echo "Defaults env_keep="http_proxy" "| tee -a /etc/sudoers
		fi
}
Habilita_proxy(){
	   export http_proxy="http://201311722045:42959908848@10.0.16.1:3128"
	  export socks_proxy="socks://201311722045:42959908848@10.0.16.1:3128"
	  export https_proxy=$http_proxy
	  export ftp_proxy=$http_proxy
}
Atualiza_sistema(){
	  apt-get  update -o Acquire::http::Proxy=$http_proxy 
	  apt-get dist-upgrade -o  Acquire::http::Proxy=$http_proxy
	 }
Instala_componente(){
	    apt-get install  kate konsole openjdk-7-jdk gcc g++ build-essential checkinstall cdbs devscripts dh-make fakeroot libxml-parser-perl check avahi-daemon -y -o  Acquire::http::Proxy= $http_proxy
	    apt-get install nasm rar unrar netbeans codeblocks eclipse -o Acquire::http::Proxy=$http_proxy
	    apt-get clean
}

#Chama a função de acordo com o parametro passado pelo usuário pela linha de comando
Habilita_proxy
Repara_sistema_apt

case $1 in 
	  atualize)
		Atualiza_sistema;
	  ;;
	  tudo)
		Atualiza_sistema; 
		Instala_componete; 
	  ;;
	  soinstale)
		Instala_componente; 
	  ;;
	  instaledin)
		apt-get install $2 $3 $4 $5 $6 $7; 
	  ;;
	configure-update-notifier)
		Habilita_update_notifier;
	;;

	  *)
	  echo "Parametro invalido";
	;;
esac
#history -c;
#rm post-install.sh
