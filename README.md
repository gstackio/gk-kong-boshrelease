# Kong BOSH Release

This BOSH Release is the fastest way to get up and running with a cluster of
[Kong CE][kong_ce] API Gateway when you're using [BOSH][bosh_io].

You are provided here with all the necessary binaries, configuration
templates, and startup scripts for _converging_ Kong clusters (i.e. installing
and updating over time) on Ubuntu Xenial nodes. Plus, we also provide here a
standard [deployment manifest][depl_manifest] to help you deploy your first
Kong API Gateway easily.

[bosh_io]: https://bosh.io/
[kong_ce]: https://konghq.com/kong-community-edition/
[depl_manifest]: ./deploy/gk-kong.yml



## Usage

This repository includes base manifests and operator files. They can be used
for initial deployments and subsequently used for updating your deployments.

```
git clone https://github.com/gstackio/gk-kong-boshrelease.git
cd gk-kong-boshrelease/deploy

export BOSH_ENVIRONMENT=<bosh-alias>
export BOSH_DEPLOYMENT=kong
bosh deploy gk-kong.yml --vars-file=default-vars.yml
```

If your BOSH does not have Credhub/Config Server (but it should), then
remember to use `--vars-store` to allow generation of passwords and
certificates into a local YAML file.



### Update

When new versions of `gk-kong-boshrelease` are released, the
`deploy/gk-kong.yml` file is updated. This means you can easily `git pull` and
`bosh deploy` to upgrade.

```
export BOSH_ENVIRONMENT=<bosh-alias>
export BOSH_DEPLOYMENT=kong
cd gk-kong-boshrelease/deploy
git pull
bosh deploy gk-kong.yml --vars-file=default-vars.yml
```



### Clustering

Horizontal scaling works out of the box, with a mere updating of the
[`instances:` property][instances_prop] in the deployment manifest. Kong nodes
will synchronize their state on the shared PostgreSQL database, with
[some caching implemented][db_update_frequency_doc].

You can update the [`db_update_frequency_in_sec`][db_update_frequency_prop]
value (default is 5 seconds) to suit your needs.
The [customize-db-update-freqency.yml][db_update_freqency_ops_file] ops file
is provided here to help you in this.

Please note though, that the default deployment manifest doesn't provide you
with any High Availability (HA) or horizontal scaling solution for the
PostgreSQL database. If you stick to it, this will still be a single point of
failure.

If you are concerned with HA design for Kong, we encourage you to have a look
at the [Cassandra BOSH Release][cassandra_release] that we're also
contributing to.

We can also mention here the [CockroachDB BOSH Release][cockroachdb_release]
(CockroachDB is a PostgreSQL-compatible database that is designed to be
clustered for High Availability), that has a working BOSH deployment
[in our Easy Foundry distribution][cockroachdb_gbe_spec].

[instances_prop]: ./deploy/gk-kong.yml#L6
[db_update_frequency_doc]: https://docs.konghq.com/0.14.x/clustering/#1-db_update_frequency-default-5s
[db_update_frequency_prop]: ./jobs/kong/spec#L132-L144
[db_update_freqency_ops_file]: ./deploy/operators/customize-db-update-freqency.yml
[cassandra_release]: https://github.com/orange-cloudfoundry/cassandra-boshrelease
[cockroachdb_release]: https://github.com/cppforlife/cockroachdb-release
[cockroachdb_gbe_spec]: https://github.com/gstackio/gstack-bosh-environment/blob/master/deployments/cockroachdb/conf/spec.yml



## Design notes

This is a reboot verion of the [Kong CE BOSH Release][kong_ce_release] which
in turn was a fork of the community's [Kong release][kong_release].

As [explained in the fork][design_notes], we have abandoned the non-hermetic,
non-reproducible, and thus non-production-ready Docker design.

[kong_ce_release]: https://github.com/gstackio/kong-ce-boshrelease
[kong_release]: https://github.com/cloudfoundry-community/kong-boshrelease
[design_notes]: https://github.com/gstackio/kong-ce-boshrelease#design-notes



## Contributing

Pull requests are welcome! See in our [open issues](./issues) the possible
improvements that you could contribute to. They are prioritized by
[milestones](./milestones) that each expose a specific goal.

Whenever you need to update the blobs, you'll find in the
`scripts/add-blobs.sh` script the way we have been fetching them. This helps
in fetching any newer versions of the softwares, and brings more tracability
as to where the blobs hav been downloaded from.



## Author and License

Copyright © 2018-2019, Benjamin Gandon, Gstack

Like the rest of BOSH, this Gstack Kong BOSH Release is released under the
terms of the [Apache 2.0 license](http://www.apache.org/licenses/LICENSE-2.0).
