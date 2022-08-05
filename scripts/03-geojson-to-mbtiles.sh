#! /bin/bash

set -e

cd $(dirname "$0")/.. || exit 1

# Generate MBTile tileset from GeoJSON
echo "Generating MBTile tileset from GeoJSON..."

tippecanoe -f -r1 --cluster-distance 30 -Z0 -z8 --coalesce \
    -o data/lowzoom.mbtiles data/incidents.geojson
# Keep incident_id intact above z8 for cluster expansion with accumulate-attribute store concat'd incident_ids
tippecanoe -f -r1 --cluster-distance 30 -Z8 -z15 --coalesce --accumulate-attribute=incident_id:comma \
    -o data/highzoom.mbtiles data/incidents.geojson
# Join them for upload
tile-join -f -o data/incidents.mbtiles data/lowzoom.mbtiles data/highzoom.mbtiles
