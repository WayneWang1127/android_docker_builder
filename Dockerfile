FROM ubuntu:14.04
ARG userid
ARG groupid
ARG username
ARG userpwd=Aa111111
ARG httpproxy
ARG httpsproxy

# Setup apt proxy settings
RUN echo "Acquire::http::Proxy \"$httpproxy\";\nAcquire::https::Proxy \"$httpsproxy\";" > /etc/apt/apt.conf.d/99proxy
RUN cat /etc/apt/apt.conf.d/99proxy

# Install packages for Android building
RUN apt-get update && apt-get install -y git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip python openjdk-7-jdk libxml-opml-simplegen-perl libssl-dev

# Install others packages
RUN apt-get install -y vim

ENV HTTP_PROXY="$httpproxy"
ENV HTTPS_PROXY="$httpsproxy"
ENV http_proxy="$httpproxy"
ENV https_proxy="$httpsproxy"

# Download and install openjdk 8
RUN curl -o jdk8.tgz https://android.googlesource.com/platform/prebuilts/jdk/jdk8/+archive/master.tar.gz \
 && tar -zxf jdk8.tgz linux-x86 \
 && mv linux-x86 /usr/lib/jvm/java-8-openjdk-amd64 \
 && rm -rf jdk8.tgz

# Download repo file
#RUN curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo \
# && echo "d06f33115aea44e583c8669375b35aad397176a411de3461897444d247b6c220  /usr/local/bin/repo" | sha256sum --strict -c - \
# && chmod a+x /usr/local/bin/repo

# Setup username
RUN groupadd -g $groupid $username \
 && useradd -m -u $userid -g $groupid $username \
 && adduser $username sudo \
 && echo $username >/root/username \
 && echo "export USER="$username >>/home/$username/.gitconfig
RUN echo "$username:$userpwd" | chpasswd

COPY gitconfig /home/$username/.gitconfig
RUN chown $userid:$groupid /home/$username/.gitconfig
ENV HOME=/home/$username
ENV USER=$username

ENTRYPOINT chroot --userspec=$(cat /root/username):$(cat /root/username) / /bin/bash -i
