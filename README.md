# tklx/nginx - web server

## Features

- Based on the super slim [tklx/base][base] (Debian GNU/Linux).
- Nginx installed directly from Debian.
- Uses [tini][tini] for zombie reaping and signal forwarding.
- Includes ``VOLUME /var/www`` for easy webroot access.
- Includes ``EXPOSE 80 443``, so standard container linking will make it
  automatically available to the linked containers.

## Usage

### Start a Nginx instance and connect to it from an application

```console
$ docker run --name some-nginx -d tklx/nginx
$ docker run --name some-app --link some-nginx:nginx -d app-that-uses-nginx
```

### Tips

The image comes preconfigured with safe & secure defaults.

## Status

Currently on major version zero (0.y.z). Per [Semantic Versioning][semver],
major version zero is for initial development, and should not be considered
stable. Anything may change at any time.

## Issue Tracker

TKLX uses a central [issue tracker][tracker] on GitHub for reporting and
tracking of bugs, issues and feature requests.

[base]: https://github.com/tklx/base
[tini]: https://github.com/krallin/tini
[semver]: http://semver.org/
[tracker]: https://github.com/tklx/tracker/issues
