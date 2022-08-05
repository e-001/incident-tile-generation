import { writeFileSync } from "fs"

const raw = require('../data/surveys.json');
const features = raw.data.incident_survey
  .filter((s: any) => s.feature !== null)
  .map((s: any) => {
  var geojson = s.feature
  geojson.properties.year = s.incident.year
  return geojson
})
const collection = {
  type: 'FeatureCollection',
  features: features
}

writeFileSync("data/incidents.geojson", JSON.stringify(collection, null, 2));
