// Conversion stays with swagger2openapi; Rust selects and normalizes operations.
const fs = require('node:fs');
const converter = require('swagger2openapi');
const source = JSON.parse(fs.readFileSync(0, 'utf8'));
// Only parameter objects are normalized; examples and schema property maps stay intact.
function normalizeParameter(parameter) {
  if (parameter && parameter.type !== 'array') delete parameter.collectionFormat;
}
for (const parameter of Object.values(source.parameters || {})) normalizeParameter(parameter);
for (const item of Object.values(source.paths || {})) {
  for (const parameter of item.parameters || []) normalizeParameter(parameter);
  for (const method of ['get', 'put', 'post', 'delete', 'options', 'head', 'patch']) {
    for (const parameter of item[method]?.parameters || []) normalizeParameter(parameter);
  }
}
converter.convertObj(source, {}, (error, result) => {
  if (error) {
    console.error(error.message);
    process.exitCode = 1;
  } else {
    process.stdout.write(JSON.stringify(result.openapi));
  }
});
