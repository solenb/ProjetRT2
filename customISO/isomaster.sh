#! /bin/bash

###################  Test de présence du paquet live-build  #########################################
test=$(lb --version)										    #				
if [ -n "$test" ]; then 									    #
	echo -e "Live-Build installé en version $(echo $test)\n"				    #
else 												    #
	echo -e "Live-Build n'est pas installé, l'installation va démarrer \n "			    #
	sudo apt install live-build								    #
fi												    #
#####################################################################################################
path=$( realpath $0 | grep -o '^.*/' )

ubuntu=0
debian=0

dist="null"
################################################ Loop for the selection of the distribution #############################################################	
echo -e "L'initialisation de la construction de l'image ISO est en cours, \ndes choix sur la personnalisation de celle-ci vont vous être proposés." 	#
echo -e "Veuillez répondre correctement. \n\n"														#
echo -e "Quel distribution de Linux voulez-vous ? \t [debian / ubuntu]"											#
																			#
while [ $debian -ne 1 ] | [ $ubuntu -ne 1 ]; do														#
	if [[ $dist == "debian" ]]; then 														#
		debian=1																#
		break																	#
	elif [[ $dist == "ubuntu" ]]; then														#
       		ubuntu=1																#
		break																	#
	else																		#
		if [[ $dist != "null" ]];then														#
			echo "Veuillez remplir correctement le champ indiqué \n"									#
		fi																	#
		read dist																#
		continue																#
	fi																		#
done																			#
#########################################################################################################################################################

######################### Test et remplacement de la distribution Linux #################
if [ $debian -eq 1 ]; then 								#
	distrib=$( cat config | sed -n '9p' | awk '{print $2}' | sed -e  's/"//g')	#
	sed -i "s/$distrib/buster/g" config						#
else 											#
	distrib=$( cat config | sed -n '9p' | awk '{print $2}' | sed -e  's/"//g')	#
	sed -i "s/$distrib/focal/g" config						#
fi											#
											#
if [ $debian -eq 1 ]; then 								#
	distrib_l=$( cat config | sed -n '6p' | awk '{print $2}' | sed -e  's/"//g')	#
	sed -i "s/$distrib_l/debian/g"	config						#
else 											#
	distrib_l=$( cat config | sed -n '6p' | awk '{print $2}' | sed -e  's/"//g')	#
	sed -i "s/$distrib_l/ubuntu/g"	config						#
fi											#
#########################################################################################

######################### Ajout des metapaquets d'environnement nécessaires #####
echo -e "Remplissage des metapaquets d'environnement nécessaires\n"		#
										#
base_pak="task-desktop\ntask-french\ntask-french-desktop\nconsole-setup"	#
echo "" > package.list.chroot							#
echo -e $base_pak >> package.list.chroot					#
#################################################################################



#### Ubuntu environment metapackages ####
gnome_u=0				#
kde_u=0					#
mate_u=0				#
cinnamon=0				#
#########################################

#### Debian environment metapackages ####
gnome_d=0				#
kde_d=0					#
mate_d=0				#
#########################################

########################################################### Loop for environment metapackages selection #########################################################
envi="null"																			#
if [ $debian -eq 1 ]; then																	#
	echo -e "Quel envirronement graphique Debian voulez-vous ? \t [gnome_d / kde_d / mate_d]"								#
else																				#	
	echo -e "Quel envirronement graphique Ubuntu voulez-vous ? \t [gnome_u / kde_u / mate_u / cinnamon]"							#
fi																				#
																				#
while [ $gnome_u -ne 1 ] | [ $kde_u -ne 1 ] | [ $mate_u -ne 1 ] | [ $cinnamon -ne 1 ] | [ $gnome_d -ne 1 ] | [ $kde_d -ne 1 ] | [ $mate_d -ne 1 ]; do		#
	if [[ $envi == "gnome_u" ]]; then															# 
		gnome_u=1																	#
		fin_env="gnome-shell"																# 			 break 																		 #
	elif [[ $envi == "kde_u" ]]; then															#
       		kde_u=1																		#	
		fin_env="plasma-desktop"															#
		break																		#
	elif [[ $envi == "mate_u" ]]; then															#
       		mate_u=1																	#
		fin_env="mate-desktop-environment-core"														#
		break																		#
	elif [[ $envi == "cinnamon" ]]; then															#
       		cinnamon=1																	#
		fin_env="cinnamon-core"																#
		break																		#
	elif [[ $envi == "gnome_d" ]]; then															#
       		gnome_d=1																	#
		fin_env="task-gnome-desktop"															#
		break																		#
	elif [[ $envi == "kde_d" ]]; then															#
       		kde_d=1																		#
		fin_env="task-kde-desktop"															#
		break																		#
	elif [[ $envi == "mate_d" ]]; then															#
       		mate_d=1																	#
		fin_env="mate-desktop-environment"														#
		break																		#
	else																			#
		if [[ $envi != "null" ]];then															#
			echo "Veuillez remplir correctement le champ indiqué \n"										#
		fi																		#
		read envi																	#
		continue																	#
	fi																			#
done																				#
																				#
#### Ajout du metapaquet d'environnement dans le fichier des paquets ####											#
echo -e $fin_env >> package.list.chroot					#											#
#########################################################################											#
																				#
#################################################################################################################################################################





########################################## Loop for additional packages #########################	
echo -e "\nVeuillez maintenant ajouter les paquets à inclure dans l'environnement."		#
echo -e "Veillez à taper le nom exacte du ou des paquets désirés, séparés par un espace."	#
echo -e "Une fois tous les paquets ajoutés, faites un "retour chariot" (entré). \n"		#
												#
read -a packets											#
packetsLength=$(echo ${#packets[@]})								#
arrayp=$(echo ${packets[@]})									#
												#
for i in `seq 1 $packetsLength`; do								#
	echo $arrayp | cut -d" " -f$i >> package.list.chroot					#
done												#
#################################################################################################


########################################## Loop for new files ###########################################	
echo -e "\nVeuillez maintenant ajouter les fichier à inclure dans l'environnement."			#
echo -e "Veillez à taper le chemin exacte du ou des fichiers désirés, séparés par un espace. "		#
echo -e "Une fois tous les chemins de fichiers ajoutés, faites un "retour chariot" (entré). \n"		#
													#
read -a files												#
fileLength=$(echo ${#files[@]})										#	
arrayf=$(echo ${packets[@]})										#
													#
for i in `seq 1 $fileLength`; do									#
	echo $arrayf | cut -d" " -f$i | xargs -i cp {}  includes.binary/ 				#
done													#
#########################################################################################################

###################  Création du répertoire de travail  ################################################# 
sudo mkdir -p $HOME/live-debian-project							            	#
cd $HOME/live-debian-project									    	#
echo -e "Le script va construite l'image ISO dans le répertoire $HOME/live-debian-project"	    	#
echo -e "Voulez vous construite la base de l'image ? [y-n]"						#
read base												#
if [ $base == "y" ];then										#
	sudo lb config &> /dev/null									#
else													#
	exit 1											    	#	
fi													#
#########################################################################################################

#### Construction de l'image ISO Live ###################################################################################################
yes | sudo cp -u $path/config $HOME/live-debian-project/auto/										#
yes | sudo cp -u $path/package.list.chroot $HOME/live-debian-project/config/package-lists/						#
yes | sudo cp -ur $path/includes.binary/* $HOME/live-debian-project/config/includes.binary/						#
																	#
echo -e "Votre Image Live va être contruite êtes vous sur de vouloir lancer cette opération (cela prend quelques minutes) ? [y-n]"	#
read build_l																#
if [ $build_l == "y" ]; then 														#
	sudo lb build															#
else 																	#
	echo -e "Vous pourrez la commande de construction tout seul grâce à [lb build]"							#
fi																	#	
#########################################################################################################################################
