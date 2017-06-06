#
# Minimum Docker image to build Android AOSP
#
FROM ubuntu:14.04

MAINTAINER Kyle Manna <kyle@kylemanna.com>
MAINTAINER zhangzhao <mail.zhangzhao@gmail.com>

# Setup for Java
ADD jdk-6u45-linux-x64.bin /usr/jdk-6u45-linux-x64.bin
RUN cd /usr && chmod +x jdk-6u45-linux-x64.bin && ./jdk-6u45-linux-x64.bin
ENV JAVAHOME=/usr/jdk1.6.0_45
ENV PATH=/usr/jdk1.6.0_45/bin/:/usr/jdk1.6.0_45/jre/bin/${PATH}
ENV CLASSPATH=/usr/jdk1.6.0_45/lib:/usr/jdk1.6.0_45/jre/lib

# /bin/sh points to Dash by default, reconfigure to use bash until Android
# build becomes POSIX compliant
#RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
#    dpkg-reconfigure -p critical dash

ADD https://storage.googleapis.com/git-repo-downloads/repo /usr/bin/
RUN chmod 755 /usr/bin/repo

# Keep the dependency list as short as reasonable
RUN apt-get update && \
    apt-get install -y bc bison bsdmainutils build-essential curl \
        flex g++-multilib gcc-multilib git gnupg gperf lib32ncurses5-dev \
        lib32readline-gplv2-dev lib32z1-dev libesd0-dev libncurses5-dev \
        libsdl1.2-dev libwxgtk2.8-dev libxml2-utils lzop \
        vim-gnome ack-grep genisoimage \
        pngcrush schedtool xsltproc zip zlib1g-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#ADD https://commondatastorage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
#RUN chmod 755 /usr/local/bin/*

# All builds will be done by user aosp
RUN useradd --create-home aosp
#ADD gitconfig /home/aosp/.gitconfig
#ADD ssh_config /home/aosp/.ssh/config
#RUN chown aosp:aosp /home/aosp/.gitconfig

# The persistent data will be in these two directories, everything else is
# considered to be ephemeral
VOLUME ["/tmp/ccache", "/aosp"]

# Improve rebuild performance by enabling compiler cache
ENV USE_CCACHE 1
ENV CCACHE_DIR /var/aosp/ccache
ENV LANG=C.UTF-8
# Work in the build directory, repo is expected to be init'd here
USER aosp
WORKDIR /var/aosp
