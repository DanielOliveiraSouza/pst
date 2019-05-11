#!/bin/bash
#artigo que ensina sobrescrever string  https://stackoverflow.com/questions/3306007/replace-a-string-in-shell-script-using-a-variablE


CheckPST(){
	if [ "$1" != "" ] ; then
		if [ -e $1 ] ; then
			cont_modules=0
			PST_MODULES=(
				"configure_dns.sh"  
				"packages.sh"
				"setup.sh" 
				"global-proxy.sh"
				"main-pst.sh"
				"pst.sh"    
			)

			for ((i=0;i<${#PST_MODULES[*]} ;i++))
			do
				if [ -e ${PST_MODULES[i]} ]; then
					((cont_modules++))
				fi
			done

			if [ ${#PST_MODULES[*]} = $cont_modules ]; then
				return 1
			else 
				return 0
			fi
		fi
	fi
	return 0
}
