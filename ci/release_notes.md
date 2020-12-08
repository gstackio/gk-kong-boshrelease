### Improvements

- Fix potential issue with `post-start` Kong admin API setup, that could break whenever some plugins (other than the one for admin API) were configured in the Kong database.
- Allow configuring the headers that Kong should inject in client responses. Now if for security reasons you're unhappy with Kong exposing its version to the wild, you can shut it off, setting an empty array for the `proxy.injected_headers` property.
- Migrate the Admin API Basic-Auth plugin registration to use a standard, fixed UUID, that can possibly be customized for the very rare cases where it would conflict with some pre-existing database record, just as we do with other Admin API resources that are managed by this BOSH release.
- Add native support for BOSH DNS health checks using Kong `/status` endpoint (when the Kong admin API is enabled), or a TCP connection check on some Kong proxy port. Now BOSH DNS queries properly return healthy instances.
- Smoke tests better support the separated control-plane mode, as implemented by the `separate-control-and-data-planes.yml` ops file.
- Compiled releases are now built on top of the latest stemcell family v621.x
- Created bump automation with a dedicated Concourse pipeline, for using latest BPM and Postgres in the standard deployment manifest.
- Bumped BPM to v1.1.9 in the standard deployment manifest.
- Bumped the Postgres release to v42 in standard deployment manifest.
- Use new BOSH DNS feature to feed the BOSH DNS alias for Kong into the generated TLS certificate alternative names.


### Breaking changes

- Now the Kong admin API must be exposed on a specific hostname (instead of being exposed on _all_ hosts). The default hostname used is the [default BOSH DNS address](https://bosh.io/docs/dns/#links) (with [`q-s0` query](https://bosh.io/docs/dns/#constructing-queries)) of the Kong admin API instance group.
- Deployment manifest now require new BOSH links:
  - New BOSH link in `kong` job, named `kong-admin`.
  - BOSH link in `konga` job has been renamed `kong-admin`.
  - Smoke-tests now require both `kong-proxy` and `kong-admin` BOSH links.


### Caveats

- The compilation process of this Release requires an access to the Internet. Kong CE dependencies, which are luarocks packages, are downloaded from [loarocks.org](https://luarocks.org). So, your compilation VMs will access the Internet.
- Smoke tests require an access to the Internet.
- When setting the `proxy.injected_headers` property to an empty array `[]`, the Kong admin API still returns a `Server:` header. This header is not injected by the proxy, but served by the admin API and then re-transmitted through the proxy.
