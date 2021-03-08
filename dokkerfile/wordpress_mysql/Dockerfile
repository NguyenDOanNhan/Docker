FROM ubuntu:20:04
RUN apt-get update \
    apt-get -y upgrade \
    && apt-get -y install nano net-tools
RUN apt-get update \
    && apt-get install -y apache2
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install mysql-server 