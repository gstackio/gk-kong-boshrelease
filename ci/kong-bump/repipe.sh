#!/usr/bin/env bash

set -eo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

pushd "${SCRIPT_DIR}" > /dev/null

(
    set -x
    fly -t "gk" \
        set-pipeline -p "kong-bump" \
        -c "kong-bump-pipeline.yml" \
        -l "../config.yml" -l "../secrets.yml"
)

popd > /dev/null
