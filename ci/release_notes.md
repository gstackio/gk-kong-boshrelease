### Improvements

- Bumped Kong to version [0.15.0](https://github.com/Kong/kong/releases/tag/0.15.0), compiled with OpenSSL version 1.1.1d
- Bumped Konga UI to version [0.14.4](https://github.com/pantsel/konga/releases/tag/0.14.4)
- Improved smoke tests, now covering a new Route+Service test case.
- Fixed the `admin.basic_auth.password` property being mandatory even when the admin API was disabled. Now on instance groups where the admin API is disabled, this property is no more required.
- Compiled releases are now built on top of the latest stemcell family v456.x
- Bumped dependencies in default deployment manifest:
  - Postgres release to v39
  - BPM release to v1.1.3
  - os-conf release to v21.0.0
- Added a `disable-tls.yml` ops-file, as HTTP-only is a supported use-case, and adde a testflight in CI for this setup.

### Caveats

- The admin API is exposed on _all_ hosts under the path specified by `admin.service.route_path` (defaulting to `/admin-api`). It can be surprising on some enterprise API host, the `/admin-api` path is actually the Kong admin API.
- The compilation process of this Release requires an access to the Internet. Kong CE dependencies, which are luarocks packages, are downloaded from [loarocks.org](https://luarocks.org). So, your compilation VMs will access the Internet.
- Smoke tests require an access to the Internet.
