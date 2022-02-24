# frontier-squid

Docker image with frontier-squid proxy.


### Usage
- The image comes with the default frontier-squid configuration, which allows proxying traffic for local networks (typically private IP network ranges) on a variety of ports (e.g., 80, 443, 21, ...);
- The default container command will create the on-disk cache and start the squid process;
- The container exposes port 3128 on TCP protocol (provided that the container runtime allows publishing it on the host);
- Custom configuration can be provided by using this container in combination with Helm charts (or similar tools for container configuration) -- See [ScienceBox Frontier-squid chart](https://github.com/sciencebox/charts/tree/master/frontier-squid)

#### Example usage
- Provide the custom frontier-squid configuration file to the container;
- Initialize the cache directories for on-disk cache (if needed) with `squid -f <custom_configuration_file> -N -z` and run the squid process with `squid -f <custom_configuration_file> -N` -- The CMD in the provided Dockerfile is a good example to run the two in sequence in the same container;
- Cache is not persisted on containers unless a volume is used to store the cache directory -- which is quite useless anyway as squid wipes the on-disk cache upon restart.

### Exposing frontier-squid proxy
- The frontier-squid proxy listens on port 3128;
- This can be exposed by the container runtime on the host (e.g., with Docker `docker run -p 3128:3128 gitlab-registry.cern.ch/sciencebox/docker-images/frontier-squid`;
- In the case of deployment in Kubernetes (or other container orchestration engines) it is recommended to run multiple replicas of frontier-squid and expose them through a load-balanced service for availability and capacity reasons.
