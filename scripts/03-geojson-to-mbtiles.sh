#! /bin/bash

set -e

cd $(dirname "$0")/.. || exit 1

# Generate MBTile tileset from GeoJSON
echo "Generating MBTile tileset from GeoJSON..."
tippecanoe -f -zg -o data/out.mbtiles --drop-densest-as-needed data/incidents.geojson
