###################  Test de présence du paquet live-build  #########################################
test=$(lb --version)
if [ -n "$test" ]; then 
	echo -e "Live-Build installé en version $(echo $test)"
else 
	echo -e "Live-Build n'est pas installé, l'installation va démarrer \n "
	sudo apt install live-build
fi
#####################################################################################################


###################  Création du répertoire de travail  ############################################# 
sudo mkdir -p $HOME/live-debian
cd $HOME/live-debian
echo -e "Le script va construite l'image ISO dans le répertoire $HOME/live-debian"
#sudo lb config

#####################################################################################################
ubuntu=0
debian=0
dist="null"
echo -e "L'initialisation de la construction de l'image ISO est en cours, \n des choix sur la personnalisation de celle-ci vont vous être proposés. \n 
Veuillez répondre correctement. "
echo -e "Quel distribution de Linux ? \t [debian - ubuntu]"

while [ $debian -ne 1 ] | [ $ubuntu -ne 1 ]; do
	if [[ $dist == "debian" ]]; then 
		debian=1
		break
	elif [[ $dist == "ubuntu" ]]; then
       		ubuntu=1
		break	
	else
		if [[ $dist != "null" ]];then
			echo "Veuillez remplir correctement le champ indiqué"
		fi
		read dist
		continue
	fi
done



