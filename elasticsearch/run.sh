docker run --name es                         \
           --rm                              \
           -it                               \
           -p 9200:9200 -p 9300:9300         \
           --env "discovery.type=single-node" \
           -w  /home/newuser  \
           --net myNetwork   \
           --mount  source=myVolume,destination=/home/newuser/   \
           learning_es_3  # /bin/bash 

           #-v  /tmp/f2:/home/newuser   \
           #-P                               \   randomly picks up any available port of host machine. Can be viewed using dockes ps -a or ports command

exit 

#  docker run --rm -it  -p 9200:9200 -p 9300:9300  learning_es_3   /bin/bash
#   docker run -d -p 80:80 my-ubuntu-apache-webserver
# docker  run -d  -v /Users/kapilmahant/workspace/dockers/apache-ubuntu:/newtemp/  -p 80:80 my_ubuntu_apache_webserver:0.1
#  docker run -d -p 9200:9200 docker.io/elasticsearch
#  docker run -d -p 8080:8080 -p 50000:50000  jenkins/jenkins

docker run [options] IMAGE [commands] [arguments]


  -i, --interactive                    Keep STDIN open even if not attached
  -t, --tty                            Allocate a pseudo-TTY
      --rm                             Automatically remove the container when it exits
      --name string                    Assign a name to the container
  -e, --env list                       Set environment variables .  # can be used to setup password or java home ( todo are they available in build ? ) 
  -P                                   will publish all exposed ports to random ports
  -d, --detach                         Run container in background and print container ID
      --mount mount                    Attach a filesystem mount to the container

  -h, --hostname string                Container host name   # es.vm.local 
  -l, --label list                     Set meta data on a container
  -v, --volume list                    Bind mount a volume
  -w, --workdir string                 Working directory inside the container


