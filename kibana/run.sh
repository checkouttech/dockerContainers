docker run --name kibana                     \
           --rm                              \
           -it                               \
           -p 9200:9200 -p 9300:9300         \
           --env "discovery.type=single-node" \
           -w  /home/newuser  \
           --net myNetwork   \
           --mount  source=myVolume,destination=/home/newuser/   \
           --hostname kibana01.docker.local \
           mykibana /bin/bash 




exit


