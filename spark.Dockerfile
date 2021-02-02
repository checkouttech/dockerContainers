
ARG JAVA_HOME=/opt/java
ARG JDK_PACKAGE=openjdk-14.0.2_linux-x64_bin.tar.gz
ARG SPARK_HOME=/opt/spark
ARG SPARK_PACKAGE=spark-3.0.1-bin-hadoop3.2.tgz


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
###  Install spark search
############################################

# Base image stage 2 
From ubuntu as spark 

#ARG JAVA_HOME
ARG SPARK_HOME
ARG SPARK_PACKAGE

WORKDIR /opt/

## download spark
COPY $SPARK_PACKAGE . 

RUN mkdir -p $SPARK_HOME/  && \
    tar -zxf $SPARK_PACKAGE --strip-components 1  -C $SPARK_HOME  && \
    rm -f $SPARK_PACKAGE 

# Mount elasticsearch.yml config
### ADD config/elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml

############################################
###  final 
############################################

From ubuntu as finalbuild

ARG JAVA_HOME
ARG SPARK_HOME
ARG SPARK_PACKAGE

WORKDIR /opt/

# get artifacts from previous stages 
COPY --from=jdk $JAVA_HOME $JAVA_HOME 
COPY --from=spark $SPARK_HOME   $SPARK_HOME 

# Setup JAVA_HOME, this is useful for docker commandline
ENV JAVA_HOME $JAVA_HOME
ENV SPARK_HOME $SPARK_HOME

# setup paths
ENV PATH $PATH:$JAVA_HOME/bin
ENV PATH $PATH:$SPARK_HOME/bin
ENV PYTHONPATH $PYTHONPATH:$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.4-src.zip 




# Expose ports 
EXPOSE 9200
EXPOSE 9300

# Define mountable directories.
#VOLUME ["/data"]


## give permission to entire setup directory
RUN useradd newuser --create-home --shell /bin/bash  && \ 
    echo 'newuser:newpassword' | chpasswd && \
    chown -R newuser $SPARK_HOME $JAVA_HOME  && \ 
    chown -R newuser:newuser /home/newuser && \
    chmod 755 /home/newuser
    #chown -R newuser:newuser /home/newuser
    #chown -R newuser /home/newuser  && \

# Install Python
RUN apt-get update && \ 
    apt-get install -yq curl  && \
    apt-get install -yq vim  && \
    apt-get install -yq  python3.9  



## Install PySpark and Numpy
#RUN \
#    pip install --upgrade pip && \
#    pip install numpy && \
#    pip install pyspark
#

USER newuser

WORKDIR /home/newuser

#RUN  chown -R newuser /home/newuser 

# Define default command.
#CMD ["elasticsearch"]



