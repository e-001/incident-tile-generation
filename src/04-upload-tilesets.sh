#!/bin/bash

set -e

CLUSTER_TILESET_ID=enigmalabs.c6ko9ir8
NOCLUSTER_TILESET_ID=enigmalabs.93c8pnuy
LIBRARY_TILESET_ID=enigmalabs.9ioxb10o

populate_env_aws_credentials() {
    S3_CREDENTIALS_CLUSTER=$(curl -X POST "https://api.mapbox.com/uploads/v1/enigmalabs/credentials?access_token=${MAPBOX_ACCESS_TOKEN}")
    BUCKET=$(echo "$S3_CREDENTIALS_CLUSTER" | jq -r '.bucket')
    KEY=$(echo "$S3_CREDENTIALS_CLUSTER" | jq -r '.key')
    AWS_ACCESS_KEY_ID=$(echo "$S3_CREDENTIALS_CLUSTER" | jq -r '.accessKeyId')
    AWS_SECRET_ACCESS_KEY=$(echo "$S3_CREDENTIALS_CLUSTER" | jq -r '.secretAccessKey')
    AWS_SESSION_TOKEN=$(echo "$S3_CREDENTIALS_CLUSTER" | jq -r '.sessionToken')
    export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN BUCKET KEY
}

upload_and_process() {
    populate_env_aws_credentials
    FILE=$1
    CLUSTER_ID=$2
    CLUSTER_NAME="$3-$(date -u +%Y-%m-%dT%H%M%SZ)"
    aws s3 cp "${FILE}" s3://"$BUCKET"/"$KEY" --region us-east-1

    RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Cache-Control: no-cache" -d "{
      \"url\": \"http://${BUCKET}.s3.amazonaws.com/${KEY}\",
      \"tileset\": \"${CLUSTER_ID}\",
      \"name\": \"${CLUSTER_NAME}\"
    }" "https://api.mapbox.com/uploads/v1/enigmalabs?access_token=$MAPBOX_ACCESS_TOKEN")
    echo "$RESPONSE" | jq .
}

upload_and_process out/mbtiles/nocluster.mbtiles $NOCLUSTER_TILESET_ID nocluster
upload_and_process out/mbtiles/library.mbtiles $LIBRARY_TILESET_ID library
upload_and_process out/mbtiles/cluster.mbtiles $CLUSTER_TILESET_ID cluster
