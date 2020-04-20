#!/bin/bash
######################################################################
# name: manager.sh
# description: Manager docker containers using docker-compose
# author: Cleiton Souza - cleitonsouza01@gmail.com
# version: 0.2
# date: 13/jun/19
######################################################################
PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin
RESTORE='\033[0m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\e[0;33m'

if [ ! -f .env ]; then
    echo -e "[${RED}ERROR${RESTORE}] .env file not found!"
    exit 1
fi

source .env

function setupcontainers 
{
    echo -e "[${GREEN}-${RESTORE}] Creating new docker network called webproxy..."
    docker network create webproxy

    echo
    echo -e "[${GREEN}-${RESTORE}] Creating backup containers..."

    echo 
    cd docker-backup
    docker build -t wp_bkp .
    exitcode=$?
    cd ..
    return $exitcode
}

function fixdir 
{
        # permissions based in discussion at https://stackoverflow.com/questions/18352682/correct-file-permissions-for-wordpress
        mkdir -p ./backups
        chown -R $USER:$USER ./backups
        mkdir -p ./data/mariadb_data/
        mkdir -p ./data/wordpress_data/ 
        chown -R 1001:1001 ./data/mariadb_data/
        chown -R 1000:daemon ./data/wordpress_data/
        find ./data/wordpress_data/ -type d -exec chmod 755 {} \;  # Change directory permissions rwxr-xr-x
        find ./data/wordpress_data/ -type f -exec chmod 664 {} \;  # Change file permissions rw-rw-r--

        echo
        echo -e "[${GREEN}OK${RESTORE}] Wordpress permissions fixed."
}

case "$1" in
	start)
        echo -e "[${GREEN}OK${RESTORE}] $PROJ_NAME starting as service..."
        docker-compose -p $PROJ_NAME -f docker-compose.yaml up -d
    ;;
    startverbose)
        echo -e "[${GREEN}OK${RESTORE}] $PROJ_NAME starting in verbose mode..."
        docker-compose -p $PROJ_NAME -f docker-compose.yaml up
    ;;      
    startnginx)
        echo -e "[${GREEN}OK${RESTORE}] $PROJ_NAME starting docker-compose-letsencrypt-nginx-proxy-companion service..."
        cd docker-compose-letsencrypt-nginx-proxy-companion
        ./start.sh
        cd..
    ;;
	stop)
		echo -e "[${GREEN}-${RESTORE}] $PROJ_NAME wil ${RED}STOP${RESTORE}"
        read -r -p "Are you sure? [Y/N] " response
        case ${response:0:1} in
            y|Y )
                echo -e "[${GREEN}-${RESTORE}] Stoping..."
                docker-compose -p $PROJ_NAME down
            ;;
            * )
                echo -e "[${GREEN}-${RESTORE}] canceled!"
                exit 0
            ;;
        esac
    ;;
    setupdir)
        if [ "$EUID" -ne 0 ]
            then echo -e "[${RED}ERROR${RESTORE}] Please run as sudo."
            exit
        fi
		echo "$PROJ_NAME Setup directory and fix permissions..."
		read -r -p "Are you sure? [Y/N] " response
        case ${response:0:1} in
            y|Y )
                echo Fixing...
                fixdir
            ;;
            * )
                echo -e "[${GREEN}-${RESTORE}] canceled!"
                exit 0
            ;;
        esac
    ;;
    setupcontainers)
        setupcontainers
        ;;
	*)
        echo "Manager docker tool"
		echo "$0 usage:"
		echo
		echo "$0 { start | startverbose | stop | startnginx | setupdir | setupcontainers }"
		echo
        echo "More information please read README file of the project"
		exit 1
	;;
esac

