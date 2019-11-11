# Author: noraj

# Official verified image
FROM php:7.3.11-alpine3.10

# date
RUN ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime

# copy files
COPY ./website/ /usr/src/app/

WORKDIR /usr/src/app

## INSTALL ##
# Print out php version for debugging
RUN php --version

## BUILD ##

# drop privileges
RUN adduser -s /bin/true -u 1337 -D -H noraj
USER noraj

# the file leaking the hidden service
COPY ./noraj_ssh_config.txt /home/noraj/.ssh/config

EXPOSE 9999

CMD php -S 0.0.0.0:9999