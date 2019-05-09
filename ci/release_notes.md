### Features

- Add the [Konga](https://github.com/pantsel/konga) dashboard v0.13.0, with TLS support.
- Add a new `redirect` custom Kong plugin.

### Improvements

- Improved smoke tests.
- Improved Kong config file template, in order to ease future upgrades.
- Potentially harmful newlines are now properly escaped, when injecting values into the Kong config file.
- Now when TLS is disabled, Kong doesn't listen on TLS ports anymore.

### Caveats

- The admin API is exposed on _all_ hosts under the path specified by `admin.service.route_path` (defaulting to `/admin-api`). It can be surprising on some enterprise API host, the `/admin-api` path is actually the Kong admin API.
- The compilation process of this Release requires an access to the Internet. Kong CE dependencies, which are luarocks packages, are downloaded from [loarocks.org](https://luarocks.org). So, your compilation VMs will access the Internet.
- Smoke tests require an access to the Internet.
