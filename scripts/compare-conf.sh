#!/usr/bin/env bash

set -eo pipefail

RELEASE_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
readonly RELEASE_DIR

readonly KONG_VERSION="1.0.4"
readonly DEFAULT_CONFIG="${RELEASE_DIR}/tmp/kong-${KONG_VERSION}-default.conf"

if [[ ! -f "${DEFAULT_CONFIG}" ]]; then
    curl -L \
        --url "https://github.com/Kong/kong/raw/${KONG_VERSION}/kong.conf.default" \
        --output "${DEFAULT_CONFIG}"
fi

colordiff -u \
        "${DEFAULT_CONFIG}" \
        "${RELEASE_DIR}/jobs/kong/templates/config/kong.conf" \
    | less -R
