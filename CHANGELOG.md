## 0.1.0

Initial development release.

#### Notes

- Based off [tklx/base:0.1.0](https://github.com/tklx/base/releases/tag/0.1.0).
- Nginx installed directly from Debian.
- Uses [tini][tini] for zombie reaping and signal forwarding.
- Includes ``VOLUME /var/www`` for easy webroot access.
- Includes ``VOLUME /etc/nginx`` for easy config access.
- Includes ``VOLUME /etc/ssl`` for SSL certificate customization.
- Includes ``EXPOSE 80 443``, so standard container linking will make it
  automatically available to the linked containers.
- Basic bats testing suite.

