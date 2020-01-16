#### DOCKER FILE FOR frontier-squid IMAGE ###

###
# export RELEASE_VERSION="4.9-4.1"
# docker build -t gitlab-registry.cern.ch/sciencebox/docker-images/frontier-squid:${RELEASE_VERSION} --build-arg SQUID_VERSION=${RELEASE_VERSION} -f frontier-squid.Dockerfile .
# docker login gitlab-registry.cern.ch
# docker push gitlab-registry.cern.ch/sciencebox/docker-images/frontier-squid:${RELEASE_VERSION}
###


FROM cern/cc7-base:20191107

MAINTAINER Enrico Bocchi <enrico.bocchi@cern.ch>


# ----- Set environment and language ----- #
ENV DEBIAN_FRONTEND noninteractive
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# ----- Install frontier-squid ----- #
ADD ./repos/cern-frontier.repo /etc/yum.repos.d/cern-frontier.repo
ADD ./repos/RPM-GPG-KEY-cern-frontier /etc/pki/rpm-gpg/RPM-GPG-KEY-cern-frontier
ARG SQUID_VERSION
ENV INSTALL_VERSION=${SQUID_VERSION:+-$SQUID_VERSION}
ENV INSTALL_VERSION=${INSTALL_VERSION:-}
RUN yum -y install \
        frontier-squid${INSTALL_VERSION} && \
    yum clean all && \
    rm -rf /var/cache/yum

# ----- Copy default configuration files ----- #
ADD ./frontier-squid.d/squid.conf /etc/squid/squid.conf

# ----- Initialize cache directory ----- #
RUN squid -N -f /etc/squid/squid.conf -z

# ----- Run squid ----- #
CMD ["squid", "-f", "/etc/squid/squid.conf", "-d", "1", "--foreground"]

