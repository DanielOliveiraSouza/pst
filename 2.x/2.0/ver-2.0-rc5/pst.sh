#!/bin/bash
# UNIVERSIDADE FEDERAL DE MATO GROSSO
# Autor: Daniel Oliveira Souza
# Versão:2.0-rc5-stable
# Descrição: Script de configuração geral do sistema apt com proxy de linux baseado em debian
# * Integridade do script 
#
versao='2.0-rc5-stable'

#Determina o arquivo  de configuração do sistema apt de acordo com a versão do linux
#Determina se é necessário adicionar o evento "http_proxy"
DetectaDist(){
	linux_version=$(cat /etc/issue.net);
	apt_conf="/etc/apt/apt.conf";
	apt_conf_alt="/etc/apt/apt.conf.d/01proxy";
	#Descobre se o a distribuição do linux é mint 
	case "$linux_version" in 
		*"Linux Mint"*)
		apt_conf=$apt_conf_alt
		;;
		*"LMDE"*)
		apt_conf=$apt_conf_alt
		;;
		*"Ubuntu"*)
		Habilita_update_notifier;
		;;
	esac
}
#Contem as variaveis do sistema APT 
VariaveisAPT(){
	DetectaDist;
	apt_string_conf="-o Acquire::http::Proxy="$http_proxy;
	apt_lock_one="/var/lib/apt/lists/lock";
	apt_lock_two="/var/lib/dpkg/lock";
}
#Limpa script residual caso existam dois arquivos de configuração APT
#Resolve conflitos de configuração da versão pst.sh versão 1.7
ReconfiguraAPT_CONF(){
	if [ -e $apt_conf_alt ] && [ "$apt_conf" = "/etc/apt/apt.conf" ]; then
			cp $apt_conf_alt $apt_conf
			rm $apt_conf_alt;
	fi
}
#Rotina para adicionar PPA 
AdicionaPPA(){
	apt-add-repository $2;
	apt-get update $apt_string_conf;
}
#Executa um script externo referenciado pelo $2 ou $3
#Se $2= --dir significa que o caminho do arquivo deverá ser referenciado em $3
SubRotina(){
	if [ -e $3  ] && [ "$2" = "--dir" ] && [ -x $3 ]; then #teste se existe o arquivo $3  E $2 igual "--dir" && $3 é executavel
		. /$3;
	fi
	if [ -e $2 ] && [ -x $2 ]; then # teste se existe $2 E $2 é executavel 
		./$2;
	fi
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
	echo "127.0.1.1 "$hostname".local"  $hostname| tee -a /etc/hosts
	echo "# The following lines are desirable for IPv6 capable hosts" | tee -a /etc/hosts
	echo "::1     ip6-localhost ip6-loopback" |tee -a /etc/hosts 
	echo "fe00::0 ip6-localnet" |tee -a /etc/hosts 
	echo "ff00::0 ip6-mcastprefix" |tee -a /etc/hosts 
	echo "ff02::1 ip6-allnodes" |tee -a /etc/hosts 
	echo "ff02::2 ip6-allrouters" |tee -a /etc/hosts 
}
#Cria arquivo de configuração dados.sh
EscrevaDados1(){
	echo "#!/bin/bash"
	echo 'flg="false";' | tee -a $(pwd)/dados.sh
	echo 'usuario="";'	| tee -a $(pwd)/dados.sh
	echo 'senha="";'     | tee -a $(pwd)/dados.sh
	echo 'servidor_proxy="'$server'";' | tee -a $(pwd)/dados.sh
	echo 'porta="'$port'";' | tee -a $(pwd)/dados.sh
	chmod a+x $(pwd)/dados.sh
}
#
EscrevaDados2(){
	echo "Entre com o login:"
	read usr
	echo "Digite a senha"
	read cod
	echo '#!/bin/bash' | tee $(pwd)/dados.sh
	echo 'flg="true";' | tee -a $(pwd)/dados.sh
	echo 'usuario="'$usr'";'| tee -a  $(pwd)/dados.sh
	echo 'senha="'$cod'";'|tee -a $(pwd)/dados.sh
	echo 'servidor_proxy="'$server'";' | tee -a $(pwd)/dados.sh
	echo 'porta="'$port'";' | tee -a $(pwd)/dados.sh
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
				server=$servidor 
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
    	if [ "$flg" = "true" ]
    		then
    			break;
    		else
    			if [ "$flg" = "false" ]
    				then
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
	if [ -e $(pwd)/dados.sh ]
		then 
			if [ -x $(pwd)/dados.sh ]
				then
					. /$(pwd)/dados.sh
			else
				sudo chmod +x $(pwd)/dados.sh;
				. /$(pwd)/dados.sh
			fi

		else 
			#Se chegou aqui é porque o arquivo não existe, vamos criar :)
			echo "Arquivo base de configuração ainda não foi criado:"
			CriarDados;
			. /$(pwd)/dados.sh
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
	if [ -e  $apt_lock_one ]
		then
			rm $apt_lock_one
	fi
	if [ -e  $apt_lock_two ]
		then 
			rm $apt_lock_two;
	fi
	apt-get -f install $apt_string_conf;
}
#Função chave do programa pst  
Habilita_proxy(){
	LeiaDados
	if [  "$flg" = "true" ]
		then
			export http_proxy="http://$usuario:$senha@$servidor_proxy:$porta"
			export socks_proxy="socks://$usuario:$senha@$servidor_proxy:$porta"
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
	apt-get  update  $apt_string_conf
	apt-get dist-upgrade $apt_string_conf
}
#Criada para ser usada nos laboratórios de computação. Instala componentes importantes para programar
Instala_componente(){
	#idesum="netbeans"
	#ideecl="eclipse eclipse-jdt eclipse-cdt"
	outros="kate konsole codeblocks build-essential checkinstall cdbs devscripts dh-make fakeroot libxml-parser-perl check avahi-daemon"
	seg_ano="nasm mysql-server-5.5 openjdk-7-jdk libmysqlcppconn-dev"
	ter_ano="wireshark traceroute phpmyadmin apache2 php5 flex bison"
	apt-get install gcc g++  $idesum $ideecl $outros $seg_ano $ter_ano $apt_string_conf
	apt-get clean
}
#Cria o arquivo de configuração file.txt e salva no diretorio local. O objetivo é criar o arquivo /etc/apt/apt.conf
Cria_APT_CONF(){
	if [ -e $apt_conf ]
		then
			echo "O arquivo já existe"
		else
		echo 'Acquire::http::Proxy "'$http_proxy'";'|tee  $apt_conf
		echo 'Acquire::ftp::Proxy "'$ftp_proxy'";'|tee -a $apt_conf
		echo 'Acquire::socks::Proxy "'$socks_proxy'";'| tee -a $apt_conf
		echo 'Acquire::https::Proxy "' $https_proxy'";'|tee -a $apt_conf
		echo 'Acquire::ssl::Proxy "' $http_proxy'";'| tee -a $apt_conf		
		fi	
}
#Remove o arquivo /etc/apt/apt.conf, função experimental
Remove_APT_CONF(){
	if [ -e $apt_conf ]
	then 
		rm $apt_conf
	fi
}	
Imprime(){
	echo 'http_proxy='$http_proxy
	echo 'ftp_proxy='$ftp_proxy
	echo 'https_proxy='$http_proxy
}
