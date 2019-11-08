### Improvements

- Removed stale Konga blob, leading to 2MB smaller release `.tgz` file.

- Bumped BPM to v1.1.5 in the standard deployment manifest.

- Bumped stemcell family to v621.x for compiled releases.


### Breaking Changes

- The `kong.yml` deployment manifest is renamed `gk-kong.yml` to match the BOSH Release name


### Caveats

- The admin API is exposed on _all_ hosts under the path specified by `admin.service.route_path` (defaulting to `/admin-api`). It can be surprising on some enterprise API host, the `/admin-api` path is actually the Kong admin API.
- The compilation process of this Release requires an access to the Internet. Kong CE dependencies, which are luarocks packages, are downloaded from [loarocks.org](https://luarocks.org). So, your compilation VMs will access the Internet.
- Smoke tests require an access to the Internet.
