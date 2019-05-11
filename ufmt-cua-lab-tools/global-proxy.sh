#!/bin/bash
#	UNIVERSIDADE FEDERAL DE MATO GROSSO
#	CURSO: CIENCIA DA COMPUTAÇÃO
#	VERSÃO: 2.0-rc10-testing
linux_version=$(cat /etc/issue.net);
linux_release=$linux_version
APT_CONF="/etc/apt/apt.conf";
APT_CONF_ALT="/etc/apt/apt.conf.d/01proxy"; 
export bashrc_path=~/.bashrc

case "$linux_version" in 
	*"Linux Mint"*)
		APT_CONF=$APT_CONF_ALT
	;;
esac
if [ "$GLOBAL_PROXY_H_"  = "" ];
then
#	echo "from global-proxy: reading global-proxy"
	ResetInitPST(){	
			echo "FLAG_HABILITA_PROXY=0" > ~/.INIT_PST.sh
			echo "FLAG_AUTENTICACAO_PROXY=0" >> ~/.INIT_PST.sh
			echo "FLAG_UPDATE_NOTIFIER=0" >> ~/.INIT_PST.sh
			echo "HOST=\"internet.cua.ufmt.br\"" >> ~/.INIT_PST.sh
			echo "PORTA=3128" >> ~/.INIT_PST.sh
			echo "USUARIO_PROXY=\"\"" >> ~/.INIT_PST.sh
			echo "SENHA_PROXY=\"\"" >> ~/.INIT_PST.sh
			echo "PST_REPOSITORY=\"\"" >> ~/.INIT_PST.sh
			chmod +x ~/.INIT_PST.sh

	}

	if [ "$PST_HOME" = "" ]; then
		echo "PST_HOME is null"
		if [ -e ~/.INIT_PST.sh ] && [ -x ~/.INIT_PST.sh ] ; then
			. ~/.INIT_PST.sh
		fi
	else
		if [ -e ~/.INIT_PST.sh ] && [ -x ~/.INIT_PST.sh ] ; then
		. ~/.INIT_PST.sh
		else
			ResetInitPST;
			. /$HOME/.INIT_PST.sh
		fi
	fi


	SetVariaveisProxy(){
		if [  $FLAG_AUTENTICACAO_PROXY = 1 ]
				then
					export http_proxy="http://$USUARIO_PROXY:$SENHA_PROXY@$HOST:$PORTA"
					export wr_http_proxy="http:\/\/$USUARIO_PROXY:$SENHA_PROXY@$HOST:$PORTA"
					export socks_proxy="socks://$HOST:$PORTA/"
					export wr_socks_proxy="socks:\/\/$HOST:$PORTA"
					export https_proxy="https://$USUARIO_PROXY:$SENHA_PROXY@$HOST:$PORTA"
					export wr_https_proxy="https:\/\/$USUARIO_PROXY:$SENHA_PROXY@$HOST:$PORTA"
					export ftp_proxy="ftp://$USUARIO_PROXY:$SENHA_PROXY@$HOST:$PORTA"
					export wr_ftp_proxy="ftp:\/\/$USUARIO_PROXY:$SENHA_PROXY@$HOST:$PORTA"

				else
				
#				echo "create strig of proxy variavble" whoami
					export http_proxy="http://$HOST:$PORTA"
					export wr_http_proxy="http:\/\/$HOST:$PORTA"
					export socks_proxy="socks://$HOST:$PORTA"
					export wr_socks_proxy="socks:\/\/$HOST:$PORTA"
					export https_proxy="https://$HOST:$PORTA"
					export wr_https_proxy="https:\/\/$HOST:$PORTA"
					export ftp_proxy="ftp://$HOST:$PORTA"
					export wr_ftp_proxy="ftp:\/\/$HOST:$PORTA"
			fi
	}

	
		if [ $FLAG_HABILITA_PROXY = 1 ]
		then
#		habilita as variaveis do proxy para o APT 
#		verifica se o proxy é  autenticado 
			SetVariaveisProxy;

			APT_STRING_CONF="-o Acquire::http::Proxy="
			APT_STRING_CONF="$APT_STRING_CONF$http_proxy";
			APT_KEY_STRING_CONF="--keyserver-options http-proxy=$http_proxy"
#		echo "usando proxy" $http_proxy
#		Habilita o update notifier para o Ubuntu 
			if [ FLAG_UPDATE_NOTIFIER  = 1 ];then
					Habilita_update_notifier;
			fi

		else
			APT_STRING_CONF=""

			APT_KEY_STRING_CONF=""    
#Referencia: https://unix.stackexchange.com/questions/361213/unable-to-add-gpg-key-with-apt-key-behind-a-proxy			

		fi

	Habilita_update_notifier(){
	if [ -e /etc/sudoers.backup ]
		then
			true;
		else
			cp /etc/sudoers /etc/sudoers.backup
	 			echo "#Instrução oficial para habilitar proxy no update-notifier" >> /etc/sudoers
			echo "#Referencia: http://askubuntu.com/questions/140558/12-04-lts-flashplugin-installer-problem" |tee -a /etc/sudoers
			echo "Defaults env_keep=\"http_proxy\"" >> /etc/sudoers
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






# argumentos $1=HOST $2=PORTA $3=FLAG_AUTENTICAO $4=USUARIO_PROXY $5SENHA_PROXY
	setProxy(){
#echo "argumentos= " $* "total" $#
		case $# in
			3)
				permissao=$(whoami)
				if [ "$permissao" = "root" ]; then
					setGlobalProxy 0;
				else
					setHabilitaProxy 
				fi
				sed -i "s/HOST=\"$HOST\"/HOST=\"$1\"/g" ~/.INIT_PST.sh
				sed -i "s/PORTA=$PORTA/PORTA=$2/g" ~/.INIT_PST.sh
				sed -i "s/FLAG_AUTENTICACAO_PROXY=$FLAG_AUTENTICACAO_PROXY/FLAG_AUTENTICACAO_PROXY=$3/g" ~/.INIT_PST.sh
				sed -i "s/USUARIO_PROXY=\"$USUARIO_PROXY\"/USUARIO_PROXY=\"\"/g" ~/.INIT_PST.sh
				sed -i "s/SENHA_PROXY=\"$SENHA_PROXY\"/SENHA_PROXY=\"\"/g" ~/.INIT_PST.sh
				return 0
			;;
			5) 
				permissao=$(whoami)
				if [ "$permissao" = "root" ]; then
					setGlobalProxy 0;
				else
					setHabilitaProxy 0;
				fi
				sed -i "s/HOST=\"$HOST\"/HOST=\"$1\"/g" ~/.INIT_PST.sh
				sed -i "s/PORTA=\"$PORTA\"/PORTA=\"$2\"/g" ~/.INIT_PST.sh
				sed -i "s/FLAG_AUTENTICACAO_PROXY=$FLAG_AUTENTICACAO_PROXY/FLAG_AUTENTICACAO_PROXY=$3/g" ~/.INIT_PST.sh
				sed -i "s/USUARIO_PROXY=\"$USUARIO_PROXY\"/USUARIO_PROXY=\"$4\"/g" ~/.INIT_PST.sh
				sed -i "s/SENHA_PROXY=\"$SENHA_PROXY\"/SENHA_PROXY=\"$5\"/g" ~/.INIT_PST.sh
				return 0
			;;
			*) 
				if [ $# -lt 3 ]; then
					echo "deve ser informado HOST PORTA FLAG_AUTENTICAO_PROXY " > /dev/stderr
				else
					echo "deve ser informado HOST PORTA FLAG_AUTENTICAO_PROXY USUARIO_PROXY SENHA_PROXY" > /dev/stderr
				fi
				return 255

			;;
		esac
	}
	SetProxyApps (){
		SVN_EXE=$(which svn)
		GIT_EXE=$(which git)
		if [ $1  = 1 ] ; then

			if  [ "$SVN_EXE" != "" ] ; then  #se existe o executável svn 
				

				svn_cmd=$(svn --help)
				if [ -e ~/.subversion/servers ] ; then
					aux=$(tail -1 ~/.subversion/servers)       #tail -1 mostra a última linha do arquivo 
					if [ "$aux" != "" ] ; then   # verifica se a última linha é vazia
						sed  -i '$a\' ~/.subversion/servers #adiciona uma linha ao fim do arquivo
					fi
					echo "Ativando proxy para SVN"
					echo "http-proxy-host=$HOST" >> ~/.subversion/servers
					echo "http-proxy-port=$PORTA" >> ~/.subversion/servers

					if [ $FLAG_AUTENTICACAO_PROXY =  1 ] ; then
						echo "http-proxy-username=$USUARIO_PROXY" >> ~/.subversion/servers
						echo "http-proxy-password=$SENHA_PROXY" >> ~/.subversion/servers
					fi
				fi 

			fi
#http-proxy-port=80
			if [ "$GIT_EXE" != "" ]; then   # se existe o executável git 
				# if [ -e ~/.gitconfig ] ;then
				# 	rm ~/.gitconfig
				# fi
				echo "Ativando proxy para GIT"
				git config --global core.gitproxy $http_proxy #"http://$HOST:$PORTA"
				git config --global http.gitproxy $http_proxy #"http://$HOST:$PORTA"
			fi
		else
			if [ "$SVN_EXE" != "" ] ; then
				if [ -e  ~/.subversion/servers ]; then
					echo "Desativando Proxy para SVN"
					sed -i "/http-proxy-host=$HOST/d" ~/.subversion/servers
					sed -i "/http-proxy-port=$PORTA/d" ~/.subversion/servers

					if [ $FLAG_AUTENTICACAO_PROXY = 1 ]; then
						sed -i "/http-proxy-username=$USUARIO_PROXY/d" >> ~/.subversion/servers
						sed -i "/http-proxy-password=$SENHA_PROXY/d" >> ~/.subversion/servers
					fi 
	
				fi
			fi

			if [ "$GIT_EXE" != "" ] ; then 
				echo "Desativando proxy para GIT"
				git config --global --unset core.gitproxy
				git config --global --unset http.gitproxy
				if [ -e ~/.gitconfig ] ;then
					#cat ~/.gitconfig
				 	sed -i '/\[core\]/d' ~/.gitconfig
				 	#cat ~/.gitconfig
				 	sed -i '/\[http\]/d' ~/.gitconfig
				fi

			fi

		fi
	}

# Argumentos: $1 FLAG_HABILITA_PROXY ,devendo ser 0 ou 1
# Esta função habilita proxy no terminal e no sistema, inclusive em seu navegador 
	setHabilitaProxy(){
#echo "XDG_CURRENT_DESKTOP=" $XDG_CURRENT_DESKTOP "arg1 = " $1 'bashrc_path=' $bashrc_path
		case $1 in
			0)
				SetVariaveisProxy
##echo $wr_http_proxy
#echo $http_proxy
#echo $bashrc_path
				echo "Proxy desativado para este usuário: $USER"
				gsettings set org.gnome.system.proxy mode 'none'
		
#sed -i (iterativo) /d signfica exclua esta linah do arquivo , os camandos a seguir deletam linha alterada pelo script
#[#]*export http_proxy=* é uma expressão regular (regex) que remove qualquer linha ou comentário com export http_proxy
				sed -i "/[#]*export http_proxy=*/d" $bashrc_path
				sed -i "/[#]*export https_proxy=*/d" $bashrc_path
				sed -i "/[#]*export ftp_proxy=*/d" $bashrc_path
				sed -i "/[#]*export socks_proxy=*/d" $bashrc_path
				sed -i "s/FLAG_HABILITA_PROXY=1/FLAG_HABILITA_PROXY=0/g" ~/.INIT_PST.sh
				SetProxyApps 0	

			;;
			1)
#echo "try active gloabla proxy "
#echo  "from  iniciosetHabilitaProxy1$bashrc_path"
#if [ "$XDG_CURRENT_DESKTOP" = "gnome" ] | [ "$XDG_CURRENT_DESKTOP" = "XFCE" ]  | [ "$XDG_CURRENT_DESKTOP" =  "X-Cinnamon" ] ; then
					sed -i "s/FLAG_HABILITA_PROXY=0/FLAG_HABILITA_PROXY=1/g" ~/.INIT_PST.sh
#source $PST_HOME/global-proxy.sh

					echo 'Ativando proxy  para :' $USER
#	echo "arg1 =" $1
					SetVariaveisProxy
#echo "APT_STRING_CONF="$APT_STRING_CONF
					gsettings set org.gnome.system.proxy mode 'manual'
					gsettings set org.gnome.system.proxy.http host $HOST
					gsettings set org.gnome.system.proxy.http enabled true
					gsettings set org.gnome.system.proxy.http port $PORTA
					gsettings set org.gnome.system.proxy.https host $HOST
					gsettings set org.gnome.system.proxy.https port $PORTA
					gsettings set org.gnome.system.proxy.ftp  host $HOST
					gsettings set org.gnome.system.proxy.ftp  port $PORTA
					gsettings set org.gnome.system.proxy.socks   host $HOST
					gsettings set org.gnome.system.proxy.socks   port $PORTA
					cp $HOME/.bashrc $HOME/.old.bashrc
					aux=$(tail -1 $bashrc_path)       #tail -1 mostra a última linha do arquivo 
					if [ "$aux" != "" ] ; then   # verifica se a última linha é vazia
						sed  -i '$a\' $bashrc_path #adiciona uma linha ao fim do arquivo
					fi
#echo -e "sou uma linha\nsou outra linha\nesta linha tem número 1\nesta já não tem número" | sed -r '/[0-9]+/ a Oi. Sou novo aqui'
#echo "from root setHabilitaProxy  $bashrc_path"
					aux=$(cat $bashrc_path)
					flag_bashrc=0

					case "$aux" in  
						*"export http_proxy="*)  echo "~/.bashrc já está configurado!"; flag_bashrc=1 ;; #verifica se a substring de configuração de proxy no terminal foi definida
					esac
					if [ $flag_bashrc = 0 ];then
#echo "flag_bashrc="$flag_bashrc
#echo $bashrc_path 
						echo "export http_proxy=\"$http_proxy\"" >> $bashrc_path
#echo "return first write bashrc_path =" $?
						echo "export https_proxy=\"$https_proxy\"" >> $bashrc_path
						echo "export ftp_proxy=\"$ftp_proxy\""  >>  $bashrc_path
						echo "export socks_proxy=\"$socks_proxy\"" >> $bashrc_path
					fi


					SetProxyApps 1;
			;;

			
			2)
				echo "Ativando proxy em modo automático para o  usuário: $USER"
				gsettings set org.gnome.system.proxy mode 'auto'
			;;
			
		esac
	}






	Cria_APT_CONF(){
		echo "Acquire::http::Proxy \"$http_proxy\"/;" >  $APT_CONF
		echo "Acquire::ftp::Proxy \"$ftp_proxy\"/;" >> $APT_CONF
#echo 'Acquire::socks::Proxy "'$socks_proxy'";'| tee -a $APT_CONF
#echo 'Acquire::ssl::Proxy "' $http_proxy'";'| tee -a $APT_CONF
	}
	Remove_APT_CONF(){
		#echo "cheguei aqui"
		if [ -e $APT_CONF ]
		then 
			rm $APT_CONF
		fi
	}
	setGlobalProxy(){
		permissao=$(whoami)
		if [ "$permissao"  = "root" ]; then
			
			case $1 in 
				0)
					setHabilitaProxy 0
					export bashrc_path="/etc/bash.bashrc"; #fix bug to bashrcfile to debian 
					setHabilitaProxy 0 > /dev/null
					Remove_APT_CONF;
					  # no apt 
					if [ $FLAG_UPDATE_NOTIFIER = 1 ]; then  #evento keep_http_proxy no ubuntu 
						Habilita_update_notifier;
					fi
				;;
				1)
					setHabilitaProxy 1;
					export bashrc_path="/etc/bash.bashrc"; #fixbub bashrcfile to debian 
					setHabilitaProxy 1 > /dev/null ; 
					Cria_APT_CONF;
					if [ $FLAG_UPDATE_NOTIFIER = 1 ]; then 
						Restaura_etc_sudoers;
					fi
				;;
			esac
		fi
	}

#----------------- Região main() de global-proxy.sh ------------------------------------------------------------

# região equivalente em python __name__ = __main__
#echo $https_proxy
#echo $http_proxy
#$echo  $socks_proxy
#echo $ftp_proxy
#echo "running global-proxy.sh zero is: $0"
	if [  "$0" = "global-proxy.sh" ]  ; then
		echo  "DESKTOP: $XDG_CURRENT_DESKTOP"
#echo "__main__ =" $0
#echo 'quantidade de argumentos =' $#  'eles são' $* 
#echo "arg[1]=$1"
#HOST=$2
#PORTA=$3
#FLAG_AUTENTICACAO_PROXY=$3
#USUARIO_PROXY=$4
#SENHA_PROXY=$5
		setHabilitaProxy $1
#setProxy $1 $2 $3
	elif [  "$0" = "$PST_HOME/global-proxy.sh" ]; then  
		setHabilitaProxy $1
	fi

#echo "	from global-proxy: end read"
	GLOBAL_PROXY_H_="global-proxy.sh"
fi
