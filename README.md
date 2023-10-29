# Docker on a IPv6 only host
how to setup a docker on an ARM64 with IPv6 only (NAT64; 464XLAT) based on Debian/Ubuntu?

Requirements:
- ARM64 Host (Hetzner for example)
- IPv6
- NAT64 Gateway (use nat64.net if don't have one; thanks for Kaspar Dupont)
- Debian 11/Ubuntu 22.04 OS
- Linux skills

I strongly recommend to use a NAT64 gateway (including a DNS64 server for the translation) in addition with CLATD (464XLAT) that you can use legacy IP natively, even the application is not able to handle IPv6. :-)

## CLATD (464XLAT)
Follow the instruction from my previous blog entry:
[henschel.network](https://henschel.network/nat464xlat-with-clatd-on-ubuntu-18-04-lts/)

## Docker installation
Use the most recent version directly provided by docker.

Following the instructions from the docker documentation page:
[Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
[Debian](https://docs.docker.com/engine/install/debian/)

## Traefik with a wildcard certificate from letsencrypt 

using the following data structur:
- data
    - acme.json
    - config.yml
    - traefik.yml
- docker-compose.yaml