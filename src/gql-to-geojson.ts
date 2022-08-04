import { writeFileSync } from "fs"

const raw = require('../data/surveys.json');
const features = raw.data.incident_survey.map((s: any) => { return s.feature });
const collection = {
  type: 'FeatureCollection',
  features: features
}

writeFileSync("data/incidents.geojson", JSON.stringify(collection, null, 2));
