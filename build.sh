#!/bin/bash

# Tag name
BASE_TAG='gitlab-registry.cern.ch/sciencebox/docker-images/frontier-squid'
REGISTRY_URL='gitlab-registry.cern.ch'

# Specify the frontier-squid and Enterprise Linux version
EL_VERSION='el9'
# Optionally comment this out if you want to use 'latest' by default
SQUID_VERSION="4.17-2.1.${EL_VERSION}"

# Build the Docker image
if [ -z $SQUID_VERSION ]; then
  TAG="$BASE_TAG:latest"
  docker build -t $TAG .
else
  TAG="$BASE_TAG:$SQUID_VERSION"
  docker build --build-arg SQUID_VERSION=$SQUID_VERSION -t $TAG .
fi

# Push the image to the GitLab registry
if [ $? -eq 0 ]; then
  echo
  echo
  echo "Pushing image $TAG to $REGISTRY_URL"
  docker login $REGISTRY_URL
  docker push $TAG
fi
