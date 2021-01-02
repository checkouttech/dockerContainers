
ARG JAVA_HOME=/opt/java
ARG JDK_PACKAGE=openjdk-14.0.2_linux-x64_bin.tar.gz
ARG KIBANA_HOME=/opt/kibana
ARG KIBANA_PACKAGE=kibana-7.10.1-linux-x86_64.tar.gz


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
###  Install kibana
############################################

# Base image stage 2 
From ubuntu as kibana 

#ARG JAVA_HOME
ARG KIBANA_HOME
ARG KIBANA_PACKAGE

WORKDIR /opt/

## download es
#  ADD https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.10.1-linux-x86_64.tar.gz  /  
#  ADD $JDK_PACKAGE / 
COPY $KIBANA_PACKAGE . 

RUN mkdir -p $KIBANA_HOME/  && \
    tar -zxf $KIBANA_PACKAGE --strip-components 1  -C $KIBANA_HOME  && \
    rm -f $KIBANA_PACKAGE 

# Mount kibana.yml config
ADD config/kibana.yml /opt/kibana/config/kibana.yml

############################################
###  final 
############################################

From ubuntu as finalbuild

ARG JAVA_HOME
ARG KIBANA_HOME
ARG KIBANA_PACKAGE

WORKDIR /opt/

# get artifacts from previous stages 
COPY --from=jdk $JAVA_HOME $JAVA_HOME 
COPY --from=kibana $KIBANA_HOME   $KIBANA_HOME 

# Setup JAVA_HOME, this is useful for docker commandline
ENV JAVA_HOME $JAVA_HOME
ENV KIBANA_HOME $KIBANA_HOME

# setup paths
ENV PATH $PATH:$JAVA_HOME/bin
ENV PATH $PATH:$KIBANA_HOME/bin

# Expose ports 
EXPOSE 5601

## give permission to entire kibana setup directory
RUN useradd newuser --create-home --shell /bin/bash  && \ 
    echo 'newuser:newpassword' | chpasswd && \
    chown -R newuser $KIBANA_HOME $JAVA_HOME  && \ 
    chown -R newuser:newuser /home/newuser && \
    chmod 755 /home/newuser
    #chown -R newuser:newuser /home/newuser
    #chown -R newuser /home/newuser  && \


RUN apt-get update && \ 
    apt-get install -yq curl && \
    apt-get install -y vim 


USER newuser

WORKDIR /home/newuser

#RUN  chown -R newuser /home/newuser 

# Define default command.
CMD ["kibana"]



