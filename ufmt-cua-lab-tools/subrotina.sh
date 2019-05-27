#!/bin/bash
#Universidade federal de Mato Grosso
#Curso ciencia da computação
#Versão PST:2.0.10-r27-05-2019
#Descrição:
export extras_loaded=0
mtp_autorun="/media/mtp_autorun"
user_autorun=""
CreatePST_Extras(){
	echo "SERVER0=$1" > ~/.init_pst_extras.sh
	echo "USER_SERVER0=$2" >> ~/.init_pst_extras.sh
	#echo "AUTENTICATION=1" >> ~/.init_pst_extras.sh
	echo "PASSWORD_SERVER0=$3" >> ~/.init_pst_extras.sh
	chmod +x ~/.init_pst_extras.sh

}
UPdatePST_Extras(){
	if [ -e ~/.init_pst_extras.sh ] ; then
		sed -i "s/SERVER0=$SERVER0/$1/g" ~/.init_pst_extras.init_pst_extras.sh
		sed -i "s/USER_SERVER0=$USER_SERVER0/$2/g" ~/.init_pst_extras.sh
		sed -i "s/PASSWORD_SERVER0=$PASSWORD_SERVER0/$3/g" ~/.init_pst_extras.sh
	fi
}

RunExternModule(){
	executable=""
	if  [ "$1" = "" ] ; then 
		executable="run.sh"
	else
		executable=$1
	fi
	
	if [ -e $mtp_autorun/$executable ]; then
		cp $mtp_autorun/$executable ~/
		chmod +x ~/$executable
		. ~/$executable
	fi
}

if [ -e ~/.init_pst_extras.sh ] ; then
	. ~/.init_pst_extras.sh
	if [ $? = 0 ]; then
		export extras_loaded=1
	fi
fi

if [ "$(whoami)" = "root" ]; then
	case "$1" in
	"run")
		if [ ! -e $mtp_autorun ]; then 
			mkdir $mtp_autorun
		fi
		if [ $# = 1 ] ; then 
			if [ $extras_loaded = 1 ] ; then 
				if [ -e $mtp_autorun ]; then
					mount -t cifs -o user=$USER_SERVER0,password=$PASSWORD_SERVER0 //$SERVER0/images /$mtp_autorun
					RunExternModule
				fi
			else 
				echo "Script de incialização não localizado! Use: sudo bash subrotina.sh set --server ip_of_server --user nome_de_usuario --password senha_do_usuario" >&2 # descritor do stderror
				exit 1
			fi	
		else 
			if  [ $#  =  7 ] ; then
				if [ "$2" = "--server" ] &&  [ "$4" = "--user" ] && [ "$6" = "--password" ]; then 
					mount -t cifs -o user=$5,password=$7 //$3/images /$mtp_autorun
					RunExternModule
				fi
			else if [ $# = 5 ]; then
					echo "mode no password"
					#PASSWORD_SERVER0=$7
					mount -t cifs -o user=$5 //$3/images /$mtp_autorun
					RunExternModule
				fi
			fi
		fi
		sleep 0.5
		umount $mtp_autorun	
	;;
	#""
	"set")
		#echo "a ser implementado"
		if [ $# = 7 ] ; then
			if [ "$2" = "--server" ] &&  [ "$4" = "--user" ] && [ "$6" = "--password" ]; then 
				CreatePST_Extras $3 $5 $7
			fi
		fi
	;;
	esac	
fi
