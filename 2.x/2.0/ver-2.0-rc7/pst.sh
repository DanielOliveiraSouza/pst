#!/bin/bash
# UNIVERSIDADE FEDERAL DE MATO GROSSO
# Autor: Daniel Oliveira Souza
# Versão:2.0.7-testing
# Descrição: Script de configuração geral do sistema apt com proxy de linux baseado em debian
# * Integridade do script 
#
versao='2.0.7-testing'
linux_modifications=""

#Determina o arquivo  de configuração do sistema apt de acordo com a versão do linux
#Determina se é necessário adicionar o evento "http_proxy"
DetectaDist(){
	linux_version=$(cat /etc/issue.net);
	APT_CONF="/etc/apt/apt.conf";
	APT_CONF_ALT="/etc/apt/apt.conf.d/01proxy";
	#Descobre se o a distribuição do linux e aplica modificaçoes em versões de pacotes
	case "$linux_version" in 
		*"Linux Mint"*)
		APT_CONF=$APT_CONF_ALT
		linux_modifications="mysql-server-5.6 kde-icon-theme-complete "
		;;
		*"LMDE"*)
		APT_CONF=$APT_CONF_ALT
		;;
		*"Ubuntu"*)
		Habilita_update_notifier;
		linux_modifications="mysql-server-5.6 "
		;;
		*"Debian"*)
		linux_modifications="mysql-server-5.5 "
	esac
}
#Contem as variaveis do sistema APT 
VariaveisAPT(){
	DetectaDist;
	APT_STRING_CONF="-o Acquire::http::Proxy="
	APT_STRING_CONF="$APT_STRING_CONF$http_proxy";
	APT_LOCK_ONE="/var/lib/apt/lists/lock";
	APT_LOCK_TWO="/var/lib/dpkg/lock";
}
#Limpa script residual caso existam dois arquivos de configuração APT
#Resolve conflitos de configuração da versão pst.sh versão 1.7
ReconfiguraAPT_CONF(){
	if [ -e $APT_CONF_ALT ] && [ "$APT_CONF" = "/etc/apt/apt.conf" ]; then
			cp $APT_CONF_ALT $APT_CONF
			rm $APT_CONF_ALT;
	fi
}
#Rotina para adicionar PPA 
AdicionaPPA(){
	apt-add-repository $2;
	apt-get update $APT_STRING_CONF;
}
#Função para alterar hostname}

AtualizaHost(){
	echo $2 | tee /etc/hostname;
	ReparaHost;
}
#Repara o hostname
ReparaHost(){
	
	hostname=$(cat /etc/hostname)
	echo "127.0.0.1	localhost" |tee /etc/hosts
	echo '127.0.1.1 $hostname' | tee -a /etc/hosts
	echo "# The following lines are desirable for IPv6 capable hosts" | tee -a /etc/hosts
	echo "::1     ip6-localhost ip6-loopback" |tee -a /etc/hosts 
	echo "fe00::0 ip6-localnet" |tee -a /etc/hosts 
	echo "ff00::0 ip6-mcastprefix" |tee -a /etc/hosts 
	echo "ff02::1 ip6-allnodes" |tee -a /etc/hosts 
	echo "ff02::2 ip6-allrouters" |tee -a /etc/hosts 
}
#Cria arquivo de configuração dados.sh
EscrevaDados1(){
	echo "#!/bin/bash" > $(pwd)/dados.sh
	echo 'flg="false";' >> $(pwd)/dados.sh
	echo 'usuario="";'	>> $(pwd)/dados.sh
	echo 'senha="";'     >>  $(pwd)/dados.sh
	echo 'servidor_proxy="'$server'";'>> $(pwd)/dados.sh
	echo 'porta="'$port'";' >> $(pwd)/dados.sh
	chmod a+x $(pwd)/dados.sh
}
#
EscrevaDados2(){
	echo "Entre com o login:"
	read usr
	echo "Digite a senha"
	read -s cod
	echo '#!/bin/bash'> $(pwd)/dados.sh
	echo 'flg="true";' >> $(pwd)/dados.sh
	echo 'usuario="'$usr'";'>> $(pwd)/dados.sh
	echo 'senha="'$cod'";' >> $(pwd)/dados.sh
	echo 'servidor_proxy="'$server'";' >> $(pwd)/dados.sh
	echo 'porta="'$port'";' >> $(pwd)/dados.sh
	chmod a+x $(pwd)/dados.sh
}
#Atualiza os dados do arquivo dados.sh 
AtualizaDados(){
	if [ -e $(pwd)/dados.sh ] && [ -x $(pwd)/dados.sh ] ; then 
		. /$(pwd)/dados.sh
		case "$2" in
			"--tudo")
				rm $(pwd)/dados.sh
				CriarDados
			;;
			"--login")
				flg=$flag
				server=$servidor_proxy 
				port=$porta
				EscrevaDados2 $server $port
				;;
				*)
					echo "Nada a atualizar "	
				;;
		esac
	fi
				
}
#Meta-função que determina o conteúdo que dados.sh deve armazenar.
CriarDados(){
	#Variaveis locais 
	flg=''
	server=''
	port=''
	echo "O proxy é autenticado digite true OU false "
	read flg
#Verifica se o $flag esta com os valores corretos
	while true  
	do 
    	if [ "$flg" = "true" ]; then
    			break;
    		else
    			if [ "$flg" = "false" ]; then
    				break;
    			else
    				echo "Erro: true ou false"
    				read flg;
    		fi		fi
	done 
	echo "Digite o numero do servidor proxy"
	read server
	echo "Digite o numero da porta"
	read  port

	if [ "$flg" = "true" ]
		#O proxy é autenticado, le os dados e cria o arquivo
		then
			EscrevaDados2 $server $port $flag
		else
				EscrevaDados1 $server $port 
		fi
}
LeiaDados(){
	if [ -e $(pwd)/dados.sh ] ; then 
			if [ -x $(pwd)/dados.sh ]
				then
					. /$(pwd)/dados.sh
			else
				chmod +x $(pwd)/dados.sh;
				. /$(pwd)/dados.sh
			fi

		else 
			if [ "$1" = "--at_dados" ] ; then # correção bug ovo/galinha do script dados.sh
				echo "Não existe arquivo para ser atualizado";
				exit 1;
			else
			#Se chegou aqui é porque o arquivo não existe, vamos criar :)
				echo "Arquivo base de configuração ainda não foi criado:"
				CriarDados;
				. /$(pwd)/dados.sh
			fi
		fi
}
Ajuda(){
	if [ -e $(pwd)/ajuda.txt ]
		then
		more ajuda.txt
	fi
}
#Adiciona o evento http_proxy ao /etc/sudoers
Habilita_update_notifier(){
if [ -e /etc/sudoers.backup ]
	then
		true;
	else
		cp /etc/sudoers /etc/sudoers.backup
		echo "#Instrução oficial para habilitar proxy no update-notifier" >> /etc/sudoers
		echo "#Referencia: http://askubuntu.com/questions/140558/12-04-lts-flashplugin-installer-problem" |tee -a /etc/sudoers
		echo 'Defaults env_keep="http_proxy" ' >> /etc/sudoers
	fi
}
#Restaura o estado anterior o script /etc/sudoers
Restaura_etc_sudoers(){
if [ -e /etc/sudoers.backup ] ; then
	if [ -e  $APT_CONF ]; then
		true;
	else
		cp /etc/sudoers.backup /etc/sudoers #desabilitando o uso do proxy em condições temporárias
		rm /etc/sudoers.backup
		echo "Feito!!";
	fi
fi
}
#Verifica  e repara possiveis erros no sitema APT e DPKG
Repara_sistema_apt(){
	dpkg --configure -a
	if [ -e  $APT_LOCK_ONE ]
		then
			rm $APT_LOCK_ONE
	fi
	if [ -e  $APT_LOCK_TWO ]
		then 
			rm $APT_LOCK_TWO;
	fi
	apt-get -f install $APT_STRING_CONF '--force-yes';
}
#Função chave do programa pst  
Habilita_proxy(){
	
	if [  "$flg" = "true" ]
		then
			export http_proxy="http://$usuario:$senha@$servidor_proxy:$porta"
			export socks_proxy="socks://$servidor_proxy:$porta/"
			export https_proxy="https://$usuario:$senha@$servidor_proxy:$porta"
			export ftp_proxy="ftp://$usuario:$senha@$servidor_proxy:$porta"

		else 
			export http_proxy="http://$servidor_proxy:$porta"
			export socks_proxy="socks://$servidor_proxy:$porta"
			export https_proxy="https://$servidor_proxy:$porta"
			export ftp_proxy="ftp://$servidor_proxy:$porta"
		fi
}
#Atualiza o sistema  :) porém com a vantagem de fazer requisões wget se uma atualização necessitar
Atualiza_sistema(){
	apt-get  update  $APT_STRING_CONF
	apt-get dist-upgrade $APT_STRING_CONF  '-y'
}
#Criada para ser usada nos laboratórios de computação. Instala componentes importantes para programar
Instala_componente(){
	
	progr_install="gcc kate konsole codeblocks build-essential checkinstall cdbs devscripts dh-make fakeroot libxml-parser-perl check avahi-daemon "
	progr_install=$progr_install"libncurses5 libncurses5-dev ncurses-base ncurses-bin ncurses-term "
	progr_install=$progr_install"g++ nasm openjdk-7-jdk libmysqlcppconn-dev logisim gnat  "
	progr_install=$progr_install"wireshark traceroute phpmyadmin apache2 php5 flex bison emacs  "
	progr_install=$progr_install"freeglut3 freeglut3-dev libglew1.5 libglew1.5-dev libglu1-mesa libglu1-mesa-dev libgl1-mesa-glx libgl1-mesa-dev "
	progr_install=$progr_install"libpqxx-4.0 libpqxx-dev  postgresql libpqxx3-doc  libpostgresql-jdbc-java " 
	progr_install=$progr_install"qgis postgis  "
	progr_install=$progr_install$linux_modifications

	apt-get install  $progr_install  -y --force-yes $APT_STRING_CONF
	#Teste para verificar se o apt-get foi executado com sucesso e limpa o cache, caso contrário não faz nada.
	if [ "$?" = "0" ]; then
		apt-get clean
	fi
}
Escreve_apt(){
	echo 'Acquire::http::Proxy "'$http_proxy'/";'>  $APT_CONF
	echo 'Acquire::ftp::Proxy "'$ftp_proxy'/";' >> $APT_CONF
	#echo 'Acquire::socks::Proxy "'$socks_proxy'";'| tee -a $APT_CONF
	#echo 'Acquire::ssl::Proxy "' $http_proxy'";'| tee -a $APT_CONF
}
#Cria o arquivo de configuração file.txt e salva no diretorio local. O objetivo é criar o arquivo /etc/apt/apt.conf
Cria_APT_CONF(){
	if [ -e $APT_CONF ]
		then
			if [ "$2" = "--force" ] #Sobrescreve arquivo 
				then 
					Escreve_apt;
			fi
		else
			Escreve_apt	
		fi	
}
#Remove o arquivo /etc/apt/apt.conf, função experimental
Remove_APT_CONF(){
	if [ -e $APT_CONF ]
	then 
		rm $APT_CONF
	fi
}

Imprime(){
	echo 'http_proxy='$http_proxy
	echo 'ftp_proxy='$ftp_proxy
	echo 'https_proxy='$http_proxy
}