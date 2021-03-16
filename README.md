# Docker Wordpress Template

## What is it?
This in pack of containers to provide infra-structure to a wordpress website, where provide a complete wordpress enviremont with backup routine and SSL TLS certificate ready and simple.

We are using 3 containers to support Wordpress:
- Wordpress container (using bitnani container)
- Database container (using MariaDB)
- Backup container (a thin linux just to manager backup routine of wordpress and database)

And 3 containers to provide letsencrypt SSL TLS certificate.
- nginx-web
- nginx-gen
- nginx-letsencrypt
  
This is based in docker-letsencrypt containers (more info in https://github.com/evertramos/docker-letsencrypt)

A special thanks to letsencrypt that become possible secure internet giving SSL TLS certificate for free. 
More info about letencrypt project you can get in https://letsencrypt.org/


## Prerequeriments
In order to run this container you'll need:

- Linux Ubuntu 
- Docker
- Docker-compose

For tests, I used it in a mac OS and it works well too, maybe can work in a Windows OS, as all enviroment run in a docker container, but I didn't test.


## Actual version that I am using
```
uname -a
Linux nyc1-01 4.15.0-50-generic #54-Ubuntu SMP Mon May 6 18:46:08 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux

cat /etc/issue
Ubuntu 18.04.2 LTS \n \l

docker --version
Docker version 18.09.6, build 481bc77

docker-compose --version
docker-compose version 1.21.2, build a133471
```


## How setup your enviroment
To make container administration easy, I made a shell script called manager.sh and we will use it in steps bellow

Step by step to keep all running

1. First you need clone this repositorie to you server
```
git clone https://github.com/cleitonsouza01/docker-wordpress
```

2. Enter in docker-wordpress directory, create your own .env file based on .env-sample
```
cd docker-wordpress
cp .env-sample .env
```

3. Open the .env file and customize it as you like
```
vim .env
```

4. Setup docker configuration and create containers
```
./manager.sh setupcontainers
```

5. Create base directories and fix permissions using manager.sh script:
```
./manager.sh setupdir
```

6. And finally lets start the structure in verbose mode to see if all is working fine
```
./manager.sh startverbose
```

The first time that you start container is normal delay a little bit. When all is fine finilize the process using ctrl+c and then start again using daemon mode
```
./manager.sh start
```

Done! 

To check your wordpress page just open a browser and then open:
http://your-server-ip:port-you-choose-in-.env-file

example:
http://192.168.0.1:8050

## Issue on Mac OS
For some reason that I will check later, if you using Mac OS probaly you will get error on DB container.
A way to bypass it is creating manually the data directories, as bellow:
```
rm -rf data
mkdir -p data/wordpress_data/
mkdir -p data/mariadb_data/
```

## Where is SSL certificate?
To enable SSL certificate is incredible simple:

1. Enter in docker-letsencrypt directory, create your .env file copying from .env.sample
   ```
   cd docker-letsencrypt
   cp .env.sample .env
   cd..
   ```

2. Setup you server IP in you DNS provider
   
3. Stop your wordpress infra-structure
```
./manager.sh stop
```

1. Start docker-letsencrypt container
```
./manager.sh startnginx
```

3. Start you wordpress project
```
./manager.sh start
```

That's it!

## Backup
I have implemented a backup process that run every day at 3:00am, by default the process backup de database and wordpress files in a .tar.gz file located in ./backups directory.

You can make a manual backup sending a command directly to docker container

```
docker exec yourproject_bkp backup
```

To restore you can use command bellow replacing the date to date that make sense for you
```
docker exec yourproject_bkp restore 20141104
```


## Environment Variables

The environment variables file is .env


## Volumes

* data/
* backups/


## Useful File Locations

* `manager.sh` - Main script to manager this container
  
* `docker-compose.yaml` - Docker compose file


## Authors

* Cleiton Souza - cleitonsouza01@gmail.com

