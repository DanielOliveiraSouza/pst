#!/bin/sh
#Universidade federal de Mato Grosso
#Curso ciencia da computação
#Versão 0.0.1
#Descrição: Contem a função main do script pst.sh
#Contem a função principal do pst.sh


if [ -e $(pwd)/pst.sh ] && [ -x $(pwd)/pst.sh ]; then 
			. /$(pwd)/pst.sh;
			Habilita_proxy;
			VariaveisAPT;
			ReconfiguraAPT_CONF;
fi
	case "$1" in 
		"--aj")
		Ajuda;
		;;
		"--at")	Repara_sistema_apt;		Atualiza_sistema;
		;;
		"--t")	
			Repara_sistema_apt;		Atualiza_sistema; 		Instala_componete; 
		;;
		"--i-e")	Repara_sistema_apt;		Instala_componente; 
			;;
		
		"--i-d")
			Repara_sistema_apt;
			apt-get install $2 $3 $4 $5 $6 $7 $apt_string_conf;
			Habilita_update_notifier;
		;;
		--"conf_sudoers") Habilita_update_notifier;
		;;
		"--reconf-sudoers")		Restaura_etc_sudoers
		;;
		"--reconf-host")	ReparaHost $1 $2
		;;
		"--v")
			echo 'PostInstall' $versao '\nDesenvolvido por: Daniel Oliveira Souza\nemail:oliveira.daniel109@gmail.com'
		;;
		"--cr_apt")		Cria_APT_CONF;
		;;
		"--rm_apt")
			Remove_APT_CONF;
			 
		;;
		"--ls_dados")	Imprime;
			;;
		"--at_dados")
			Remove_APT_CONF;
			AtualizaDados $1 $2;
			Habilita_proxy;
			Cria_APT_CONF;
		;;
		"--exe_sub")	SubRotina $1 $2 $3;
		;;
		"--add_ppa")	Repara_sistema_apt; 	
			AdicionaPPA $1 $2;
		;;

		"--at_hostname")	AtualizaHost $1 $2 $3;
		;;
		"--ls_apt_conf")	echo $apt_conf;
		;;

		*)  echo "Parametro invalido"; Ajuda; 
		;;
	esac