#! /bin/bash

set -e

cd $(dirname "$0")/.. || exit 1

# Download surveys using graphqurl
echo "Downloading incident_survey feature objects... this may take a while..."
graphqurl https://enigma.hasura.app/v1/graphql \
    -H "x-hasura-admin-secret: ${GRAPHQL_TOKEN}" \
    -q "query FeatureCollection(\$where: incident_survey_bool_exp, \$limit: Int) @cached { incident_survey(where: \$where, limit: \$limit) { feature incident { year } } }" \
    > data/surveys.json
