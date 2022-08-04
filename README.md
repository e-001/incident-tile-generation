# Incident Clustered Tileset Generator

In the interest of client performance, we generate a zoomable tileset with clustering pre-computed.

## Dependencies
- Install node packages with `yarn install`.
- Install [tippecanoe](https://github.com/mapbox/tippecanoe#installation) `brew install tippecanoe`.
- Set the `GRAPHQL_TOKEN` env variable to match the admin secret.

## Running
The `build-tileset.sh` script in the project root performs the necessary operations.
1. Downloads latest incident survey features via GQL.
2. Converts the features to a FeatureCollection.
3. Generates an MBTile file from the passed collection.

See the component scripts in the `scripts/` dir for implementation.
