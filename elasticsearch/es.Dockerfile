
ARG JAVA_HOME=/opt/java
ARG JDK_PACKAGE=openjdk-14.0.2_linux-x64_bin.tar.gz
ARG ES_HOME=/opt/elasticsearch
ARG ES_PACKAGE=elasticsearch-7.10.1-linux-x86_64.tar.gz


#MAINTAINER demo@gmail.com
#LABEL maintainer="demo@foo.com"


############################################
###  Install openjava
############################################

# Base image stage 1 
FROM ubuntu as jdk 

ARG JAVA_HOME
ARG JDK_PACKAGE

WORKDIR /opt/

## download open java
#  ADD https://download.java.net/java/GA/jdk14.0.2/205943a0976c4ed48cb16f1043c5c647/12/GPL/$JDK_PACKAGE /  
#  ADD $JDK_PACKAGE / 
COPY $JDK_PACKAGE . 

RUN mkdir -p $JAVA_HOME/ && \
    tar -zxf $JDK_PACKAGE --strip-components 1  -C $JAVA_HOME  && \
    rm -f $JDK_PACKAGE 


############################################
###  Install elastic search
############################################

# Base image stage 2 
From ubuntu as es 

#ARG JAVA_HOME
ARG ES_HOME
ARG ES_PACKAGE

WORKDIR /opt/

## download es
#  ADD https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.10.1-linux-x86_64.tar.gz  /  
#  ADD $JDK_PACKAGE / 
COPY $ES_PACKAGE . 

RUN mkdir -p $ES_HOME/  && \
    tar -zxf $ES_PACKAGE --strip-components 1  -C $ES_HOME  && \
    rm -f $ES_PACKAGE 

# Mount elasticsearch.yml config
ADD config/elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml

############################################
###  final 
############################################

From ubuntu as finalbuild

ARG JAVA_HOME
ARG ES_HOME
ARG ES_PACKAGE

WORKDIR /opt/

# get artifacts from previous stages 
COPY --from=jdk $JAVA_HOME $JAVA_HOME 
COPY --from=es  $ES_HOME   $ES_HOME 

# Setup JAVA_HOME, this is useful for docker commandline
ENV JAVA_HOME $JAVA_HOME
ENV ES_HOME $ES_HOME

# setup paths
ENV PATH $PATH:$JAVA_HOME/bin
ENV PATH $PATH:$ES_HOME/bin

# Expose ports 
EXPOSE 9200
EXPOSE 9300

# Define mountable directories.
#VOLUME ["/data"]

# Create the non-root user up front
#RUN adduser --system --group --no-create-home newuser


## give permission to entire elasticsearch setup directory
RUN useradd newuser --create-home --shell /bin/bash  && \ 
    echo 'newuser:newpassword' | chpasswd && \
    chown -R newuser $ES_HOME $JAVA_HOME  && \ 
    chown -R newuser:newuser /home/newuser && \
    chmod 755 /home/newuser
    #chown -R newuser:newuser /home/newuser
    #chown -R newuser /home/newuser  && \

USER newuser

WORKDIR /home/newuser

#RUN  chown -R newuser /home/newuser 

#RUN apt-get update && \ 
#    apt-get install -yq curl 

# Define default command.
CMD ["elasticsearch"]



