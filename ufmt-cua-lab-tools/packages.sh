#!/usr/bin/env bash
#Universidade federal de Mato Grosso
#Curso ciencia da computação
#Versão PST: 2.0-rc10 
#descrição : contém as listas de pacotes 
#Compativel:
#	Debian:
#		9 (stretch)		
#	Ubuntu:
#		16.04 (xenial xerus)
#		17.10 (Artful Aardvark)(encerra suporte em julho de 2018)
#		18.04 (bionic beaver)
#	Linux Mint:
#		18 (Sarah)
#		18.1 (Serena)
#		18.2 (Sonya)
#		18.3 (Sylvia)

#
#		19 (Tara -versão beta)
#	Descontinuados:
	# Ubuntu:
	# 	14.04 (Trusty Tarh)
	# 	16.10 (Yakkety Yak)
	# 	17.04 (Zesty Zapus)

	# Debian
	# 	7 (wheezy)
	# 	8 (Jessie)

	# LMDE


#------------------------------------------------------------------------------------------------------
#					PACKAGE MODULE
#------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------
#					PACOTES COMUNS  A  DISTRIBUICOES DEBIAN LIKE 
#-------------------------------------------------------------------------------------------------------

if [ "$PACKAGES_H_" = "" ]; then 
common_install=(
	"build-essential  cdbs devscripts dh-make fakeroot libxml-parser-perl check  "
	" ncurses-base ncurses-bin ncurses-term  swi-prolog  cifs-utils "
)
common_opt="postgresql qgis postgis "
common_libs="libncurses5 libncurses5-dev libmysqlcppconn-dev  " 

compilers_install="gcc clang g++ nasm  flex bison ddd  "
prog_tools="kate konsole codeblocks git subversion   "
network_tools="wireshark traceroute phpmyadmin apache2 mininet "
graphics_tools="libglu1-mesa libglu1-mesa-dev libgl1-mesa-dev libsoil-dev libsoil1  libglfw3-dev  libglfw3 libglfw3-doc libxi-dev "

dists_linux=("Debian" "Ubuntu" "Linux Mint")

#declare -A dists_linux


#Organização padrão Debian:
# stable
# old_stable
# old_old_stable
#strings versões linux
debian_v=("buster" "9")
ubuntu_lts_v=("18.04" "16.04")
ubuntu_rel_v=("17.10")
mint_v=("19" "18")


pkg_install=(
	"php7.2 openjdk-8-jdk "
	"php7.0 openjdk-8-jdk "
	
)

pkg_libs=(
	"libapache2-mod-php7.2 libglu1-mesa libglu1-mesa-dev libgl1-mesa-dev libsoil-dev libsoil1  libglfw3-dev  libglfw3 libglfw3-doc libxi-dev "
	"libapache2-mod-php7.0 "
)
#old_stable_opt_libs=
#ld_stable_opt=$xenial_install"qgis postgis "
pkg_opt_libs=(
	"libpqxx-4.0v5 libpqxx-dev libpostgresql-jdbc-java "
	"libpqxx-4.0 libpqxx-dev  postgresql libpqxx3-doc libpostgresql-jdbc-java "
	
)

debian_linux_modifications=(
	"mysql-community-server qt5-style-plugins " 
	"logisim checkinstall " #stable
)
ubuntu_linux_modifications=(
	"mysql-community-server logisim checkinstall "
	"mysql-community-server libqt5libqgtk2 logisim checkinstall "
	 
)

mint_linux_modifications=(
	"mysql-community-server"
	"mysql-community-server"
)
#codinome do debian testing pro stable
debian_codinames=(
	"buster"
	"stretch"
	
)

mysql_preconfig(){	
	local dist_release=$2
	local linux_dist=$1
	mysql_apt_config_versao="0.8.15-1_all"
	mysql_repository_deb_url="https://repo.mysql.com/mysql-apt-config_${mysql_apt_config_versao}.deb"
	wget -c $mysql_repository_deb_url
	if [ $? != 0 ]; then
		wget -c $mysql_repository_deb_url
	fi
	dpkg -i  mysql-apt-config_${mysql_apt_config_versao}.deb
	apt-get update
	if [  -e mysql-apt-config_${mysql_apt_config_versao}.deb ]; then
		rm mysql-apt-config_${mysql_apt_config_versao}.deb
	fi
	# debian_mysql_repository=(
	# 	"### THIS FILE IS AUTOMATICALLY CONFIGURED ###"
	# 	"# You may comment out entries below, but any other modifications may be lost."
	# 	"# Use command 'dpkg-reconfigure mysql-apt-config' as root for modifications."
	# 	"deb http://repo.mysql.com/apt/$linux_dist/ $dist_release mysql-8.0"
	# 	"deb http://repo.mysql.com/apt/$linux_dist/ $dist_release mysql-tools"
	# 	"# deb http://repo.mysql.com/apt/$linux_dist $dist_release mysql-tools-preview"
	# 	"deb-src http://repo.mysql.com/apt/$linux_dist $dist_release mysql-8.0"
	# )
	# if  [  !  -e /etc/apt/sources.list.d/mysql.list  ];then 
	# 	for i in ${!debian_mysql_repository[@]} 
	# 	do
	# 		echo ${debian_mysql_repository[i]}
	# 		if [ $i =  0 ]
	# 		then
	# 			echo ${debian_mysql_repository[$i]} > /etc/apt/sources.list.d/mysql.list
	# 		else
	# 			echo ${debian_mysql_repository[$i]} >> /etc/apt/sources.list.d/mysql.list
	# 		fi
	# 	done
	# 	echo "$APT_KEY_STRING_CONF"
	# 	#echo "$FLAG_HABILITA_PROXY"
	# 	if [ $FLAG_HABILITA_PROXY =  0 ]
	# 	then
	# 		apt-key adv --keyserver pgp.mit.edu  --recv-keys 5072E1F5
	# 	else
	# 		apt-key adv --keyserver pgp.mit.edu  $APT_KEY_STRING_CONF --recv-keys 5072E1F5
	# 	fi
	# fi
}
#pacotes compativeis com debian 9/ubuntu 18.04
#stable_libs="libapache2-mod-php7.2 libglu1-mesa libglu1-mesa-dev libgl1-mesa-dev libsoil-dev libsoil1  libglfw3-dev  libglfw3 libglfw3-doc libxi-dev "
#stable_opt_libs="libpqxx-4.0v5 libpqxx-dev libpostgresql-jdbc-java "
#stable_install="php7.2 openjdk-8-jdk "
#bionic_install="$bionic_install mysql-server-5.7 "

PACKAGES_H_="packages.sh"
fi
