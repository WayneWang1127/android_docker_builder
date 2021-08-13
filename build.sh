#!/bin/bash

function CheckDockerIsInstalled() {
    if [ -z $(command -v docker) ]
    then
        echo -e "\033[1;31mFail\nYou haven't installed docker, please install Docker.\033[m See https://docs.docker.com/engine/install/ubuntu/"
        return 1
    fi

    return 0
}

echo ""
echo -e "\033[1mChecking Docker is installed ... \c\033[m"

# 1 - Check Docker is installed
CheckDockerIsInstalled
if [ $? -ne 0 ]
then
    exit 1
fi
echo -e "\033[1;32mDone\n\033[m"

# 2 - Enter user information
read -p "  Enter user name ($(id -un)): " username
if [ -z $username ]
then
    username="$(id -un)"
fi

read -p "  Enter user password (Aa111111): " userpwd
if [ -z $userpwd ]
then
    userpwd="Aa111111"
fi

read -p "  Enter user id ($(id -u)): " userid
if [ -z $userid ]
then
    userid="$(id -u)"
fi

read -p "  Enter group id ($(id -g)): " groupid
if [ -z $groupid ]
then
    groupid="$(id -g)"
fi

echo -e "\033[1mInput user information ... \c\033[m"
echo -e "\033[1;32mDone\n\033[m"

# 3 - Setup HTTP/HTTPS proxy
read -p "  Setup HTTP proxy ($http_proxy): " httpproxy
if [ -z $httpproxy ]
then
    httpproxy=$http_proxy
fi

read -p "  Setup HTTPS proxy ($https_proxy): " httpsproxy
if [ -z $httpsproxy ]
then
    httpsproxy=$https_proxy
fi

echo -e "\033[1mSetup HTTP/HTTPS proxy ... \c\033[m"
echo -e "\033[1;32mDone\n\033[m"

# 4 - Build Docker image
docker build --build-arg userid=$userid \
             --build-arg groupid=$groupid \
             --build-arg username=$username \
             --build-arg userpwd=$userpwd \
             --build-arg httpproxy=$httpproxy \
             --build-arg httpsproxy=$httpsproxy \
             -t android_builder/ubuntu-14-04 .
if [ $? -ne 0 ]
then
    echo -e "\033[1mBuild Docker image ... \c\033[m"
    echo -e "\033[1;31mFail\n\033m"
    exit 1
fi

echo -e "\033[1mBuild Docker image ... \c\033[m"
echo -e "\033[1;32mDone\n\033[m"
