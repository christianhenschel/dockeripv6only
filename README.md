# Docker on a IPv6 only host
how to setup a docker on an ARM64 with IPv6 only (NAT64; 464XLAT) based on Debian/Ubuntu?

Requirements:
- ARM64 Host (Hetzner for example)
- IPv6
- NAT64 Gateway (use nat64.net if don't have one; thanks for Kaspar Dupont)
- Debian 11/Ubuntu 22.04 OS
- Linux skills

## CLATD (464XLAT)


## Docker installation


## Traefik with a wildcard certificate from letsencrypt 

using the following data structur:
- data
    - acme.json
    - config.yml
    - traefik.yml
- docker-compose.yaml