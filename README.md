UFMT CUA Lab Tools
=================================
[![Version](https://img.shields.io/badge/Release-v2.0--rc10-brightgreen)](https://github.com/DanielOliveiraSouza/ufmt-cua-lab-tools/blob/master/ufmt-cua-lab-tools/docs/release_notes.md) [![Build-status	](https://img.shields.io/badge/Revision-r31--05--2020-important)](https://github.com/DanielOliveiraSouza/ufmt-cua-lab-tools/blob/master/ufmt-cua-lab-tools/docs/changelog) [![Language](https://img.shields.io/badge/-%23!%2Fbin%2Fbash-1f425f.svg?logo=image%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw%2FeHBhY2tldCBiZWdpbj0i77u%2FIiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8%2BIDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMTExIDc5LjE1ODMyNSwgMjAxNS8wOS8xMC0wMToxMDoyMCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIDIwMTUgKFdpbmRvd3MpIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOkE3MDg2QTAyQUZCMzExRTVBMkQxRDMzMkJDMUQ4RDk3IiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOkE3MDg2QTAzQUZCMzExRTVBMkQxRDMzMkJDMUQ4RDk3Ij4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6QTcwODZBMDBBRkIzMTFFNUEyRDFEMzMyQkMxRDhEOTciIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6QTcwODZBMDFBRkIzMTFFNUEyRDFEMzMyQkMxRDhEOTciLz4gPC9yZGY6RGVzY3JpcHRpb24%2BIDwvcmRmOlJERj4gPC94OnhtcG1ldGE%2BIDw%2FeHBhY2tldCBlbmQ9InIiPz6lm45hAAADkklEQVR42qyVa0yTVxzGn7d9Wy03MS2ii8s%2BeokYNQSVhCzOjXZOFNF4jx%2BMRmPUMEUEqVG36jo2thizLSQSMd4N8ZoQ8RKjJtooaCpK6ZoCtRXKpRempbTv5ey83bhkAUphz8fznvP8znn%2B%2F3NeEEJgNBoRRSmz0ub%2FfuxEacBg%2FDmYtiCjgo5NG2mBXq%2BH5I1ogMRk9Zbd%2BQU2e1ML6VPLOyf5tvBQ8yT1lG10imxsABm7SLs898GTpyYynEzP60hO3trHDKvMigUwdeaceacqzp7nOI4n0SSIIjl36ao4Z356OV07fSQAk6xJ3XGg%2BLCr1d1OYlVHp4eUHPnerU79ZA%2F1kuv1JQMAg%2BE4O2P23EumF3VkvHprsZKMzKwbRUXFEyTvSIEmTVbrysp%2BWr8wfQHGK6WChVa3bKUmdWou%2BjpArdGkzZ41c1zG%2Fu5uGH4swzd561F%2BuhIT4%2BLnSuPsv9%2BJKIpjNr9dXYOyk7%2FBZrcjIT4eCnoKgedJP4BEqhG77E3NKP31FO7cfQA5K0dSYuLgz2TwCWJSOBzG6crzKK%2BohNfni%2Bx6OMUMMNe%2Fgf7ocbw0v0acKg6J8Ql0q%2BT%2FAXR5PNi5dz9c71upuQqCKFAD%2BYhrZLEAmpodaHO3Qy6TI3NhBpbrshGtOWKOSMYwYGQM8nJzoFJNxP2HjyIQho4PewK6hBktoDcUwtIln4PjOWzflQ%2Be5yl0yCCYgYikTclGlxadio%2BBQCSiW1UXoVGrKYwH4RgMrjU1HAB4vR6LzWYfFUCKxfS8Ftk5qxHoCUQAUkRJaSEokkV6Y%2F%2BJUOC4hn6A39NVXVBYeNP8piH6HeA4fPbpdBQV5KOx0QaL1YppX3Jgk0TwH2Vg6S3u%2BdB91%2B%2FpuNYPYFl5uP5V7ZqvsrX7jxqMXR6ff3gCQSTzFI0a1TX3wIs8ul%2Bq4HuWAAiM39vhOuR1O1fQ2gT%2F26Z8Z5vrl2OHi9OXZn995nLV9aFfS6UC9JeJPfuK0NBohWpCHMSAAsFe74WWP%2BvT25wtP9Bpob6uGqqyDnOtaeumjRu%2ByFu36VntK%2FPA5umTJeUtPWZSU9BCgud661odVp3DZtkc7AnYR33RRC708PrVi1larW7XwZIjLnd7R6SgSqWSNjU1B3F72pz5TZbXmX5vV81Yb7Lg7XT%2FUXriu8XLVqw6c6XqWnBKiiYU%2BMt3wWF7u7i91XlSEITwSAZ%2FCzAAHsJVbwXYFFEAAAAASUVORK5CYII%3D)](https://www.gnu.org/software/bash/) <!--[![bash-version](https://img.shields.io/debian/v/bash)](https://packages.debian.org/buster/bash)
-->
<p>
	UFMT CUA Lab Tools é um  conjunto de scripts que facilita a instalação de softwares de desenvolvimento, IDES,compiladores e bibliotecas que precisam ser instalados em um laboratório de programação ou em um computador pessoal de desenvolvedores.
	Desenvolvida desde 2014 e é utilizada nos laboratórios de programaçao da Universidade Federal de Mato Grosso - Campus Universitário do Araguaia.
</p>

Distribuições Linux Suportadas
---
<ul>
	<li>GNU/Linux Debian 9</li>
	<li>Ubuntu 16.04</li>
	<li>Ubuntu 18.04</li>
	<li>Linux Mint 18</li>
	<li>Linux Mint 19</li>
</ul>

Funcionalidades
---

<p>
	<ul>
		<li>Suporte Proxy</li>
		<li>Alteraçãção do hostname</li>
		<li>Instalação de ferramentas de desenvolvimento</li>
		<li>Reparação de sistema quebrado</li>
	</ul>
</p>

Proxy Suporte
---

Configuração automática de Proxy em:
<ul>
	<li>APT</li>
	<li>Terminal</li>
	<li>Navegador de Internet</li>
	<li>GIT</li>
	<li>SVN</li>
</ul>

Como usar?
---
<p>
	<strong>Para instalar a ferramenta na $PATH do sistema:</strong>
	<br><strong>Obs:</strong>Usar caminho absuluto.</br>
	<ol>
		<li>Baixe ou clone a ferramenta</li>
		<li>Extraia o arquivo zip e entre pst/ufmt-cua-lab-tools</li>
		<li>sudo bash /home/daniel/pst/ufmt-cua-lab-tools/main-pst.sh <em>--config</em></li>
		<li> Feche o terminal</li>
	</ol>
</p>

Ativação de Proxy Simplificada via Terminal (com aliases)
---
<p>
	<strong>Ativar Proxy:</strong>
	<pre>
		<em>ativa_proxy</em>
	</pre>
	<strong>Desatvar Proxy:</strong>
	<pre>
		<em>desativa_proxy</em>
	</pre>
	<strong>Obs:</strong>Ativação de proxy global exige root!
</p>

Principais comandos(sem exigir root)
---
<p>
	<strong>Configuração de Proxy </strong>
	<br><br><strong>Configuraçao de Proxy não autenticado:</strong></br></br>
	<pre>
		<br><strong>Sintaxe:	</strong>main-pst.sh <em>--set_proxy</em> [SERVIDOR] [PORTA] <em>--use-login</em> [FLAG_LOGIN]</br>
		main-pst.sh 	<em>	--set_proxy</em>	10.0.16.1 	3128 	<em>--use-login</em> 	0
	</pre>
	<br><strong>Configuração  de Proxy Autenticado</strong></br>
	<pre>
		<br><strong>Sintaxe:	</strong>main-pst.sh 	<em>--set_proxy</em> [SERVIDOR] [PORTA] <em>--use-login</em> [FLAG_LOGIN] [USUARIO] [SENHA]</br>
		main-pst.sh 	<em>--set_proxy</em>	10.0.16.1 	3128 	<em>--use-login</em> 	1 user	password
	</pre>
</p>

<p>
	<strong>Ativar Proxy:</strong>
	<pre>
		main-pst.sh 	<em>--ativa_proxy</em>
	</pre>
	<strong>Desativar Proxy:</strong>
	<pre>
		main-pst.sh 	<em>--desat_proxy</em>
	</pre>
</p>

Ativação de Proxy Global (exige root)
---
<p>
	Entre em terminal com root: com o comando <strong>sudo su</strong> ou <strong>su</strong>
	<pre>
		main-pst.sh 	<em>--ativa_proxy</em>
	</pre>
	<strong>Desativar Proxy:</strong>
	<pre>
		main-pst.sh 	<em>--desat_proxy</em>
	</pre>
</p>

Instalação de utilitários de desenvolvimento (exige root)
---
<p>
	Entre em terminal com root (use o comando: <strong>sudo su</strong> ou <strong>su</strong> )
	<br><strong>Atualizar e intalar todas  ferramentas de desenvolvimento</strong></br>
	<pre>
		main-pst.sh 	<em>--t</em>
	</pre>
	<br><strong>Instalar as bibliotecas de computação gráfica</strong></br>
	<pre>
		main-pst.sh 	<em>--i-cg</em>
	</pre>
	<br><strong>Instalar ferramentas para a disciplina de Redes de computadores</strong></br>
	<pre>
		main-pst.sh 	<em>--i-redes</em>
	</pre>
	<strong> Adicionar PPAS (com proxy ativado)</strong>
	<br><strong>Sintaxe:	</strong>main-pst.sh <em>--add_ppa</em> [PPA_URL]</br>
	<strong>Exemplo:</strong>
	<pre>
		main-pst.sh 	<em>--add_ppa</em>	 ppa:webupd8team/java
	</pre>
</p>

Atualização de hostname(exige root)
---
<p>
	Entre em terminal com root(use o comando: <strong>sudo su</strong> ou <strong>su</strong> )
	<pre>
		<br><strong>Sintaxe:	</strong>main-pst.sh <em>--at_hostname</em> [hostname]</br>
		main-pst.sh 	<em>	--at_hostname</em>	lab2-02 
	</pre>
	<strong>Obs:</strong>Feche o terminal após a execução do comando
</p>