#!/bin/bash

read -p "Which folder you want to mount? ($HOME): " mount_src
if [ -z $mount_src ]
then
    mount_src="$HOME"
fi

read -p "Mount point in docker (/host): " mount_dist
if [ -z $mount_dist ]
then
    mount_dist="/host"
fi

echo $mount_src
echo $mount_dist

docker run -it --rm -v $mount_src:$mount_dist android_builder/ubuntu-14-04
