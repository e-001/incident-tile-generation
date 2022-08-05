#! /bin/bash

set -e

cd $(dirname "$0")/.. || exit 1

# Generate MBTile tileset from GeoJSON
echo "Generating MBTile tileset from GeoJSON..."

tippecanoe -f -r1 --cluster-distance 30 -Z0 -z8 --coalesce \
    -x year \
    -o data/lowzoom.mbtiles data/incidents.geojson
# Keep incident_id intact above z8 for cluster expansion with accumulate-attribute store concat'd incident_ids
tippecanoe -f -r1 --cluster-distance 30 -Z8 -z15 --coalesce --accumulate-attribute=incident_id:comma \
    -x year \
    -o data/highzoom.mbtiles data/incidents.geojson
# Join them for upload
tile-join -R incidents:cluster -f -o data/cluster.mbtiles data/lowzoom.mbtiles data/highzoom.mbtiles

tippecanoe -f -zg --coalesce --drop-densest-as-needed \
    -o data/nocluster.mbtiles data/incidents.geojson
