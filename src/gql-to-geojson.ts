import { writeFileSync } from "fs"

const raw = require('../data/output.json');
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

writeFileSync("data/incidents.geojson", JSON.stringify(incidentFeatureCollection, null, 2));
writeFileSync("data/library_items.geojson", JSON.stringify(libraryItemFeatureCollction, null, 2));
