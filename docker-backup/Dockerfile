FROM ubuntu:latest
LABEL maintainer "Cleiton Souza <cleitonsouza01@gmail.com>"

RUN apt-get update && \
    apt-get install mysql-client cron bzip2 p7zip-full -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /backups

ENV MYSQL_ENV_MYSQL_HOST mariadb
ENV BACKUP_TIME 0 3 * * *

COPY docker-entrypoint.sh /entrypoint.sh
COPY backup restore /bin/

VOLUME /backups

ENTRYPOINT ["/entrypoint.sh"]

CMD ["cron", "-f"]
