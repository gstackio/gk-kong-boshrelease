### Improvements

- Improved smoke tests, now covering a new Route+Service test case.
- Bumped the Postgres release to v37 in default deployment manifest.

### Caveats

- The admin API is exposed on _all_ hosts under the path specified by `admin.service.route_path` (defaulting to `/admin-api`). It can be surprising on some enterprise API host, the `/admin-api` path is actually the Kong admin API.
- The compilation process of this Release requires an access to the Internet. Kong CE dependencies, which are luarocks packages, are downloaded from [loarocks.org](https://luarocks.org). So, your compilation VMs will access the Internet.
- Smoke tests require an access to the Internet.
