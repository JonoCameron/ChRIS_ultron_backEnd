#!/bin/bash

source ./decorate.sh

declare -i STEP=0

export STOREBASE=${STOREBASE}

title -d 1 "Destroying pfcon_stack on swarm" "from  ./docker-compose_remote.yml"
    windowBottom
    echo "This might take a few minutes... please be patient."          | ./boxes.sh ${Yellow}
    windowBottom
    docker network rm remote
    docker stack rm pfcon_stack >& dc.out >/dev/null
    echo -en "\033[2A\033[2K"
    cat dc.out | ./boxes.sh
windowBottom

title -d 1 "Destroying CUBE containerized development environment" "from  ./docker-compose_dev.yml"
    echo "Do you want to also remove persistent volumes? [y/n]"             | ./boxes.sh
    windowBottom
    old_stty_cfg=$(stty -g)
    stty raw -echo ; REPLY=$(head -c 1) ; stty $old_stty_cfg
    echo -en "\033[2A\033[2K"
    # read -p  " " -n 1 -r REPLY
    if [[ $REPLY =~ ^[Yy]$ ]] ; then
        printf "Removing persistent volumes...\n"                           | ./boxes.sh ${Yellow}
        echo "This might take a few minutes... please be patient."          | ./boxes.sh ${Yellow}
        windowBottom
        docker-compose -f docker-compose_dev.yml down -v >& dc.out >/dev/null
        echo -en "\033[2A\033[2K"
        cat dc.out | ./boxes.sh
        echo "Removing ./FS tree"                                           | ./boxes.sh
        rm -fr ./FS
    else
        printf "Keeping persistent volumes...\n"                            | ./boxes.sh ${Yellow}
        echo "This might take a few minutes... please be patient."          | ./boxes.sh ${Yellow}
        windowBottom
        docker-compose -f docker-compose_dev.yml down >& dc.out >/dev/null
        echo -en "\033[2A\033[2K"
        cat dc.out | ./boxes.sh
    fi
windowBottom

title -d 1 "Stopping swarm cluster..."
    docker swarm leave --force >dc.out 2>dc.out
    cat dc.out                                                              | ./boxes.sh
windowBottom
