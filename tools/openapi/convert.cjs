// Conversion stays with swagger2openapi; Rust selects and normalizes operations.
const fs = require('node:fs');
const converter = require('swagger2openapi');
const source = JSON.parse(fs.readFileSync(0, 'utf8'));
converter.convertObj(source, {}, (error, result) => {
  if (error) {
    console.error(error.message);
    process.exitCode = 1;
  } else {
    process.stdout.write(JSON.stringify(result.openapi));
  }
});
