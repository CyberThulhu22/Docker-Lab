#!/bin/bash

## Check if the User is running the program as root.
if [ "$EUID" -ne 0 ]; then 
	printf "Please run as root!\n\t"
	exit
fi
	
clear
printf "[+] Welcome! We are going to be setting up your own personal lab.\n"
sleep 1

## Upgrading the system.
printf "[+] This script will begin with updating and upgrading your repository on the system.\n"
printf "\t[-] Beginning update...\n"
apt-get update -y -q=2
printf "\t[-] Done! Now beginning upgrades...\n"
apt-get upgrade -y -q=2
printf "\t[-] Done!\n"
sleep 2
clear

## Installing Necessary Repositories
printf "[+] Installing necessary packages from the repository.\n"
printf "\t[-] Installing 'apt-transport-http'...\n"
apt-get install apt-transport-https -y -q=2
printf "\t[-] Installed!\n"
printf "\t[-] Installing 'ca-certificates'...\n"
apt-get install ca-certificates -y -q=2
printf "\t[-] Installed!\n"
printf "\t[-] Installing 'curl'...\n"
apt-get install curl -y -q=2
printf "\t[-] Installed!\n"
printf "\t[-] Installing 'software-properties-common'...\n"
apt-get install software-properties-common -y -q=2
printf "\t[-] Installed!\n"
printf "\t[-] Installing 'docker.io'...\n"
apt-get install docker.io -y -q=2
printf "[+] Done! Continuing to next step.\n"
sleep 2
clear

## Setting up Docker Vulnerable machines
CHOICE=null
juice="bkimminich/juice-shop"
meta2="tleemcjr/metasploitable2"
wdvwa="vulnerables/web-dvwa"
hackz="mutzel/all-in-one-hackazon"
tfapi="tuxotron/tiredful-api"

#Pulling the Vulnerable Machines
docker pull $juice
docker pull $meta2
docker pull $wdvwa
docker pull $hackz
docker pull $tfapi

while [ $CHOICE != "quit" ]; do
	
	printf "Here is the List of applications to pentest:\n\n"
    printf "\t1.\t $(echo $juice| cut -d'/' -f2)\n"
    printf "\t2.\t $(echo $meta2| cut -d'/' -f2)\n"
    printf "\t3.\t $(echo $wdvwa| cut -d'/' -f2)\n"
    printf "\t4.\t $(echo $hackz| cut -d'/' -f2)\n"
    printf "\t5.\t $(echo $tfapi| cut -d'/' -f2)\n"
	read "What application would you like to choose?: " CHOICE
	
	# Starts Juice Shop
	if [ $CHOICE -eq "1" ]; do
        printf  "Starting Juice Shop\n"
        docker run -d --name juice_shop -p 3000:3000 bkimminich/juice-shop 
        printf "Please go to 127.0.0.1:3000\n\n"
        sleep 10
        read "Press enter when ready to kill and remove container." WAIT
        printf "Killing the container..."
        docker kill juice_shop
        printf "Removing container..."
        docker rm -f juice_shop
        
	# Starts Metasploitable2
	elif [ $CHOICE -eq "2" ]; do
        printf  "Starting Metasploitable 2\n"
	    docker run -it -d --name Metasploitable tleemcjr/metasploitable2 sh -c "/bin/services.sh && bash"
		printf "Hopping into Metasploitable 2\n"
	    docker attach Metasploitable		
		sleep 10
        read "Press enter when ready to kill and remove container." WAIT
        printf "Killing the container..."
        docker kill Metasploitable
        printf "Removing container..."
        docker rm -f Metasploitable

	# Starts Web DVWA
	elif [ $CHOICE -eq "3" ]; do
		printf  "Starting DVWA"
        docker run -d --name DVWA -p 81:81 vulnerables/web-dvwa
        printf "Nice.. Go to this address 127.0.0.1/install\n\n"
        sleep 10
        read "Press enter when ready to kill and remove container." WAIT
        printf "Killing the container..."
        docker kill DVWA
        printf "Removing container..."
        docker rm -f DVWA

	# Starts All in One Hackazon
	elif [ $CHOICE -eq "4" ]; do
		printf  "Starting Hackazon"
	    docker run --name hackazon -d -p 80:80 mutzel/all-in-one-hackazon
	    printf "Please wait about 30 seconds before going to site.."
	    printf "Nice.. Go this this address 127.0.0.1:80\n\n"
        sleep 10
        read "Press enter when ready to kill and remove container." WAIT
        printf "Killing the container..."
        docker kill hackazon
        printf "Removing container..."
        docker rm -f hackazon

	# Starts Tiredful API
	elif [ $CHOICE -eq "5" ]; do
        printf  "Starting Tiredful API"
        docker run --name Tiredful_API -p 8000:8000 tuxotron/tiredful-api
        printf "Please go to 127.0.0.1:8000"	
        sleep 10
        read "Press enter when ready to kill and remove container." WAIT
        printf "Killing the container..."
        docker kill Tiredful_API
        printf "Removing container..."
        docker rm -f Tiredful_API

	else
        printf "None of your conditions met the critera."
    fi
	
	
done