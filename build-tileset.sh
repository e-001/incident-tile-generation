#! /bin/bash

set -e

cd $(dirname "$0") || exit 1
mkdir -p data

# Download surveys using graphqurl
echo "Downloading incident_survey feature objects... this may take a while..."
graphqurl https://enigma.hasura.app/v1/graphql \
    -H "x-hasura-admin-secret: ${GRAPHQL_TOKEN}" \
    -q "query FeatureCollection(\$where: incident_survey_bool_exp, \$limit: Int) @cached { incident_survey(where: \$where, limit: \$limit) { feature } }" \
    > data/surveys.json

# Convert GQL response to GeoJSON FeatureCollection
echo "Converting incident_survey feature objects to GeoJSON FeatureCollection..."
node -r ts-node/register src/gql-to-geojson.ts

# Generate MBTile tileset from GeoJSON
echo "Generating MBTile tileset from GeoJSON..."
tippecanoe -f -zg -o data/out.mbtiles --drop-densest-as-needed data/incidents.geojson
