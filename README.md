# Docker Wordpress Template

## What is it?
This in pack of containers to provide infra-structure to a wordpress website, where provide a complete wordpress enviremont with backup routine and SSL certificate ready and simple.

We using 3 containers to support Wordpress:
- Wordpress container (using bitnani container)
- Database container (using MariaDB)
- Backup container (a thin linux just to manager backup routine of wordpress and database)

And 3 containers to provide SSL certicate based in Letsencrypt.
- nginx-web
- nginx-gen
- nginx-letsencrypt
  
This is based in docker-compose-letsencrypt-nginx-proxy-companion containers (more info in https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion)


## Prerequeriments
In order to run this container you'll need:

- Linux Ubuntu 
- Docker


## Actual version that I am using
```
uname -a
Linux sunokrom-nyc1-01 4.15.0-50-generic #54-Ubuntu SMP Mon May 6 18:46:08 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux

docker --version
Docker version 18.09.6, build 481bc77

docker-compose --version
docker-compose version 1.21.2, build a133471
```


## How setup your enviroment
To make container administration easy, I made a shell script called manager.sh

Step by step to keep all running

1. First you need clone this repositorie to you server
```
git clone https://github.com/cleitonsouza01/docker-wordpress-template
```

2. Enter in docker-wordpress-template directory, create your own .env file based on .env-sample
```
cd docker-wordpress-template
cp .env-sample .env
vim .env
```

3. Lets setup docker configuration and create containers
```
./manager.sh setupcontainers
```

4. Let's create base directories using manager.sh script:
```
./manager.sh setupdir
```

5. And finally lets start the structure in verbose mode to see if all is working fine
```
./manager.sh startverbose
```

The first time that you start container is normal delay a little bit. When all is fine finilize the process using ctrl+c and then instart again using daemon mode
```
./manager.sh start
```

Done! 

## Where is SSL certificate?
To enable SSL certificate is incredible simple:

1. Enter in docker-compose-letsencrypt-nginx-proxy-companion directory, create your .env file compying from .env.sample
   ```
   cd docker-compose-letsencrypt-nginx-proxy-companion
   cp .env.sample .env
   cd..
   ```

2. Setup you server IP in you DNS provider
   
3. Stop your wordpress infra-structure using:
```
./manager.sh stop
```

3. Start docker-compose-letsencrypt-nginx-proxy-companion container using command bellow
```
./manager.sh startnginx
```

3. Start you wordpress project:
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



## Other commands usage

```
./manager.sh createcontainers
```
This will create container structure in your server

---

```
./manager.sh start
```
This will start all containers of your infrastructure

---

```
./manager.sh createcontainers
```
This will create container structure in your server

---

```
./manager.sh createcontainers
```
This will create container structure in your server

---

#### Environment Variables

The environment variables file is .env


#### Volumes

* data/
* backups/


#### Useful File Locations

* `manager.sh` - Main script to manager this container
  
* `docker-compose.yaml` - Docker compose file

## Authors

* Cleiton Souza - cleitonsouza01@gmail.com


## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE v3

