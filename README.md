**UFMT CUA Lab Tools v2.0.10-r11-05-2019**
<p>
	UFMT CUA Lab Tools é um  conjunto de scripts que facilita a instalação de softwares de desenvolvimento, IDES,compiladores e bibliotecas que precisam ser instalados em um laboratório de programação ou em um computador pessoal de desenvolvedores.
	Desenvolvid desde 2014 e é utilizada nos laboratórios de programaçao da Universidade Federal de Mato Grosso - Campus Universitário do Araguaia.
</p>

**Distribuições Linux Suportadas**
<ul>
	<li>GNU/Linux Debian 9</li>
	<li>Ubuntu 16.04</li>
	<li>Ubuntu 18.04</li>
	<li>Linux Mint 18</li>
	<li>Linux Mint 19</li>
</ul>

**Funcionalidades**
<p>
	<ul>
		<li>Suporte Proxy</li>
		<li>Alteraçãção do hostname</li>
		<li>Instalação de ferramentas de desenvolvimento</li>
		<li>Reparação de sistema quebrado</li>
	</ul>
</p>

**Proxy Suporte**
Configuração automática de Proxy em:
<ul>
	<li>APT</li>
	<li>Terminal</li>
	<li>Navegador de Internet</li>
	<li>GIT</li>
	<li>SVN</li>
</ul>

**Como usar?**
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

**Principais comandos(sem exigir root)**
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

**Ativação de Proxy Global (exige root)**
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

**Instalação de utilitários de desenvolvimento (exige root)**
<p>
	Entre em terminal com root: com o comando <strong>sudo su</strong> ou <strong>su</strong>
	<strong>Atualizar e intalar todas  ferramentas de desenvolvimento</strong>
	<pre>
		main-pst.sh 	<em>--t</em>
	</pre>
	<strong> Adicionar PPAS (com proxy ativado</strong>
	<br><strong>Sintaxe:	</strong>main-pst.sh <em>--add_ppa</em> [PPA_URL]</br>
	<strong>Exemplo:</strong>
	<pre>
		main-pst.sh 	<em>--add_ppa</em>	 ppa:webupd8team/java
	</pre>
	<strong>Atualizar e intalar todas  ferramentas de desenvolvimento</strong>
	<pre>
		main-pst.sh 	<em>--t</em>
	</pre>
</p>

**Atualização de hostname(exige root)**
<p>
	Entre em terminal com root: com o comando <strong>sudo su</strong> ou <strong>su</strong>
	<pre>
		<br><strong>Sintaxe:	</strong>main-pst.sh <em>--at_hostname</em> [hostname]</br>
		main-pst.sh 	<em>	--at_hostname</em>	lab2-02 
	</pre>
	<strong>Obs:</strong>Feche o terminal após a execução do comando
</p>