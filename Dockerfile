#
# Minimum Docker image to build Android AOSP
#
FROM ubuntu:16.04

MAINTAINER Kyle Manna <kyle@kylemanna.com>
MAINTAINER zhangzhao <mail.zhangzhao@gmail.com>

# /bin/sh points to Dash by default, reconfigure to use bash until Android
# build becomes POSIX compliant
RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    dpkg-reconfigure -p critical dash

ADD https://storage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
RUN chmod 755 /usr/local/bin/*

# Keep the dependency list as short as reasonable
RUN apt-get update && \
    apt-get install -y bc bison bsdmainutils build-essential curl \
        flex g++-multilib gcc-multilib git gnupg gperf lib32ncurses5-dev \
        lib32z1-dev libesd0-dev libncurses5-dev \
        libsdl1.2-dev libwxgtk3.0-dev libxml2-utils lzop sudo \
        openjdk-8-jdk vim-gnome ack-grep genisoimage \
        pngcrush schedtool xsltproc zip zlib1g-dev graphviz && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install latest version of JDK
# See http://source.android.com/source/initializing.html#setting-up-a-linux-build-environment
WORKDIR /tmp

# All builds will be done by user aosp
# COPY gitconfig /root/.gitconfig
# COPY ssh_config /root/.ssh/config

# The persistent data will be in these two directories, everything else is
# considered to be ephemeral
VOLUME ["/tmp/ccache", "/aosp"]

# Improve rebuild performance by enabling compiler cache
ENV USE_CCACHE 1
ENV CCACHE_DIR /tmp/ccache
ENV LANG=C.UTF-8
# Work in the build directory, repo is expected to be init'd here
WORKDIR /var/aosp

COPY utils/docker_entrypoint.sh /root/docker_entrypoint.sh
ENTRYPOINT ["/root/docker_entrypoint.sh"]
