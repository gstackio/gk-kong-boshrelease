#!/usr/bin/env bash

set -e

function configure() {
    OPENSSL_VERSION=1.1.1d
    OPENSSL_SHA256=1e3a91bc1f9dfce01af26026f856e064eab4c8ee0a8f457b5ae30b40b8b711f2

    OPENRESTY_VERSION=1.13.6.2
    OPENRESTY_SHA256=946e1958273032db43833982e2cec0766154a9b5cb8e67868944113208ff2942

    OPENRESTY_PATCHES_VERSION=6723044 # master as of 2019-09-16
    OPENRESTY_PATCHES_SHA256=63ec600d82f268b228c380933f08751983082b888012bf444978296f82acec62

    LUAROCKS_VERSION=3.1.3
    LUAROCKS_SHA256=c573435f495aac159e34eaa0a3847172a2298eb6295fcdc35d565f9f9b990513

    KONG_VERSION=1.0.4
    KONG_SHA256=46575753db5c54e80c0979dd82eadc0a5c544a1e56fe87179fc6f508a0817755


    ONIGURUMA_VERSION=6.9.3
    ONIGURUMA_SHA256=ab5992a76b7ab2185b55f3aacc1b0df81132c947b3d594f82eb0b41cf219725f

    JQ_VERSION=1.6
    JQ_SHA256=5de8c8e29aaa3fb9cc6b47bb27299f271354ebb72514e3accadc7d38b5bbaa72


    NODEJS_VERSION=10.16.3
    NODEJS_SHA256=db5a5e03a815b84a1266a4b48bb6a6d887175705f84fd2472f0d28e5e305a1f8

    KONGA_VERSION=0.14.4
    KONGA_SHA256=699ad870e1e110297cac6ded216a9a6d3594d0a19e6dd48804df52f50677a87b
}

function main() {
    SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
    readonly SCRIPT_DIR
    RELEASE_DIR=$(cd "${SCRIPT_DIR}/.." && pwd)
    readonly RELEASE_DIR

    configure

    mkdir -p "${RELEASE_DIR}/tmp/blobs"
    pushd "${RELEASE_DIR}/tmp/blobs" > /dev/null

        local blob_file
        set -x

        blob_file="openssl-${OPENSSL_VERSION}.tar.gz"
        add_blob "openssl" "${blob_file}" "openssl/${blob_file}"

        blob_file="openresty-${OPENRESTY_VERSION}.tar.gz"
        add_blob "openresty" "${blob_file}" "openresty/${blob_file}"

        blob_file="openresty-patches-${OPENRESTY_PATCHES_VERSION}.tar.gz"
        add_blob "openresty_patches" "${blob_file}" "openresty/${blob_file}"

        blob_file="luarocks-${LUAROCKS_VERSION}.tar.gz"
        add_blob "luarocks" "${blob_file}" "luarocks/${blob_file}"

        blob_file="kong-${KONG_VERSION}.tar.gz"
        add_blob "kong" "${blob_file}" "kong/${blob_file}"


        blob_file="onig-${ONIGURUMA_VERSION}.tar.gz"
        add_blob "oniguruma" "${blob_file}" "jq/${blob_file}"

        blob_file="jq-${JQ_VERSION}.tar.gz"
        add_blob "jq" "${blob_file}" "jq/${blob_file}"


        blob_file="node-v${NODEJS_VERSION}.tar.gz"
        add_blob "nodejs" "${blob_file}" "nodejs/${blob_file}"

        blob_file="konga-${KONGA_VERSION}.tar.gz"
        add_blob "konga" "${blob_file}" "konga/${blob_file}"

    popd > /dev/null
}

function add_blob() {
    local blob_name=$1
    local blob_file=$2
    local blob_path=$3

    if [[ ! -f "${blob_file}" ]]; then
        "download_${blob_name}"
    fi
    bosh add-blob --dir="${RELEASE_DIR}" "${blob_file}" "${blob_path}"
}

function download_openssl() {
    curl -fsSL "https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz" \
        -o "openssl-${OPENSSL_VERSION}.tar.gz"
    shasum -a 256 --check <<< "${OPENSSL_SHA256}  openssl-${OPENSSL_VERSION}.tar.gz"
}

function download_openresty() {
    curl -fsSL "https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz" \
        -o "openresty-${OPENRESTY_VERSION}.tar.gz"
    shasum -a 256 --check <<< "${OPENRESTY_SHA256}  openresty-${OPENRESTY_VERSION}.tar.gz"
}

function download_openresty_patches() {
    curl -fsSL "https://github.com/Kong/openresty-patches/archive/${OPENRESTY_PATCHES_VERSION}.tar.gz" \
        -o "openresty-patches-${OPENRESTY_PATCHES_VERSION}.tar.gz"
    shasum -a 256 --check <<< "${OPENRESTY_PATCHES_SHA256}  openresty-patches-${OPENRESTY_PATCHES_VERSION}.tar.gz"
}

function download_luarocks() {
    curl -fsSL "http://luarocks.github.io/luarocks/releases/luarocks-${LUAROCKS_VERSION}.tar.gz" \
        -o "luarocks-${LUAROCKS_VERSION}.tar.gz"
    shasum -a 256 --check <<< "${LUAROCKS_SHA256}  luarocks-${LUAROCKS_VERSION}.tar.gz"
}

function download_kong() {
    curl -fsSL "https://github.com/Kong/kong/archive/${KONG_VERSION}.tar.gz" \
        -o "kong-${KONG_VERSION}.tar.gz"
    shasum -a 256 --check <<< "${KONG_SHA256}  kong-${KONG_VERSION}.tar.gz"
}

function download_oniguruma() {
    curl -fsSL "https://github.com/kkos/oniguruma/releases/download/v${ONIGURUMA_VERSION}/onig-${ONIGURUMA_VERSION}.tar.gz" \
        -o "onig-${ONIGURUMA_VERSION}.tar.gz"
    shasum -a 256 --check <<< "${ONIGURUMA_SHA256}  onig-${ONIGURUMA_VERSION}.tar.gz"
}

function download_jq() {
    curl -fsSL "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-${JQ_VERSION}.tar.gz" \
        -o "jq-${JQ_VERSION}.tar.gz"
    shasum -a 256 --check <<< "${JQ_SHA256}  jq-${JQ_VERSION}.tar.gz"
}

function download_nodejs() {
    curl -fsSL "https://nodejs.org/download/release/latest-dubnium/node-v${NODEJS_VERSION}.tar.gz" \
        -o "node-v${NODEJS_VERSION}.tar.gz"
    shasum -a 256 --check <<< "${NODEJS_SHA256}  node-v${NODEJS_VERSION}.tar.gz"
}

function download_konga() {
    curl -fsSL "https://github.com/pantsel/konga/archive/${KONGA_VERSION}.tar.gz" \
        -o "konga-${KONGA_VERSION}.tar.gz"
    shasum -a 256 --check <<< "${KONGA_SHA256}  konga-${KONGA_VERSION}.tar.gz"
}

main "$@"
