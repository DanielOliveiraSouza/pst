#!/bin/sh
#Universidade federal de Mato Grosso
#Curso ciencia da computação
#Versão 0.0.3
#Descrição: Contem a função main do script pst.sh
#Contem a função principal do pst.sh

if [ -e $(pwd)/pst.sh ] && [ -x $(pwd)/pst.sh ]; then 
	. /$(pwd)/pst.sh;		

fi
	permissao=$(whoami);
	if [ "$permissao" = "root" ];then
		LeiaDados $1 $2		
		Habilita_proxy;
		VariaveisAPT;
		ReconfiguraAPT_CONF;

		
	# Regiao de codigo com poderes de root 
		case "$1" in
				#sessão que não precisa do script de dados
				"--conf_sudoers") 
					Habilita_update_notifier;
				;;
				"--reconf-sudoers")		
					Restaura_etc_sudoers;
				;;
				"--reconf-host")	
					ReparaHost $1 $2;
				;;
				"--v")
					echo 'PostInstall' $versao 'Desenvolvido por: Daniel Oliveira Souza\nemail:oliveira.daniel109@gmail.com'
				;;
				"--at_hostname")	
					AtualizaHost $1 $2 $3;
				;;

				"--aj")
					Ajuda;
				;;


				#sessão que precisa ler dados

				"--at")	Repara_sistema_apt;		
						Atualiza_sistema;
				;;
				"--t")	
					Repara_sistema_apt;		
					Atualiza_sistema; 		
					Instala_componente; 
				;;
				"--i-e")	
					Repara_sistema_apt;		
					Instala_componente; 
				;;

				"--i-d")
					Repara_sistema_apt;
					apt-get install $2 $3 $4 $5 $6 $7 $APT_STRING_CONF;
				;;
				
				"--cr_apt")		
					Cria_APT_CONF $1 $2;
				;;
				"--rm_apt")
					Remove_APT_CONF;
					Restaura_etc_sudoers;
				;;

				"--at_dados")
					Remove_APT_CONF;
					AtualizaDados $1 $2;
					Habilita_proxy;
					Cria_APT_CONF;
				;;
			
				"--add_ppa")	
					Repara_sistema_apt; 	
					AdicionaPPA $1 $2;
				;;

				
				*)
				  echo "Parametro invalido"; Ajuda; 
				;;
				
		esac ;
	Restaura_etc_sudoers;
	fi
