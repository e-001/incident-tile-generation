#! /bin/bash

set -e

cd "$(dirname "$0")" || exit 1

./src/01-gql-fetch.sh
./src/02-gql-to-geojson.sh
./src/03-geojson-to-mbtiles.sh
