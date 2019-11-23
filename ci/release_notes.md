### Improvements

- Add native support for BOSH DNS health checks using Kong `/status` endpoint (when the Kong admin API is enabled), or a TCP connection check on some Kong proxy port. Now BOSH DNS queries properly return healthy instances.

- Smoke tests better support the separated control-plane mode, as implemented by the `separate-control-and-data-planes.yml` ops file.


### Caveats

- The admin API is exposed on _all_ hosts under the path specified by `admin.service.route_path` (defaulting to `/admin-api`). It can be surprising on some enterprise API host, the `/admin-api` path is actually the Kong admin API.
- The compilation process of this Release requires an access to the Internet. Kong CE dependencies, which are luarocks packages, are downloaded from [loarocks.org](https://luarocks.org). So, your compilation VMs will access the Internet.
- Smoke tests require an access to the Internet.
