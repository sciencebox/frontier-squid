FROM docker.io/cern/alma9-base:20240701-2

MAINTAINER Enrico Bocchi <enrico.bocchi@cern.ch>

# Install curl for healthchecks
RUN dnf -y install \
       curl && \
    dnf clean all && \
    rm -rf /var/cache/dnf

# Create the squid user with uid:gid: 5000:5000
RUN /usr/sbin/groupadd -g 5000 squid && \
    /usr/sbin/useradd -u 5000 -g squid --home-dir /var/lib/squid --shell /sbin/nologin squid

# Install frontier-squid
ADD ./repos/cern-frontier.repo /etc/yum.repos.d/cern-frontier.repo
ADD ./repos/RPM-GPG-KEY-cern-frontier /etc/pki/rpm-gpg/RPM-GPG-KEY-cern-frontier

ARG SQUID_VERSION
RUN dnf -y install \
        frontier-squid-${SQUID_VERSION} && \
    dnf clean all && \
    rm -rf /var/cache/dnf

# Expose the port on which squid listens
EXPOSE 3128/tcp

# Run the squid process as the squid user created above
USER 5000:5000

# Run squid with default squid configuration
CMD ["/bin/bash", "-c", \
      "/usr/sbin/squid -f /etc/squid/squid.conf.frontierdefault -N -z && \
       /usr/sbin/squid -f /etc/squid/squid.conf.frontierdefault -N -d 1"]
