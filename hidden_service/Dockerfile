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
# runtime deps
RUN apk --no-cache add curl ruby=2.5.7-r0 ruby-dev=2.5.7-r0 ruby-json=2.5.7-r0 ruby-bundler=2.0.2-r0
# build deps
RUN apk --no-cache add coreutils git make gcc libc-dev g++ musl-dev libstdc++
# Print out ruby version for debugging
RUN ruby --version
RUN gem install sinatra thin addressable --no-document

## SUPERVISOR ##
# supervisor for multiple services
RUN apk --no-cache add supervisor
# don't ovveride the main conf
COPY supervisord.conf /etc/supervisord.conf

# drop privileges
RUN adduser -s /bin/true -u 1337 -D -H noraj
USER noraj

EXPOSE 9999

CMD ["/usr/bin/supervisord"]