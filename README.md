# tklx/nginx - web server
[![CircleCI](https://circleci.com/gh/tklx/nginx.svg?style=shield)](https://circleci.com/gh/tklx/nginx)

## Features

- Based on the super slim [tklx/base][base] (Debian GNU/Linux).
- Nginx installed directly from Debian.
- Uses [tini][tini] for zombie reaping and signal forwarding.
- Includes ``EXPOSE 80 443``, so standard container linking will make it
  automatically available to the linked containers.
- Can be coupled with another container to provide SSL access and/or
  proxying.
- Configured to forward access and error logs to docker log collector.

## Usage

### Simple static site hosting

#### From host

```console
$ docker run --name some-nginx -v /some/content:/var/www/html:ro -d tklx/nginx
```

```console
$ docker run --name some-nginx -v /some/content:/var/www/html:ro -v /some/config/file:/etc/nginx/sites-available/default:ro -d tklx/nginx
```

#### From host (cleaner solution with Dockerfile)

```console
$ ls
html/ default Dockerfile

$ cat Dockerfile
FROM tklx/nginx
COPY html /var/www/html
COPY default /etc/nginx/sites-available/default

$ docker build -t some-content .
$ docker run --name some-nginx -d some-content
```

#### From another container

```console
$ docker run --name some-content -v /var/www/html some-content
$ docker run --name some-nginx --volumes-from=some-content -d tklx/nginx
```

### Exposing the port

#### Specific port

```console
$ docker run --name some-nginx -d -p 8080:80 tklx/nginx
```

#### Docker-chosen port
```console
$ docker run --name some-nginx -dP tklx/nginx
$ docker port some-nginx
443/tcp -> 0.0.0.0:32770
80/tcp -> 0.0.0.0:32771
```

### Setting up HTTPS websites

```console
$ docker run --name some-certs -v /etc/ssl/private:ro -d cert-provider
$ docker run --name some-config -v /etc/nginx/ -d config-provider
$ docker exec some-config cat /etc/nginx/sites-enabled/www.example.com
server {
    listen 443 ssl;
    server_name www.example.com;

    ssl_certificate /etc/ssl/private/www.example.com;
    ssl_certificate_key /etc/ssl/private/www.example.com.key;

    root /var/www;
}
$ docker run --name some-nginx --volumes-from=some-certs --volumes-from=some-config -d tklx/nginx
```

We recommend using the official [guidelines][nginx-ssl] to set up your SSL server correctly.

### Setting up a reverse proxy

```console
$ docker run --name some-app -v /var/www -v /etc/nginx/sites-available -d backend-app
$ docker run --name some-nginx --volumes-from=some-app --link some-app:some-app -d tklx/nginx
$ docker exec some-nginx ls /etc/nginx/sites-enabled/
some-app-site
$ docker exec some-nginx cat /etc/nginx/sites-enabled/some-app-site
server {
    listen 80 default_server;
    server_name www.example.com;

    root /var/www;

    location / {
        try_file $url $url/ @backend = 404;
    }

    location @backend {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_pass http://some-app/;
        proxy_redirect default;
    }
}
```



### Setting up a reverse proxy with SSL termination

```console
$ docker run --name some-certs -v /etc/ssl/private:ro -d cert-provider
$ docker run --name some-app -v /var/www -v /etc/nginx/sites-available -d backend-app
$ docker run --name some-nginx --volumes-from=some-app --volumes-from=some-certs --link some-app:some-app -d tklx/nginx
$ docker exec some-nginx ls /etc/nginx/sites-enabled/
some-app-site
$ docker exec some-nginx cat /etc/nginx/sites-enabled/some-app-site
server {
    listen 80 default_server;
    server_name www.example.com;

    listen 443 ssl default_server;

    root /var/www;

    ssl_certificate /etc/ssl/private/www.example.com.pem;
    ssl_certificate_key /etc/ssl/private/www.example.com.key;

    location / {
        try_file $url $url/ @backend = 404;
    }

    location @backend {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $http_host;
        proxy_pass http://some-app/;
        proxy_redirect default;
    }
}
```

For further info on SSL termination, please refer to the [official documentation][nginx-ssl-termination].

### Tips

To disable access and/or error logs forwarding to the docker log
collector, the following environmental variables can be set:
``NOSTDOUTREDIR`` ``NOSTDERRREDIR``.

## Automated builds

The [Docker image](https://hub.docker.com/r/tklx/nginx/) is built, tested and pushed by [CircleCI](https://circleci.com/gh/tklx/nginx) from source hosted on [GitHub](https://github.com/tklx/nginx).

* Tag: ``x.y.z`` refers to a [release](https://github.com/tklx/nginx/releases) (recommended).
* Tag: ``latest`` refers to the master branch.

## Status

Currently on major version zero (0.y.z). Per [Semantic Versioning][semver],
major version zero is for initial development, and should not be considered
stable. Anything may change at any time.

## Issue Tracker

TKLX uses a central [issue tracker][tracker] on GitHub for reporting and
tracking of bugs, issues and feature requests.

[base]: https://github.com/tklx/base
[tini]: https://github.com/krallin/tini
[nginx-ssl]: https://nginx.org/en/docs/http/configuring_https_servers.html
[nginx-ssl-termination]: https://www.nginx.com/resources/admin-guide/nginx-ssl-termination/
[semver]: http://semver.org/
[tracker]: https://github.com/tklx/tracker/issues
