#!/bin/bash
# UNIVERSIDADE FEDERAL DE MATO GROSSO
# Autor: Daniel Oliveira Souza
# Versão: 1.7
# Descrição: Script de configuração geral do sistema apt com proxy de linux baseado em debian
#
versao='1.7'
#idesum="netbeans"
#ideecl="eclipse eclipse-jdt eclipse-cjt"
ReparaHost(){
	$host_name= $(cat /etc/hostname)
	echo "127.0.0.1	localhost" |tee /etc/hosts
	echo "127.0.1.1"	$host_name'.local'  $host_name | tee -a /etc/hosts
	echo "# The following lines are desirable for IPv6 capable hosts" | tee -a /etc/hosts
	echo "::1     ip6-localhost ip6-loopback" |tee -a /etc/hosts 
	echo "fe00::0 ip6-localnet" |tee -a /etc/hosts 
	echo "ff00::0 ip6-mcastprefix" |tee -a /etc/hosts 
	echo "ff02::1 ip6-allnodes" |tee -a /etc/hosts 
	echo "ff02::2 ip6-allrouters" |tee -a /etc/hosts  
}
Ajuda(){
	echo "pst é um script que configura temporariamente, que permite a reparação, a atualização e a instalação de um ou mais componentes.
	Ideal para quem possui internet em sua casa e não quer que o proxy seja habilitado fixamente. Ou habilitar o proxy em uma máquina sem ter que 
	configura-lo manualmente. O primeiro argumento é a função que deseja chamar. Apenas a função instalacao_dinamica aceita mais de um argumento.
	";
	echo "Digite: pst [arg]";
	echo "--aj
	Exibe ajuda.
	";

	echo "--at
	Para atualizar o sistema
	";

	echo "--cr_apt
	Cria o arquivo /etc/apt/apt.conf";

	echo "--conf-sudoers
	Faz o backup do arquivo /etc/sudoers e
	Adiciona instrução para o update-notifier usar o proxy. 
	Caso queira desconfigurar o /etc/sudoers. Use o comando --reconf-sudoers;
	Note: Isto é válido  apenas para ubuntu
	";

	echo "--i-d
	Recebe no máximo cinco argumentos. Digite o nome de até cinco programas que deseja instalar.
	";

	echo "--i-e
	Para instalar itens importantes sem procurar por atualizaçoes
	";
	echo "--reconf-sudoers
	Restaura o arquivo /etc/sudoers ao estado anterior ao comando --conf-sudoers
	";
	echo "--rm_apt	
	Remove o arquivo /etc/apt/apt.conf
	";
	echo "--t	
	Para atualizar e instalar itens importantes (estatico)
	";
	echo "--v
	Imprime a versão do arquivo";
	echo "Exemplo de uso: 
	pst.sh --i-d openjdk-7-jdk";
}
#Adiciona o evento http_proxy ao /etc/sudoers
Habilita_update_notifier(){
if [ -e /etc/sudoers.backup ]
	then
		echo "O Sistema já está configurado";
	else
		cp /etc/sudoers /etc/sudoers.backup
		echo "#Instrução oficial para habilitar proxy no update-notifier" |tee -a /etc/sudoers
		echo "#Referencia: http://askubuntu.com/questions/140558/12-04-lts-flashplugin-installer-problem" |tee -a /etc/sudoers
		echo 'Defaults env_keep="http_proxy" '| tee -a /etc/sudoers
	fi
}
#Restaura o estado anterior o script /etc/sudoers
Restaura_etc_sudoers(){
if [ -e /etc/sudoers.backup ]
	then
		cp /etc/sudoers.backup /etc/sudoers
		rm /etc/sudoers.backup
		echo "Feito!!";
	fi
}
#Verifica  e repara possiveis erros no sitema APT e DPKG
Repara_sistema_apt(){
	dpkg --configure -a

	if [ -e /var/lib/apt/lists/lock  ]
		then
			rm /var/lib/apt/lists/lock
	fi
	if [ -e  /var/lib/dpkg/lock ]
		then 
			rm /var/lib/dpkg/lock;
	fi
	apt-get -f install -o  Acquire::http::Proxy=$http_proxy
}
#Função chave do programa pst  
Habilita_proxy(){
	export http_proxy="http://201311722045:42959908848@10.0.16.1:3128"
	export socks_proxy="socks://201311722045:42959908848@10.0.16.1:3128"
	export https_proxy=$http_proxy
	export ftp_proxy=$http_proxy
}

#Atualiza o sistema  :) porém com a vantagem de fazer requisões wget se uma atualização necessitar
Atualiza_sistema(){
	apt-get  update -o Acquire::http::Proxy=$http_proxy 
	apt-get dist-upgrade -o  Acquire::http::Proxy=$http_proxy 
}
#Criada para ser usada nos laboratórios de computação. Instala componentes importantes para programar
Instala_componente(){
	$prog="latex kile latex-beamer"
	apt-get install  kate konsole gcc g++ build-essential apache mysql-server-5.5 phpmyadmin flex bison   -o Acquire::http::Proxy=$http_proxy
	Habilita_update_notifier
	#sudo add-apt-repository ppa:paolorotolo/android-studio
	#sudo apt-get update
	#sudo apt-get install android-studio
	#apt-get clean
}
#Cria o arquivo de configuração file.txt e salva no diretorio local. O objetivo é criar o arquivo /etc/apt/apt.conf
Cria_APT_CONF(){
if [ -e /etc/apt/apt.conf.d/01proxy  ]
kki		echo "O arquivo já existe"
	else
		echo 'Acquire::http::Proxy "'$http_proxy'";'|tee  /etc/apt/apt.conf.d/01proxy 
		echo 'Acquire::ftp::Proxy "'$ftp_proxy'";'|tee -a /etc/apt/apt.conf.d/01proxy 
		echo 'Acquire::socks::Proxy "'$socks_proxy'";'| tee -a /etc/apt/apt.conf.d/01proxy 
		echo 'Acquire::https::Proxy "' $https_proxy'";'|tee -a /etc/apt/apt.conf.d/01proxy 
		echo 'Acquire::ssl::Proxy "' $http_proxy'";'| tee -a /etc/apt/apt.conf.d/01proxy 
	fi	
}
#Remove o arquivo /etc/apt/apt.conf, função experimental
Remove_APT_CONF(){
	if [ -e /etc/apt/apt.conf.d/01proxy ]
	then 
		rm /etc/apt/apt.conf.d/01proxy
	else
		echo "Este arquivo não existe"
	fi
}
#Função principal
Principal(){
	Habilita_proxy
	case $1 in 
		--aj)
		Ajuda;
		;;
		--at)	
			Repara_sistema_apt;
			Atualiza_sistema;
		;;
		--t)	
			Repara_sistema_apt;
			Atualiza_sistema; 
			Instala_componete; 
		;;
		--i-e)
			
			Repara_sistema_apt;
			Instala_componente; 
			;;
		
		--i-d)
			Repara_sistema_apt;
			apt-get install $2 $3 $4 $5 $6 $7 -o  Acquire::http::Proxy=$http_proxy; 
			;;
		--conf_sudoers)
			Habilita_update_notifier;
		;;
		--reconf_sudoers)
			Restaura_etc_sudoers;	     
		;;
		--reconf_hosts)
			ReparaHost;
		;;
		--v)
			echo "pst-sh versão $versao	
			Desenvolvido por: Daniel Oliveira Souza ";
		;;
		--cr_apt)
			Cria_APT_CONF;
		;;
		--rm_apt)
			Remove_APT_CONF;
			 
		;;
		*)  
			echo "Parametro invalido";
			Ajuda;
		;;
	esac
}
#Chamda da função principal, referenciado os parametros
Principal $1 $2 $3 $4 $5 $6 $7;