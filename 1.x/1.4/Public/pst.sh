#!/bin/bash
# UNIVERSIDADE FEDERAL DE MATO GROSSO
# Autor: Daniel Oliveira Souza
# Versão: 1.4
# Descrição: Script de configuração geral do sistema apt com proxy de linux baseado em debian
#
versao='1.4'
Ajuda(){
      echo "Post-install é um script que configura temporariamente, que permite a reparação, a atualização e a instalação de um ou mais componentes.
      Ideal para quem possui internet em sua casa e não quer que o proxy seja habilitado fixamente. Ou habilitar o proxy em uma máquina sem ter que 
      configura-lo manualmente. O primeiro argumento é a função que deseja chamar. Apenas a função instalacao_dinamica aceita mais de um argumento.
      ";
      echo "Digite: post-install-fina-public.sh [arg]";
      echo "--ajuda ou --aj.
      Exibe ajuda.
      ";
      
      echo "--atualize ou --at
      Para atualizar o sistema
      ";
      
      echo "--configure_etc_sudores ou --conf-sudoers
      Faz o backup do arquivo /etc/sudoers e
      Adiciona instrução para o update-notifier usar o proxy. 
      Esta instrução deve ser executada uma única vez.
      Caso queira desconfigurar o /etc/sudoers. Use o comando --restaure_etc_sudoers;
      Note: Isto é válido  apenas para ubuntu
      ";
      
      echo "--instalacao_dinamica nome_do programa. ou --i-d
      Recebe no máximo cinco argumentos. Digite o nome de até cinco programas que deseja instalar.
      ";
      
      echo "--instalacao_estatica ou --i-e
      Para instalar itens importantes sem procurar por atualizaçoes
      ";
      echo "--restaure_etc_sudoers --reconf-sudoers
      Restaura o arquivo /etc/sudoers ao estado anterior ao comando --configure-update-notifier
      ";
      echo "--tudo ou --t	
      Para atualizar e instalar itens importantes (estatico)
      ";
      echo "--version ou --v
      Imprime a versão do arquivo";
      echo "Exemplo de uso: 
      ./post-install-final-public.sh --i-d openjdk-7-jdk";
	      
}
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
Restaura_etc_sudoers(){
	  if [ -e /etc/sudoers.backup ]
	      then
		    cp /etc/sudoers.backup /etc/sudoers
		    rm /etc/sudoers.backup
		    echo "Feito!!";
	      fi
}
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
#Função chave do programa post-
Habilita_proxy(){
	  export http_proxy="http://ra:senha@10.0.16.1:3128"
	  export socks_proxy="socks://ra:senha@10.0.16.1:3128"
	  export https_proxy=$http_proxy
	  export ftp_proxy=$http_proxy
}
Atualiza_sistema(){
	apt-get  update -o Acquire::http::Proxy=$http_proxy 
	apt-get dist-upgrade -o  Acquire::http::Proxy=$http_proxy 
}

Instala_componente(){
	  apt-get install  kate konsole gcc g++ build-essential checkinstall cdbs devscripts dh-make fakeroot libxml-parser-perl check avahi-daemon  netbeans codeblocks eclipse -o Acquire::http::Proxy=$http_proxy
	  apt-get clean
}

#Chama a funç
	  Habilita_proxy
	  case $1 in 
		--version)
		echo "Post-install-sh versão $versao	
		Desenvolvido por: Daniel Oliveira Souza ";
		;;
		--ajuda)
			  Ajuda;
		;;
		--atualize)
			  Repara_sistema_apt;
			  Atualiza_sistema;
		;;
		--tudo)
			  Repara_sistema_apt;
			  Atualiza_sistema; 
			  Instala_componete; 
		;;
		--instalacao_estatica)
			  Repara_sistema_apt;
			  Instala_componente; 
		;;
		--instalacao_dinamica)
			  Repara_sistema_apt;
			  apt-get install $2 $3 $4 $5 $6 $7 -o  Acquire::http::Proxy=$http_proxy; 
		;;
		--configure_etc_sudoers)
			  Habilita_update_notifier;
		;;
		--restaure_etc_sudoers)
			  Restaura_etc_sudoers;	     
		;;
		
		--aj)
			  Ajuda;
		;;
		--at)	
			  Repara_sistema_apt;
			  Atualiza_sistema;
		;;
		--t)	Repara_sistema_apt;
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
		--conf-sudoers)
			  Habilita_update_notifier;
		;;
		--reconf-sudoers)
			  Restaura_etc_sudoers;	     
		;;
		--v)
			echo "Post-install-sh versão $versao	
		Desenvolvido por: Daniel Oliveira Souza ";
		;;
		    
		*)  echo "Parametro invalido";
		;;
	  esac
	  #history -c;
	  #rm post-install.sh
