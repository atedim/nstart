#!/bin/bash


#begin
bash <(wget -qO- https://raw.githubusercontent.com/atedim/nstart/main/nstart.sh)
#begin


###Testa ROOT###
if [[ $EUID -ne 0 ]]; then
   echo "Rode o Script como ROOT" 
   exit
fi
###Testa ROOT###

###Cria Pasta Scripts###
mkdir /etc/scripts
cd /etc/scripts
chmod -R 777 /etc/scripts
###Cria Pasta Scripts###


###Testa primeira execução###
if [ -d "/work" ] 
then
    	clear
	echo "Sistema ja esta Pronto, nada será alterado." 
    	echo "Atualizando o Script NTools." 
	cd /etc/scripts
	DATA=`date +%d%m%Y` 
	mv ntools $DATA.ntools.old
	chmod u-x *.old
	curl https://raw.githubusercontent.com/atedim/nstart/main/ntools -o ntools
	chmod u+x ntools
else
    echo "Sistema Limpo, Preparando Ambiente inicial."
###Testa primeira execução###


##atualiza sources###
apt update && apt upgrade -y && apt autoremove -y && apt clean
##atualiza sources###


###instala basicos###
apt-get install ntpdate rcconf mc rsync cifs-utils samba mergerfs htop iptraf net-tools gdu etherwake curl screen -y
###instala basicos###


###Atualiza data e hora###
unlink /etc/localtime
ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
ntpdate pool.ntp.org
###Atualiza data e hora###


##limpa espaço###
apt update && apt upgrade -y && apt autoremove -y && apt clean
##limpa espaço###


###backup inicial###
DATA=`date +%d%m%Y` 
cd / && tar zcvfp $DATA.etc.ORI.tgz /etc
###backup inicial###


###Ajusta ssh###
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
/etc/init.d/ssh restart
###Ajusta ssh###


###Insere Script to PATH###
sed -i -e '$a\' ~/.bashrc && echo 'export PATH=$PATH:/etc/scripts' >>~/.bashrc && sed -i -e '$a\' ~/.bashrc
###Insere Script to PATH###


###Muda senha Root###
echo -e "123456\n123456" | passwd root
###Muda senha Root###

###Cria Diretórios###
mkdir -p /work/all
mkdir -p /work/d/8pd{1..8}
mkdir -p /work/g/8preta{1,2,3}
mkdir -p /work/rack/16{0..9}
chmod -R 777 /work
###Cria Diretórios###

###Baixa Script NTools###
mkdir /etc/scripts
cd /etc/scripts
curl https://raw.githubusercontent.com/atedim/nstart/main/ntools -o ntools
chmod u+x ntools
###Baixa Script Tools###

###Cria o nao.txt###
cd /etc/scripts/ && touch nao.txt
###Cria o nao.txt###

###Ajusta permissao da pasta Scripts###
chmod -R 777 /etc/scripts
###Ajusta permissao da pasta Scripts###

###Executa o Script NTools###
cd /etc/scripts/ && ./ntools born
###Executa o Script NTools###

###Tudo Pronto###
echo "Sistema Ajustado."
#echo "Reinicie o sistema e execute o script Ntools."
###Tudo Pronto###

fi

