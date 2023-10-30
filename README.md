# Docker on an IPv6 only host
how to setup a docker on an ARM64 with IPv6 only (NAT64; 464XLAT) based on Debian/Ubuntu?

Requirements:
- ARM64 Host (Hetzner for example)
- IPv6
- NAT64 Gateway (use [nat64.net](https://nat64.net/) if don't have one; thanks for Kaspar Dupont)
- Debian 11/Ubuntu 22.04 OS
- Linux skills
- basic docker (compose) skills
- a (free) top level domain (TLD)

I strongly recommend to use a NAT64 gateway (including a DNS64 server for the translation) in addition with CLATD (464XLAT) that you can use legacy IP natively, even the application is not able to handle IPv6. :-)

## CLATD (464XLAT)
Follow the instruction from my previous blog entry:
- [henschel.network](https://henschel.network/nat464xlat-with-clatd-on-ubuntu-18-04-lts/)
Including using NAT64/DNS64

## Docker installation
Use the most recent version directly provided by docker.

Following the instructions from the docker documentation page:
- [Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- [Debian](https://docs.docker.com/engine/install/debian/)

running docker container as non-root user:
- [Docker linux postinstall](https://docs.docker.com/engine/install/linux-postinstall/)
- or just run the script `fix-user-rights.sh`

The config file `/etc/docker/daemon.json` should look like:
```json
{
  "ipv6": true,
  "fixed-cidr-v6": "2001:db8:d0cc:e500:d::/80",
  "experimental": true,
  "ip6tables": true,
  "default-address-pools": [
    { "base": "172.17.0.0/16", "size": 16 },
    { "base": "172.18.0.0/16", "size": 20 },
    { "base": "172.19.0.0/16", "size": 20 },
    { "base": "172.20.0.0/14", "size": 20 },
    { "base": "172.24.0.0/14", "size": 20 },
    { "base": "172.28.0.0/14", "size": 20 },
    { "base": "192.168.0.0/16", "size": 24 }
  ]
}
```

## Traefik with a wildcard certificate from letsencrypt
using the following data structur (which is provided in that project as well):
- docker
    - traefik
        - docker-compose.yaml
        - data
            - acme.json
            - config.yml
            - traefik.yml

**Note**: the file `acme.json` must have the permission `600` and the ownership of `root:root`:
```sh
chmod 600 acme.json
sudo chown root:root acme.json
```

Explanation:
- `acme.json` is used to store all sensitive information from letsencrypt (private key, certificate)
- `config.yml` is used to have externally managed (non container) ressources/servers
- `traefik.yml` is used to have basic settings like DNS provider for letsencrypt

### DNS (from Hetzner)
the basic DNS zone will be provided automatically, like:
- SOA
- NS records

then you need the following records:
- `AAAA` (@) root pointing to your server IPv6 address
- `AAAA` `docker.example.net` also pointing to your server IPv6 address
- `CNAME *.example.net` pointing to `docker.example.net`
- `CNAME _acme-challenge.example.net` pointing to `docker.example.net` < this record is very important, it will not work proper without!

Note: do not point the wildcard record directly to the root domain, this will cause a loop and your setup will not work.

optionally you could harden your domain for email:
- `example.net MX 0 .` Null MX Record (no mail in and out)
- `example.net TXT "spfv1 -all"` SPF (Sender Policy Framework) to disallow sending mails with that domain (as envelope-FROM)
- `_dmarc.example.net TXT "v=DMARC1; p=reject"` DMARC (Domain-based Message Authentication, Reporting and Conformance) minimal record for rejecting unauthenticated senders.

also optionally but very useful, to implement a `CAA` Record:
- `example.net caa 128 issue "letsencrypt.org"`

## Special Thanks
My special thanks goes to Daniel Stocker alias Stoege for his great support and my mental support.