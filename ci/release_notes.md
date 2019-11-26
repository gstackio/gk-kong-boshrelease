### Improvements

- Fix potential issue with `post-start` Kong admin API setup, that could break whenever some plugins (other than the one for admin API) were configured in the Kong database.
- Allow configuring the headers that Kong should inject in client responses. Now if for security reasons you're unhappy with Kong exposing its version to the wild, you can shut it off, setting an empty array for the `proxy.injected_headers` property.
- Migrate the Admin API Basic-Auth plugin registration to use a standard, fixed UUID, that can possibly be customized for the very rare cases where it would conflict with some pre-existing database record, just as we do with other Admin API resources that are managed by this BOSH release.
- Add native support for BOSH DNS health checks using Kong `/status` endpoint (when the Kong admin API is enabled), or a TCP connection check on some Kong proxy port. Now BOSH DNS queries properly return healthy instances.
- Smoke tests better support the separated control-plane mode, as implemented by the `separate-control-and-data-planes.yml` ops file.
- Compiled releases are now built on top of the latest stemcell family v621.x


### Caveats

- For some unknown reason, when setting the `proxy.injected_headers` property to an empty array `[]`, the `Server:` header is still injected by Kong. This might be an issue in the upstream Kong project.
- The admin API is exposed on _all_ hosts under the path specified by `admin.service.route_path` (defaulting to `/admin-api`). It can be surprising on some enterprise API host, the `/admin-api` path is actually the Kong admin API.
- The compilation process of this Release requires an access to the Internet. Kong CE dependencies, which are luarocks packages, are downloaded from [loarocks.org](https://luarocks.org). So, your compilation VMs will access the Internet.
- Smoke tests require an access to the Internet.
