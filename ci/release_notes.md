### Improvements

- Improved smoke tests, now covering a new Route+Service test case.
- Compiled releases are now built on top of the latest stemcell family v456.x
- Bumped dependencies in default deployment manifest:
  - Postgres release to v39
  - BPM release to v1.1.3
  - os-conf release to v21.0.0

### Caveats

- The admin API is exposed on _all_ hosts under the path specified by `admin.service.route_path` (defaulting to `/admin-api`). It can be surprising on some enterprise API host, the `/admin-api` path is actually the Kong admin API.
- The compilation process of this Release requires an access to the Internet. Kong CE dependencies, which are luarocks packages, are downloaded from [loarocks.org](https://luarocks.org). So, your compilation VMs will access the Internet.
- Smoke tests require an access to the Internet.
