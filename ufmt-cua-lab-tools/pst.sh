#!/bin/bash
# UNIVERSIDADE FEDERAL DE MATO GROSSO
# Autor: Daniel Oliveira Souza
# Versão:2.0.10-r27-05-2019
# Descrição: Script de configuração geral do sistema apt com proxy de linux baseado em debian
# * Integridade do script 

#--------------------------------------------------------------------------------------------------------
#					<< SESSÃO DE VARIAVEIS E FLAGS
#--------------------------------------------------------------------------------------------------------
#incializa  configuração padrão do script
#echo "loading pst.sh"
APT_LOCK_ONE="/var/lib/apt/lists/lock";
APT_LOCK_TWO="/var/lib/dpkg/lock";
progr_install=()
FLAG_UPDATE_NOTIFIER=0
FLAG_WIRESHARK=0
declare versao='2.0.10-r31-05-2020'
export DEBIAN_FRONTEND="gnome"
export FLAG_PPA_SUPPORT=1
if [ "$PST_SH" = "" ]
then
	PST_SH="pst.sh"
	if [ "$PST_HOME" != "" ]
	then
		if [ -e $PST_HOME ]
		then
			if [ -e $PST_HOME/global-proxy.sh ]
			then
				. $PST_HOME/global-proxy.sh
			fi
			if [ -e $PST_HOME/packages.sh ]; then
				. $PST_HOME/packages.sh
			fi

		fi
	fi
	

#---------------------------------------------------------------------------------------------------------
#					PACOTES APT
# 		Esses dados serão retirados do SCRIPT principal 
#--------------------------------------------------------------------------------------------------------
#graphics_tools=" "
	
#---------------------------------------------------------------------------------------------------------
#					DESCOBRE EM QUAL DISTRIBUIÇÃO LINUX O CODIGO ESTÁ SENDO EXECUTADO
	linux_version=$(cat /etc/issue.net);
	linux_release=$linux_version
	APT_CONF="/etc/apt/apt.conf";
	APT_CONF_ALT="/etc/apt/apt.conf.d/01proxy";
	echo "seu linux é: $linux_version"
#Descobre se o a distribuição do linux e aplica modificaçoes em versões de pacotes
#	if  [ "$(whoami)" = "root" ]; then 
	DetectDist(){
	case $linux_version in
		
		*"Debian"*)
			export FLAG_PPA_SUPPORT=0
			#echo "$FLAG_PPA_SUPPORT"
			#echo $http_proxy
			#echo $FLAG_PREINSTALL
			if [ $FLAG_PREINSTALL = 1 ]
			then 
				mysql_preconfig "debian" "stretch"
			fi
			case $linux_release in 
				*"${debian_v[0]}"*)
					progr_install=(
						${common_install[@]}
						${common_libs[@]}
						${pkg_install[0]}
						${pkg_libs[0]}
						${debian_linux_modifications[0]}
						$compilers_install
						$network_tools
						$prog_tools
						$graphics_tools
					)
				;;
				*"${debian_v[1]}"*)
					progr_install=(
						${common_install[@]}
						${common_libs[@]}
						${pkg_install[1]}
						${pkg_libs[1]}
						${debian_linux_modifications[1]}
						$compilers_install
						$network_tools
						$prog_tools
						$graphics_tools
					)
				;;
			esac
		;;
		*"Ubuntu"*)
			FLAG_UPDATE_NOTIFIER=1 
			
			case $linux_release in 
				*"${ubuntu_lts_v[0]}"*)
					if [ $FLAG_PREINSTALL = 1 ]
					then 
						mysql_preconfig "ubuntu" "bionic"
					fi
					progr_install=(
						${common_install[@]}
						${common_libs[@]}
						${pkg_install[0]}
						${pkg_libs[0]}
						${ubuntu_linux_modifications[0]}
						$compilers_install
						$network_tools
						$prog_tools
						$graphics_tools
					)
					;;
					*"${ubuntu_lts_v[1]}"*)
						if [ $FLAG_PREINSTALL = 1 ]
						then 
							mysql_preconfig "ubuntu" "xenial"
						fi
						progr_install=(
						${common_install[@]}
						${common_libs[@]}
						${pkg_install[1]}
						${pkg_libs[1]}
						${ubuntu_linux_modifications[1]}
						$compilers_install
						$network_tools
						$prog_tools
						$graphics_tools
					)
					;;
			esac
		;;
		*"Linux Mint"*)
			APT_CONF=$APT_CONF_ALT

			case $linux_release in 

				*"${mint_v[0]}"*)
					if [ $FLAG_PREINSTALL = 1 ]
					then 
						mysql_preconfig "ubuntu" "bionic"
					fi
					progr_install=(
						${common_install[@]}
						${common_libs[@]}
						${pkg_install[0]}
						${pkg_libs[0]}
						${mint_linux_modifications[0]}
						$compilers_install
						$network_tools
						$prog_tools
						$graphics_tools
					)
				;;
				*"${mint_v[1]}"*)
					if [ $FLAG_PREINSTALL = 1 ]
					then 
						mysql_preconfig "ubuntu" "xenial"
					fi
					progr_install=(
						${common_install[@]}
						${common_libs[@]}
						${pkg_install[1]}
						${pkg_libs[1]}
						${mint_linux_modifications[1]}
						$compilers_install
						$network_tools
						$prog_tools
						$graphics_tools
					)
				;;
					
			esac
		;;
		*)
			echo "distribuição linux não suportada" > /dev/stderr
			GLOBAL_RESULT=253;
			return 1
		;;
	esac
}

#------------------------------------------------------------------------------------------------------------

#Verifica se o proxy está habilitado 



#---------------------------------------------------------------------------------------------------------
#					 FIM DA SESSÃO VARIAVEIS E FLAGS  >>
#---------------------------------------------------------------------------------------------------------

#Determina o arquivo  de configuração do sistema apt de acordo com a versão do linux
#Determina se é necessário adicionar o evento "http_proxy"

#Configura o wireshark
	MakeWiresharkConf(){
		if [ $FLAG_WIRESHARK = 1 ] ; then 
			usuarios=($(cat /etc/group | grep 100 | cut -d: -f1))
		#adiciona cada usuário ao grupo wireshark 
					for((i=1;i<${#usuarios[@]};i++))
					do
			#adiciona o usuário ao grupo wireshark 
						adduser ${usuarios[i]} wireshark
					done
		fi
	}		
#Rotina para adicionar PPA 
	AdicionaPPA(){
		#echo "PPA=$1"
		if [ $FLAG_PPA_SUPPORT = 1 ]
		then
			apt-add-repository $1 -y ;
			if [ $? != 0 ]; then
				echo "falha ao adicionar o PPA!" > /dev/stderr
				return 251;
			fi
			apt-get update $APT_STRING_CONF;
		else
			echo "PPA não é suportada por esta distribuição linux!" > /dev/stderr
			GLOBAL_RESULT=252
			return 252
		fi
	}
#Função para alterar hostname}


#--------------------------------------------------------------------------------------------------
#				<<  FUNCOES QUE MANIPULAM ARQUIVOS 
#---------------------------------------------------------------------------------------------------


#Resolve conflitos de configuração da versão pst.sh versão 1.7
	ReconfiguraAPT_CONF(){
		if [ -e $APT_CONF_ALT ] && [ "$APT_CONF" = "/etc/apt/apt.conf" ]; then
				cp $APT_CONF_ALT $APT_CONF
				rm $APT_CONF_ALT;
		fi
	}
	AtualizaHost(){
		#echo "hostname=" $(cat /etc/hostname)
		#echo "host="$2
		echo $1 >  /etc/hostname;
		ReparaHost;
		resolv_command=$(which resolvconf)
		if  [ "$resolv_command" != "" ] ; then
			resolvconf -u 
		fi
		service network-manager restart;
	}
#Repara o hostname
	ReparaHost(){

		hostname_f=$(cat /etc/hostname)

		printf "%s\t%s\n" "127.0.0.1" "localhost" | tee /etc/hosts
		printf "%s\t%s\n" "127.0.1.1" "$hostname_f" | tee -a /etc/hosts 
		printf "%s\t%s\n" "# The following lines are desirable for IPv6 capable hosts" |tee -a /etc/hosts 
		printf "%s\t%s\n" "::1" "ip6-localhost ip6-loopback" | tee -a /etc/hosts 
		printf "%s\t%s\n" "fe00::0" "ip6-localnet" | tee -a /etc/hosts 
		printf "%s\t%s\n" "ff00::0" "ip6-mcastprefix" | tee -a /etc/hosts 
		printf "%s\t%s\n" "ff02::1" "ip6-allnodes" | tee -a /etc/hosts 
		printf "%s\t%s\n" "ff02::2" "ip6-allrouters" | tee -a /etc/hosts 

	}
#Cria arquivo de configuração dados.sh

	Ajuda(){
		if [ $PST_HOME/ajuda.txt ]
		then
			cat $PST_HOME/ajuda.txt
		fi
	}
#Adiciona o evento http_proxy ao /etc/sudoers



#--------------------------------------------------------------------------------------------------------
#				FINAL DA SESSÃO I/O ARQUIVOS >>
#--------------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------------
#			<<	FUNÇÕES  DE INSTALACAO DE COMPONENTES
#				apt-get e dpkg 
#--------------------------------------------------------------------------------------------------------
#Verifica  e repara possiveis erros no sitema APT e DPKG
	Repara_sistema_apt(){
		dpkg --configure -a
		if [ -e  $APT_LOCK_ONE ];then
			rm $APT_LOCK_ONE
		fi
		
		if [ -e  $APT_LOCK_TWO ];then 
			rm $APT_LOCK_TWO;
		fi
		apt-get -f install $APT_STRING_CONF -y --allow-unauthenticated ;
	}
#Atualiza o sistema  :) porém com a vantagem de fazer requisões wget se uma atualização necessitar
	Atualiza_sistema(){
#echo "update cache ..."
		apt-get  update  $APT_STRING_CONF
#echo  "try update -"
		apt-get dist-upgrade $APT_STRING_CONF  -y --allow-unauthenticated 
		if [ "$?"  != "0" ]; then
			apt-get dist-upgrade $APT_STRING_CONF  -y --allow-unauthenticated  --fix-missing
		fi
		
	}
	#função que instala a biblioteca libglad
	InstalaLibGlad(){
		libglad_path="$PST_HOME/libglad-installer/libglad-dev.deb"
		if [  -e $libglad_path ]; then
			dpkg -i $libglad_path
		fi
	}
#Criada para ser usada nos laboratórios de computação. Instala componentes importantes para programar
	Instala_componente(){
		apt-get install  -y --allow-unauthenticated  ${progr_install[@]} $APT_STRING_CONF
		if [  "$?" = "0" ]
		then
# identifica os usuários  cadastrados no linux  e o armazena em um vetor 
			apt-get clean
		else
			apt-get install   ${progr_install[@]} $APT_STRING_CONF  -y --allow-unauthenticated  --fix-missing
		fi
		MakeWiresharkConf
	}



#---------------------------------------------------------------------------------------------------------
#				FIM DE SESSÃO INSTALACAO DE COMPONENTES
#---------------------------------------------------------------------------------------------------------		#
	#fi
fi
