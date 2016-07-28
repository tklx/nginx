# tklx/nginx - web server
[![CircleCI](https://circleci.com/gh/tklx/nginx.svg?style=shield)](https://circleci.com/gh/tklx/nginx)

## Features

- Based on the super slim [tklx/base][base] (Debian GNU/Linux).
- Nginx installed directly from Debian.
- Uses [tini][tini] for zombie reaping and signal forwarding.
- Includes ``VOLUME /var/www`` for easy webroot access.
- Includes ``VOLUME /etc/nginx`` for easy config access.
- Includes ``EXPOSE 80 443``, so standard container linking will make it
  automatically available to the linked containers.
- Can be coupled with another container to provide SSL access and/or
  proxying.

## Usage

### Start a Nginx instance and connect to it from an application

```console
$ docker run --name some-nginx -d tklx/nginx
$ docker run --name some-app --link some-nginx:nginx -d app-that-uses-nginx
```

### Set up HTTPS websites

```console
$ docker run --name some-ssl-data -d some-ssl-vendor/some-ssl-container
$ docker run --name some-nginx -d tklx/nginx --volumes-from=some-ssl-data:ro
$ docker run -it --rm tklx/base:0.1.0 --volumes-from=some-nginx:rw
base$ echo 'server { listen 443 ssl; server_name www.example.com; ssl_certificate /etc/ssl/private/www.example.com; ssl_certificate_key /etc/ssl/private/www.example.com.key; root /var/www; }' >> /etc/nginx/sites-available/www.example.com
base$ ln -s /etc/nginx/sites-available/www.example.com /etc/nginx/sites-enabled/www.example.com
$ docker exec some-nginx nginx -s reload
$ docker run --name some-app --link some-nginx:nginx -d app-that-uses-nginx
```

We recommend using the official [guidelines][nginx-ssl] to set up your SSL server correctly.

## Status

Currently on major version zero (0.y.z). Per [Semantic Versioning][semver],
major version zero is for initial development, and should not be considered
stable. Anything may change at any time.

## Issue Tracker

TKLX uses a central [issue tracker][tracker] on GitHub for reporting and
tracking of bugs, issues and feature requests.

[base]: https://github.com/tklx/base
[tini]: https://github.com/krallin/tini
[nginx-ssl]: http://nginx.org/en/docs/http/configuring_https_servers.html 
[semver]: http://semver.org/
[tracker]: https://github.com/tklx/tracker/issues
