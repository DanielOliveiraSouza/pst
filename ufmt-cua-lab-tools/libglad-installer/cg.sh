#!/bin/bash

# makeSourceslist xenial
#função para mudar de diretório no script corrent

CG_LIBS="g++ freeglut3 freeglut3-dev libglew1.5 libglew1.5-dev libglu1-mesa libglu1-mesa-dev libgl1-mesa-dev libsoil-dev libsoil1  libglfw3-dev  libglfw3 libglfw3-doc libxi-dev -y"
changeDirectory(){
	if [ "$1" != "" ] ; then
		if [ -e $1  ]; then
			cd $1
		fi
	fi 
}

#função as bibliotecas de Computação gráfica
InstallCGlibs(){
	ret=0
	if [ "$(whoami)" = "root" ]; then
		sudo apt-get update
		sudo apt-get install $CG_LIBS
		if [ $? != 0 ]; then
			echo "wait 10 s to try apt-update"
			sleep 10
			apt-get update
			echo "waiting 50 s to try apt install $CG_LIBS ..."
			sleep 50
			dpkg --configure -a
			apt-get -f install 
			apt-get install $CG_LIBS  -y
		fi

		if [ -e $PWD/libglad-dev.deb ];then
			dpkg -i $PWD/libglad-dev.deb
			if [ $? != 0 ]; then
				ret=1
			fi
			ldconfig
		else
			ret=1
		fi
		return $ret
	fi
}

#g++ teste.cpp glad.c -o test  -lglfw -lm -lGLU -lGL -lX11 -lpthread -lXrandr -lXi -ldl

#----------------------- main_section -------------------------------------------------------

AUX_PATH=$0
AUX_PATH=${AUX_PATH%/cg.sh*} #expansão de variavel que remove  cg.sh restando a path
global_ret=0
if [ ! -e "$PWD/cg.sh" ]; then
	echo "ISPATH=$AUX_PATH"
	changeDirectory $AUX_PATH
fi
if  [ "$(whoami)" != "root" ]; then
	pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY bash $PWD/cg.sh
	global_ret=$?
	make clean
	make
	$PWD/teste.exe
#	echo "press enter to exit"
	#read
	if [ $global_ret = 0 ]; then
		notify-send   "Bibliotecas de CG instaladas com sucesso"
	else
		notify-send "Bibliotecas CG não foram instaladas, tente novamente ..."
	fi
else
	InstallCGlibs
	exit $?
fi

