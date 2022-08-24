#!/bin/bash

set -ex

cd "$(dirname "$0")" || exit 1

mbview ./out/mbtiles/{cluster.mbtiles,library.mbtiles}
