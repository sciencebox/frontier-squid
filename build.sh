#!/bin/bash

# Tag name
BASE_TAG='gitlab-registry.cern.ch/sciencebox/docker-images/frontier-squid'

# Specify the frontier-squid version to install (or comment out to use the latest)
SQUID_VERSION='4.17-1.1'

# Build the Docker image
if [ -z $SQUID_VERSION ]; then
  TAG="$BASE_TAG:latest"
  docker build -t $TAG .
else
  TAG="$BASE_TAG:$SQUID_VERSION"
  docker build --build-arg SQUID_VERSION=-$SQUID_VERSION -t $TAG .
fi

# Push the image to the GitLab registry
docker login gitlab-registry.cern.ch
docker push $TAG
