 # -*- coding: iso-8859-15 -*-

# UNIVERSIDADE FEDERAL DE MATO GROSSO
# CAMPUS UNIVERSITARIO DO ARAGUAIA
# AUTOR: DANIEL OLIVEIRA SOUZA
# DESCRIÇÃO: Script para configuração geral de proxy 
# Versão 2.0 rc 4
#

#Importando bibliotecas
import os;
import sys;
#------------------------Funções----------------------------------------------------------
def detDistroLinux():
	dist="Linux Mint";
	linux_arquivo = open("/etc/issue.net","r");
	conteudo = linux_arquivo.read();
	print conteudo;
	flag = conteudo.find(dist);
	if 0 <= flag:
		return 1;
	else:
		return 0;
	os.system("ls");


def Arquivos(codigo):
	#variaveis:
	apt_file = "";
	if codigo == 0:
		apt_file = "/etc/apt/apt.conf";
	else:
		apt_file = "/etc/apt/apt.conf.d/01proxy";

	print apt_file;
	return apt_file;


def CriarDados():
	use_proxy="";
	servidor_proxy="";
	autenticacao="";
	porta=0;
	usuario="";
	senha="";
	servidor_proxy=raw_input("Digite o endereço do servidor proxy \n");
	autenticacao=raw_input("O proxy é autenticado sim ou nao ?\n");
	if autenticacao == "sim":
		usuario=raw_input("Digite o nome do usuario:\n");
		senha=raw_input("Digite a senha:\n");
	porta=input("Digite o numero da porta:\n");



#--------------------------------------------------------------------------------------------------
#Região de chamada de função
flag = detDistroLinux();
Arquivos(flag);
CriarDados();