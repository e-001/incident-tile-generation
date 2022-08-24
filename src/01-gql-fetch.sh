#! /bin/bash

set -e

cd "$(dirname "$0")"/.. || exit 1

OUT_DIR=out/gql
GQL_RESPONSE=${OUT_DIR}/result.json
mkdir -p "$OUT_DIR"

# Download surveys using graphqurl
echo "Downloading incident_survey feature objects... this may take a while..."

# Load query from file
QUERY=$(cat ./src/FeatureCollection.graphql)

graphqurl https://enigma.hasura.app/v1/graphql \
    -H "x-hasura-admin-secret: ${GRAPHQL_TOKEN}" \
    -q "${QUERY}" \
    > ${GQL_RESPONSE}

COUNT=$(cat ${GQL_RESPONSE} | jq '.data.incident_survey | length')

# If there are no features, exit
if [ "$COUNT" -eq 0 ]; then
    echo "No features found. Exiting."
    exit 1
else
    echo "Found $COUNT features."
fi
