FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -y install gnupg ca-certificates tzdata

COPY irods-signing-key.asc /irods-signing-key.asc
RUN apt-key add /irods-signing-key.asc
RUN echo "deb [arch=amd64] https://packages.irods.org/apt/ bionic main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install irods-icommands
