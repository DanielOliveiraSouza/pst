#!/bin/bash
# UNIVERSIDADE FEDERAL DE MATO GROSSO
# Autor: Daniel Oliveira Souza
# Versão:2.0-rc2
# Descrição: Script de configuração geral do sistema apt com proxy de linux baseado em debian
#
versao='2.0'
idesum="netbeans"
ideecl="eclipse eclipse-jdt eclipse-cjt"
arg2=$2
InterfaceGrafica(){
 	#dialogo zero 
 	case $op in
 		1)
 			flg=$(zenity  --title " Dialoge "  --question --text "O proxy é autenticado?" );
 		;;
 	esac
}
EscrevaDados1(){
	echo 'flg="false";' | tee $(pwd)/dados.sh
	echo 'usuario="";'	| tee -a $(pwd)/dados.sh
	echo 'senha="";'     | tee -a $(pwd)/dados.sh
	echo 'servidor_proxy="'$server'";' | tee -a $(pwd)/dados.sh
	echo 'porta="'$port'";' | tee -a $(pwd)/dados.sh
	chmod a+x $(pwd)/dados.sh
}
EscrevaDados2(){
	echo "Entre com o login:"
	read usr
	echo "Digite a senha:"
	read cod
	echo '#!/bin/bash' | tee $(pwd)/dados.sh
	echo 'flg="true";' | tee -a $(pwd)/dados.sh
	echo 'usuario="'$usr'";'| tee -a  $(pwd)/dados.sh
	echo 'senha="'$cod'";'|tee -a $(pwd)/dados.sh
	echo 'servidor_proxy="'$server'";' | tee -a $(pwd)/dados.sh
	echo 'porta="'$port'";' | tee -a $(pwd)/dados.sh
	chmod a+x $(pwd)/dados.sh
}
AtualizaDados(){
	server=''
	if [ -x $(pwd)/dados.sh ]
		then 
			. /$(pwd)/dados.sh
			case $arg2 in
				--t)
					rm $(pwd)/dados.sh
					CriarDados
				;;
				--login)
					flg=$flag
					server=$servidor_proxy 
					port=$porta
					EscrevaDados2 $server $port
					;;
					*)
						echo "Nada a atualizar !! Falta um argumento: --login ou --t  "	
					;;
			esac
		fi
				
}
CriarDados(){
	#Variaveis locais 
	flg=''
	server=''
	port=''
	echo "Primeiro: cadastre o proxy "
	#flg=$(zenity  --title " Dialoge "  --question --text "O proxy é autenticado?" )
	op=1
	InterfaceGrafica $op
#Verificase o $flg esta com os valores corretos
	#while true  
	#do 
    	#if [ "$flg" = "1" ]
  #  	#	then
   # 			break;
   # 		else
   # 			if [ "$flg" = "0" ]
   # 				then
   # 				break;
  #  			else
  #  				echo "Erro: true ou false"
   # 				read flg;
  #  		fi		fi
	#done 
	echo "Digite o numero do servidor proxy:"
	read server
	echo "Digite o numero da porta:"
	read  port

	if [ "$flg" = "true" ]
		#O proxy é autenticado, le os dados e cria o arquivo
		then
			EscrevaDados2 $server $port
		else
			EscrevaDados1 $server $port 
		fi
}
#Carrega os dados do script 
LeiaDados(){
	if [ -e $(pwd)/dados.sh ] 
		then
			#Temos um arquivo, ação ->executar
			if [ -x $(pwd)/dados.sh ]
				then
					. /$(pwd)/dados.sh
				fi
		else 
			#Se chegou aqui é porque o arquivo não existe, vamos criar :)
			CriarDados;
			. /$(pwd)/dados.sh
		fi
}
Ajuda(){
	echo "Digite: pst [arg]";
	echo "--aj
	Exibe ajuda.
	";
	echo "--at
	Para atualizar o sistema
	";
	echo "--at-dados --login (NOVO)
	Altera o login 
	";
	echo "--at--dados --t
	Altera todos os dados referente ao proxy
	"
	echo "--cr-apt
	Cria o arquivo /etc/apt/apt.conf.d/01proxy";
	echo "--conf-sudoers
	Faz o backup do arquivo /etc/sudoers e
	Adiciona instrução para o update-notifier usar o proxy. 
	Caso queira desconfigurar o /etc/sudoers. Use o comando --reconf-sudoers
	Note: Isto é válido  apenas para ubuntu
	";
	echo "--i-d
	Recebe no máximo cinco argumentos. Digite o nome de até cinco programas que deseja instalar.
	";
	echo "--i-e
	Para instalar itens importantes sem procurar por atualizaçoes
	";
	echo "--ls-dados (NOVO)
	Exibe as variaveis de ambiente proxy do sistema
	";
	echo "--reconf-sudoers
	Restaura o arquivo /etc/sudoers ao estado anterior ao comando --conf-sudoers
	";
	echo "--rm-apt	
	Remove o arquivo /etc/apt/apt.conf.d/01proxy
	";
	echo "--t	
	Para atualizar e instalar itens importantes (estatico)
	";
	echo "--v
	Imprime a versão do arquivo";
	echo "Exemplo de uso: 
	pst.sh --i-d openjdk-7-jdk";
}
Instalar(){
	if [ -e /usr/bin/pst && -e /opt/post-install/pst.sh && -e /opt/post-install/dados.sh -e && /opt/post-install/version ]
		then
			if [ $version  -eq $(cat /opt/post-install/version) ]
				then 
					echo "O script esta atualizado  ";
				else
					cp $(pwd)/pst.sh /opt/post-install/pst.sh ;
					cp $(pwd)/version /opt/post-install/pst.sh
					cp $(pwd)/dados.sh /opt/post-install/dados.sh
					ln -s /opt/post-install/pst.sh /usr/bin/pst
				fi
		else 
			mkdir /opt/post-install
			cp $(pwd)/pst.sh /opt/post-install
			cp $(pwd)/version /opt/post-install
		fi
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
	LeiaDados
	if [  "$flg" = "true" ];
		then
			export http_proxy='"http://'$usuario:$senha'@'$servidor_proxy':'$porta'"'
			export socks_proxy='"socks://'$usuario:$senha'@'$servidor_proxy':'$porta'"'
			export https_proxy='"https://'$usuario:$senha'@'$servidor_proxy':'$porta'"'
			export ftp_proxy=$http_proxy
		else 
			export http_proxy='"http://'$servidor_proxy:$porta'"'
			export socks_proxy='"socks://'$servidor_proxy:$porta'"'
			export https_proxy='"https://'$servidor_proxy:$porta'"'
			export ftp_proxy=http_proxy
		fi
}
#Atualiza o sistema  :) porém com a vantagem de fazer requisões wget se uma atualização necessitar
Atualiza_sistema(){
	apt-get  update -o Acquire::http::Proxy=$http_proxy 
	apt-get dist-upgrade -o  Acquire::http::Proxy=$http_proxy 
}
#Criada para ser usada nos laboratórios de computação. Instala componentes importantes para programar
Instala_componente(){
	apt-get install  kate konsole gcc g++ build-essential checkinstall cdbs devscripts dh-make fakeroot libxml-parser-perl check avahi-daemon  $idesum $ideecl -o Acquire::http::Proxy=$http_proxy
	apt-get clean
}
#Cria o arquivo de configuração file.txt e salva no diretorio local. O objetivo é criar o arquivo /etc/apt/apt.conf
Cria_APT_CONF(){ 
if [ -e /etc/apt/apt.conf.d/01proxy  ]
	then
		echo "O arquivo já existe"
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
 Imprime(){
	echo 'http_proxy='$http_proxy
	echo 'ftp_proxy='$ftp_proxy
	echo 'https_proxy='$http_proxy
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
		--conf-sudoers)
			Habilita_update_notifier;
		;;
		--reconf-sudoers)
			Restaura_etc_sudoers;	     
		;;
		--v)
			zenity --info --text "pst-sh versão $versao 
			Desenvolvido por: Daniel Oliveira Souza 
			Compativel com: Debian/Ubuntu/Mint";
		;;
		--cr-apt)
			Cria_APT_CONF;
		;;
		--rm-apt)
			Remove_APT_CONF;
			 
		;;
		--ls-dados)
			Imprime;
			;;
		--at-dados)
			AtualizaDados
		;;
		*)  
			echo "Parametro invalido";
			Ajuda;
		;;
	esac
}
#Chamda da função principal, referenciado os parametros
Principal $1 $2 $3 $4 $5 $6 $7;