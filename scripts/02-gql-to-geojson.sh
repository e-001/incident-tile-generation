#! /bin/bash

set -e

cd $(dirname "$0")/.. || exit 1

# Convert GQL response to GeoJSON FeatureCollection
echo "Converting incident_survey feature objects to GeoJSON FeatureCollection..."
node -r ts-node/register src/gql-to-geojson.ts
