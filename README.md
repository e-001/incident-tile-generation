# Incident Clustered Tileset Generator

In the interest of client performance, we generate a zoomable tileset with clustering pre-computed.

## Dependencies
- Install node packages with `yarn install`.
- Install [tippecanoe](https://github.com/mapbox/tippecanoe#installation) `brew install tippecanoe`.
- Set the `GRAPHQL_TOKEN` env variable to match the admin secret.

## Running
The `build-tileset.sh` script in the project root performs the necessary operations. See the component scripts in the `scripts/` dir for implementation.

1. `01-gql-fetch.sh` Download incident survey features via GQL.
2. `02-gql-to-geojson.sh` Converts the features to a FeatureCollection.
3. `03-geojson-to-mbtiles.sh` Generates an MBTile file from the passed collection.


## Preview generated tiles
Use [`mbview`](https://github.com/mapbox/mbview) to preview generated tilesets. To install:
1. `yarn global add mbview` or `npm i -g mbview`
2. `$ export MAPBOX_ACCESS_TOKEN=...`
2. `$ mbview data/out.mbtiles`
