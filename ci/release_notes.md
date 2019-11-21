### Improvements

- Bumped to Kong v1.0.4 ([changelog](https://github.com/Kong/kong/blob/1.0.4/CHANGELOG.md#104))

- The custom `redirect` plugin has been rewritted to conform to the Kong v1.x.x Plugin Development Kit. When the plugin is installed, it will be covered by smoke tests.

- The `redirect` plugin now restricts the `status_code` config field to the `300..399` range only.

- The `redirect` plugin now provides default messages when both the `message` and `body` config fields are left unspecified. (Such responses appear as a JSON payload, in the `3xx` response body.)

- Removed stale Konga blob, leading to 2MB smaller release `.tgz` file.

- Bumped BPM to v1.1.5 in the standard deployment manifest.

- Bumped stemcell family to v621.x for compiled releases.


### Breaking Changes

- Kong v1.0.4 has a number of breaking changes, compared to v0.15.0. See the [v1.0.0 changelog](https://github.com/Kong/kong/blob/1.0.4/CHANGELOG.md#100) for more information.

- The `kong.yml` deployment manifest is renamed `gk-kong.yml` to match the BOSH Release name


### Caveats

- The admin API is exposed on _all_ hosts under the path specified by `admin.service.route_path` (defaulting to `/admin-api`). It can be surprising on some enterprise API host, the `/admin-api` path is actually the Kong admin API.
- The compilation process of this Release requires an access to the Internet. Kong CE dependencies, which are luarocks packages, are downloaded from [loarocks.org](https://luarocks.org). So, your compilation VMs will access the Internet.
- Smoke tests require an access to the Internet.
