#!/bin/bash

# Tag name
BASE_TAG='gitlab-registry.cern.ch/sciencebox/docker-images/frontier-squid'
REGISTRY_URL='gitlab-registry.cern.ch'

# Specify the frontier-squid version to install (or comment out to use the latest)
SQUID_VERSION='4.17-2.1'

# Build the Docker image
if [ -z $SQUID_VERSION ]; then
  TAG="$BASE_TAG:latest"
  docker build -t $TAG .
else
  TAG="$BASE_TAG:$SQUID_VERSION"
  docker build --build-arg SQUID_VERSION=-$SQUID_VERSION -t $TAG .
fi

# Push the image to the GitLab registry
if [ $? -eq 0 ]; then
  echo
  echo
  echo "Pushing image $TAG to $REGISTRY_URL"
  docker login $REGISTRY_URL
  docker push $TAG
fi
