FROM cern/cc7-base:20220201-1

MAINTAINER Enrico Bocchi <enrico.bocchi@cern.ch>


# Install frontier-squid
ADD ./repos/cern-frontier.repo /etc/yum.repos.d/cern-frontier.repo
ADD ./repos/RPM-GPG-KEY-cern-frontier /etc/pki/rpm-gpg/RPM-GPG-KEY-cern-frontier

ARG SQUID_VERSION
RUN yum -y install \
        frontier-squid${SQUID_VERSION} && \
    yum clean all && \
    rm -rf /var/cache/yum

# Run squid with default squid configuration
CMD ["/bin/bash", "-c", \
      "/usr/sbin/squid -f /etc/squid/squid.conf.frontierdefault -N -z && \
       /usr/sbin/squid -f /etc/squid/squid.conf.frontierdefault -N -d 1"]
