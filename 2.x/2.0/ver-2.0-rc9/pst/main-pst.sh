#!/bin/bash
#Universidade federal de Mato Grosso
#Curso ciencia da computação
#Versão 0.0.3
#Descrição: Contem a função main do script pst.sh
#Contem a função principal do pst.sh
# Existe_arquivo(){
# 	if [ -e 
# USUARIOS_PC=($(cat /etc/group | grep 100 | cut -d: -f1))
# i=0
# PST_PATH=""
# while [ i -lt ${#USUARIOS_PC[@]} ] &&

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
					printf "PostInstall $versao\nDesenvolvido por: Daniel Oliveira Souza\nemail:oliveira.daniel109@gmail.com\n"
				;;
				"--at_hostname")	
					AtualizaHost $1 $2 $3;
				;;

				"--aj")
					Ajuda;
				;;


				#sessão que precisa ler dados

				"--at")	
				
					Repara_sistema_apt;		
					Atualiza_sistema;
				;;
				"--t")
					echo "O  script iniciará  a configuração em 10s e instalará arquivos para usar o proxy no APT"
					echo "Pressione CTRL+ C para parar o script ..."
					sleep 10
					Repara_sistema_apt;		
					Atualiza_sistema; 		
					Instala_componente; 
					Cria_APT_CONF $1 $2;
					

				;;
				"--i-e")	
					Repara_sistema_apt;		
					Instala_componente; 
				;;

				"--i-d")
					Repara_sistema_apt;
					# String que armazena os parametros passados por argumentos
					pack=($*); 
					apt-get install -y  --force-yes ${pack[@]} $APT_STRING_CONF
					
			
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

#configuração de dns 
if [ -e $(pwd)/configure_dns.sh ] && [ -x $(pwd)/configure_dns.sh ]; then
	. /$(pwd)/configure_dns.sh
fi