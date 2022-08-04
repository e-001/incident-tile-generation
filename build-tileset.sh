#! /bin/bash

set -e

cd $(dirname "$0") || exit 1
mkdir -p data

./scripts/01-gql-fetch.sh
./scripts/02-gql-to-geojson.sh
./scripts/03-geojson-to-mbtiles.sh
