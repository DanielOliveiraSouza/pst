#!/bin/bash
# Autor: Daniel Oliveira Souza
# Este script habilita temporariamente o proxy
#exportando as variaveis de ambiente necessárias

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
	    apt-get install nasm rar unrar netbeans codeblocks eclipse 
	    apt-get clean
}


#Habilita proxy para todo usuario
Habilita_proxy
#Recebe parametro de passado pelo usuario
case $1 in 
	  atualize)
		    Repara_sistema_apt;
		   
		    Atualiza_sistema;
	  ;;
	  tudo)
		    Repara_sistema_apt;
		     
		    Atualiza_sistema; 
		    Instala_componete; 
	  ;;
	  soinstale)
		    
		    Instala_componente; 
	  ;;
	  repare) 
	
		      Repara_sistema_apt; 
	  ;;
	  instaledin)
		    
		    apt-get install $2;
	;;
	*)
	echo "Parametro invalido";
	
esac
#history -c;
#rm post-install.sh