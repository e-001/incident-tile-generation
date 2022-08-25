import log from "consola"
import { mkdirSync, writeFileSync } from "fs"

const raw = require('../out/gql/result.json');
const libraryItemFeatures = raw.data.library_item
  .map((s: any) => {
    var geojson = s.incident.feature
    geojson.properties.incident_id = s.incident.id
    geojson.properties.library_item_id = s.id
    geojson.properties.title = s.title
    geojson.properties.cover_photo = s.cover_photo
    return geojson
  })

const incidentFeatures = raw.data.incident_survey
  .filter((s: any) => s.feature !== null)
  .map((s: any) => {
  var geojson = s.feature
  geojson.properties.year = s.incident.year
  return geojson
  })

const incidentFeatureCollection = {
  type: 'FeatureCollection',
  features: incidentFeatures
}

const libraryItemFeatureCollction = {
  type: 'FeatureCollection',
  features: libraryItemFeatures
}

mkdirSync('./out/geojson', {recursive: true})
const incidentOutputPath = "./out/geojson/incidents.geojson"
const libraryOutputPath = "./out/geojson/library.geojson"
writeFileSync(incidentOutputPath, JSON.stringify(incidentFeatureCollection, null, 2));
log.info(`Wrote ${incidentFeatures.length} incident features to ${incidentOutputPath}`);

writeFileSync(libraryOutputPath, JSON.stringify(libraryItemFeatureCollction, null, 2));
log.info(`Wrote ${libraryItemFeatures.length} library item features to ${libraryOutputPath}`);
