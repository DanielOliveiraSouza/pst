#!/usr/bin/env bash
#Universidade federal de Mato Grosso
#Curso ciencia da computação
#Versao PST: 2.0.10-r27-05-2019
#Descrição: Contem a função main do script pst.sh
#Contem a função principal do pst.sh
#Esta fun



source ~/.profile
#source /etc/profile
#echo $PATH
#sleep 10
#echo $*
#cria o log inicial do script, qualquer erro, este arquivo será sobrescrito, pelo último erro
PST_GUI_OUT_ERROR=/tmp/pst.log

WritePST_Error ( ){
	if [ -e $PST_GUI_OUT_ERROR ] ; then 
		echo "$1" > $PST_GUI_OUT_ERROR
	fi
}
FLAG_PREINSTALL=0
GLOBAL_RESULT=0
if [ "$(whoami)" = "root" ]; then
	local_profile=/etc/profile
	local_bashrc="/etc/bash.bashrc"
else
	local_profile=~/.profile           
	local_bashrc=~/.bashrc
fi
#echo "$local_bashrc"
#echo "$local_profile"
#este codigo checa a  última linha do arquivo e insere uma em branco 
InsertUniqueBlankLine(){
	if [ "$1" != "" ] ; then
		if [ -e $1 ] ; then 
			aux=$(tail -1 $1 )       #tail -1 mostra a última linha do arquivo 
			if [ "$aux" != "" ] ; then   # verifica se a última linha é vazia
				sed  -i '$a\' $1 #adiciona uma linha ao fim do arquivo
			fi
		fi
	fi
}
setPSTHome(){
	#echo "from set PST_HOME PST_HOME=$PST_HOME PROFILE=$local_profile"
	profile_str=$(cat $local_bashrc)
	flag_check_pst=0
	case "$profile_str" in
		*"PST_HOME="*)
			flag_check_pst=1
		;;
	esac
	InsertUniqueBlankLine $local_bashrc
	InsertUniqueBlankLine $local_profile

	if [ $flag_check_pst = 1 ] ; then
		sed -i "/export PST_HOME=*/d" $local_profile  #expressão regular para PST_HOME={qualque caractere != \n}*
		sed -i "/export PST_HOME=*/d" $local_bashrc
		sed -i '/export PATH=$PATH:$PST_HOME/d' $local_bashrc
	fi
	if [ "$PST_HOME" != "" ]; then 
		InsertUniqueBlankLine $local_bashrc
		InsertUniqueBlankLine $local_profile
		echo "export PST_HOME=$PST_HOME" >> $local_profile
		echo "export PST_HOME=$PST_HOME" >> $local_bashrc
		echo 'export PATH=$PATH:$PST_HOME' >> $local_bashrc
	fi
	
}
#PST_HOME=$(python ~/scripts/pst/ver-2.0-rc10/setup.py)
setAliases(){
	flag_check_pst_alias=0
	bashrc_str=$(cat $local_bashrc)
	case "$bashrc_str" in 
		*"alias ativa_proxy="*)
		flag_check_pst_alias=1
	;;
	esac
	if [ $flag_check_pst_alias = 1 ] ; then 
		sed -i "/alias ativa_proxy=*/d" $local_bashrc #remove todas as linhas que começam ativa_proxy=*, lembrando que * um coringa 
		sed -i "/alias desativa_proxy=*/d" $local_bashrc #remove todas as linhas que começam desativa_proxy=* , lembrando que *  um coringa
	fi
	echo "alias ativa_proxy=\"$PST_HOME/main-pst.sh --ativa_proxy\"" >> $local_bashrc
    echo "alias desativa_proxy=\"$PST_HOME/main-pst.sh --desat_proxy\"" >> $local_bashrc
}
DetectPath(){
	if [ "$PST_HOME" = "" ]
	then
		echo "$PST_HOME"
		AUX_PATH=$0 #$0 contém o caminho do script que está executando
		VAZIO=""
		#echo "$0"
		#AUX_PATH=${AUX_PATH//main-pst.sh/$VAZIO}  expansão remove /main-pst.sh 
		AUX_PATH=${AUX_PATH%/main-pst.sh*} #remove o final  apartir /main-pst.sh se /main-pst.sh estiver no final da string ref:http://aurelio.net/shell/canivete/#expansao
		#echo "AUX_PATH=$AUX_PATH"
		if [ -e $AUX_PATH ]
		then
			
			cont_modules=0
			#um vetor com os nomes dos PST_MODULES 
			PST_MODULES=(
				"configure_dns.sh"  
				"packages.sh"
				"setup.sh" 
				"global-proxy.sh"
				"main-pst.sh"
				"pst.sh"    
			)
			#expansão ${!}
			for i  in ${!PST_MODULES[*]} 
			do
				if [ -e $AUX_PATH/${PST_MODULES[i]} ]
				then
					((cont_modules++))
				fi
			done
			if [ $cont_modules = ${#PST_MODULES[*]} ]
			then
				#echo "all  modules exists in $AUX_PATH"
				export PST_HOME=$AUX_PATH
			fi
		fi 
	fi
}
#echo $PST_HOME
#sleep 5
#echo 'from main-pst.sh tryed read .bashrc, return:'$?
if [  "$PST_HOME" = "" ];then
	echo "Aviso: variável PST_HOME não está definida:"
	echo "Certifique que em  $PWD contenha os módulos do PST ..."
	DetectPath
#sleep 7

		if [ -e $(pwd)/pst.sh ] && [ -x $(pwd)/pst.sh ];then
			export PST_HOME=$PWD
			. /$(pwd)/pst.sh; #/é junto de $(pwd)
		fi
else
	if [ -e $PST_HOME/pst.sh ] && [ -x $PST_HOME/pst.sh ];then
#		echo "from main: import pst library ..."
		. $PST_HOME/pst.sh; #/é junto de $(pwd)
#sleep 6
	fi
	
fi



if [ "$PST_HOME" = "" ]
then
	echo "Aviso: variável PST_HOME não está definida:"
	echo "Certifique que em  $PWD contenha os módulos do PST ..."
	if [ -e $(pwd)/pst.sh ] && [ -x $(pwd)/pst.sh ];then
		. $(pwd)/pst.sh; #/é junto de $(pwd)
	fi
else
	if [ -e $PST_HOME/pst.sh ] && [ -x $PST_HOME/pst.sh ];then
#echo "import pst library ..."
		. $PST_HOME/pst.sh; #/é junto de $(pwd)
	fi
	
fi

main(){
	permissao=$(whoami);
	if [ "$permissao" = "root" ];then
		ReconfiguraAPT_CONF;

	#echo "$1=" $1	
# Regiao de codigo com poderes de root 
		case "$1" in
#sessão que não precisa do script de dados
				"--conf_sudoers") 
					Habilita_update_notifier;
				;;
				"--reconf-sudoers")		
					Restaura_etc_sudoers;
				;;
# "--reconf-host")	
# 	ReparaHost $1 $2;
# ;;
				"--v")
					printf "PostInstall $versao\nDesenvolvido por: Daniel Oliveira Souza\nemail:oliveira.daniel109@gmail.com\n"
				;;
				"--at_hostname")	
					AtualizaHost $2 
				;;

				"--aj")
					Ajuda;
				;;


#sessão que precisa ler dados

				"--at")	Repara_sistema_apt;		
						Atualiza_sistema;
				;;
				"--t")
		
					FLAG_PREINSTALL=1
					DetectDist
					echo "O  script iniciará  a configuração em 10s e instalará arquivos para usar o proxy no APT"
					echo "Pressione CTRL+ C para parar o script ..."
					sleep 10
					Repara_sistema_apt;		
					Atualiza_sistema; 		
					Instala_componente; 
#	Cria_APT_CONF $1 $2;
					

				;;
				"--i-e")
					FLAG_WIRESHARK=1
					FLAG_PREINSTALL=1
					DetectDist
					#. $PST_HOME/pst.sh
					# echo "from main: $FLAG_PREINSTALL"
					Repara_sistema_apt;		
					Instala_componente; 
				;;

				"--i-cg")
					FLAG_PREINSTALL=1
					DetectDist
					#echo "graphics_tools=$graphics_tools"
					apt-get install $graphics_tools $APT_STRING_CONF -y --allow-unauthenticated
					InstalaLibGlad
				;;
				"--i-redes")
					FLAG_PREINSTALL=1
					DetectDist
					apt-get install $network_tools $APT_STRING_CONF -y --allow-unauthenticated 
					MakeWiresharkConf
				;;
				"--i-d")
					FLAG_PREINSTALL=1
					DetectDist
					Repara_sistema_apt;
# String que armazena os parametros passados por argumentos
					pack=($*); 
#echo "argv= $*"
#laco que percorre todo o vetor 
					for((i = 1; i < ${#pack[@]}; i++ ))
					do
						echo "instalando: ${pack[i]}"
						apt-get install -y  --allow-unauthenticated  ${pack[i]} $APT_STRING_CONF
					done
			
				;;
# "--cr_apt")		
# 	Cria_APT_CONF $1 $2;
# ;;
# "--rm_apt")
# 	Remove_APT_CONF;
# 	Restaura_etc_sudoers;
# ;;

				
			
				"--add_ppa")
					DetectDist;	
					Repara_sistema_apt; 
					echo "PPA:$2"	
					AdicionaPPA "$2";
				#	echo "ret=$?"
					#return $?
				#exit $?
				#echo "$?" > /home/danny/out-main-pst.log


				;;

				
# configura os arquivos do proxy  e cria o script de dados
				"--set_proxy" )
					
					if [ $#  = 5 ]
					 then
						if [  "$4" = "--use_login" ] ; then #verificase o proxy é autenticado 
	#echo "configurando o proxy";
							setProxy $2 $3 $5
	#echo "setProxy RETORONOU "$?;
						fi
					else 
						if [ $# = 7 ]  ; then
							if [ "$4" = "--use_login" ] &&  [ $5 = 1 ] ; then
								setProxy $2 $3 $5 $7 $8;
							fi
						fi
						echo "set_proxy:Faltam argumentos!" > /dev/stderr
					fi

				;;

# inicializa o flag use_proxy para true ou false 
				"--ativa_proxy")
					setGlobalProxy 1  
				
				;;
				"--desat_proxy")	
					setGlobalProxy 0 
					
				;;
				"--config")
					#ConfigurePST_PATH $1
					if [ -e $(pwd)/pst.sh ] && [ -x $(pwd)/pst.sh ];then
						export PST_HOME=$PWD
						. /$(pwd)/pst.sh; #/é junto de $(pwd)
					fi
					setPSTHome
					setAliases
					#echo "Recurso indisponível"
					#rue;
				;;
				*)
				  echo "Parametro invalido";  > /dev/stderr
				  Ajuda; 
				;;
				
		esac

		Restaura_etc_sudoers;
		if [ -e $PST_HOME/configure_dns.sh ] && [ -x $PST_HOME/configure_dns.sh ]; then
		. /$PST_HOME/configure_dns.sh
		fi
	else
#echo "em" $0, 'total de argumentos  =' $# "todos os argumentos" $*
		case "$1" in 
# configura os arquivos do proxy  e cria o script de dados

				"--set_proxy" )
					
					if [ $#  = 5 ] ; then
						if [  "$4" = "--use_login" ] ; then #verificase o proxy é autenticado 
#		echo "configurando o proxy";
							setProxy $2 $3 $5
#		echo "setProxy RETORONOU "$?;
						fi
					else 
						if [ $# = 7 ]  ; then
							if [ "$4" = "--use_login" ] &&  [ $5 = 1 ] ; then
								setProxy $2 $3 $5 $7 $8;
							fi
						fi
						echo "set_proxy:Faltam argumentos!" > /dev/stderr
					fi

				;;

				"--ativa_proxy")
#echo "from main try ative proxy"
					setHabilitaProxy 1
				
				;;
				"--desat_proxy")
#	echo "from main try desat_proxy ..."	
					setHabilitaProxy 0
					
				;;
				"--aj")
					Ajuda;
				;;

				* )
				# >&2 ó arquivo stderr ()
 				echo "Aviso: Parametro inválido"  > /dev/stderr
				#sleep 2
				return 125
					
		esac

	fi
 	return 0;
}
main $*
