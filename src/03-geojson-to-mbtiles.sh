#! /bin/bash

set -e

cd "$(dirname "$0")"/.. || exit 1

SRC_DIR=out/geojson
OUT_DIR=out/mbtiles
mkdir -p "$OUT_DIR"

# Generate MBTile tileset from GeoJSON
echo "Generating MBTile tileset from GeoJSON..."
echo
echo "ℹ Writing incident mbtiles without accumulated ids for low zooms to ${OUT_DIR}/lowzoom.mbtiles..."
tippecanoe -f -r1 --cluster-distance 30 -Z0 -z8 --coalesce \
    -x year \
    -o ${OUT_DIR}/lowzoom.mbtiles ${SRC_DIR}/incident.geojson
# Keep incident_id intact above z8 for cluster expansion with accumulate-attribute store concat'd incident_ids
echo
echo "ℹ Writing incident mbtiles with accumulated ids for high zooms to ${OUT_DIR}/highzoom.mbtiles..."
tippecanoe -f -r1 --cluster-distance 30 -Z8 -z15 --coalesce --accumulate-attribute=incident_id:comma \
    -x year \
    -o ${OUT_DIR}/highzoom.mbtiles ${SRC_DIR}/incident.geojson
# Join them for upload
echo
echo "ℹ Merging incident mbtiles for high and low zooms to ${OUT_DIR}/cluster.mbtiles..."
tile-join -R incidents:cluster -f -o ${OUT_DIR}/cluster.mbtiles ${OUT_DIR}/lowzoom.mbtiles ${OUT_DIR}/highzoom.mbtiles

echo
echo "ℹ Writing incident mbtiles with no clustering to ${OUT_DIR}/nocluster.mbtiles..."
tippecanoe -f -zg --coalesce --drop-densest-as-needed \
    -o ${OUT_DIR}/nocluster.mbtiles ${SRC_DIR}/incident.geojson

echo
echo "ℹ Writing mbtiles for library items to ${OUT_DIR}/library.mbtiles..."
tippecanoe -f -zg -o ${OUT_DIR}/library.mbtiles ${SRC_DIR}/library.geojson
