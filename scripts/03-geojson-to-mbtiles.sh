#! /bin/bash

set -e

cd $(dirname "$0")/.. || exit 1

# Generate MBTile tileset from GeoJSON
echo "Generating MBTile tileset from GeoJSON..."

# -zg: Automatically choose a maxzoom that should be sufficient to clearly distinguish the features and the detail within each feature
# -r1: Do not automatically drop a fraction of points at low zoom levels, since clustering will be used instead
# --accumulate-attribute store concat'd inciden_ids for cluster expansion
# -j { filter } filter out the long list of incident_ids at zooms higher than 9
# --cluster-distance=10: Cluster together features that are closer than about 10 pixels from each other
tippecanoe -f -zg -r1 --cluster-distance 30 --accumulate-attribute=incident_id:comma \
    -j '{ "*": [ "attribute-filter", "incident_id", [ ">=", "$zoom", 9 ] ] }' \
    -o data/out.mbtiles data/incidents.geojson
