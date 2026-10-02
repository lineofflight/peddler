const assert = require('node:assert/strict');
const { test } = require('node:test');
const { spawnSync } = require('node:child_process');
const path = require('node:path');

function convert(parameters) {
  const source = { swagger: '2.0', info: { title: 'Test', version: '1' }, paths: {
    '/test': { get: { operationId: 'test', parameters, responses: { '200': { description: 'OK' } } } }
  } };
  const input = JSON.stringify(source);
  const result = spawnSync(process.execPath, [path.join(__dirname, 'convert.cjs')], { input, encoding: 'utf8' });
  assert.equal(result.status, 0, result.stderr);
  assert.equal(JSON.stringify(source), input);
  return JSON.parse(result.stdout).paths['/test'].get.parameters;
}

test('invalid scalar collectionFormat is removed while the declared type survives', () => {
  const parameters = convert([
    { in: 'query', name: 'sortBy', type: 'string', collectionFormat: 'csv' },
    { in: 'query', name: 'count', type: 'integer', format: 'int32', collectionFormat: 'multi' }
  ]);
  assert.equal(parameters[0].schema.type, 'string');
  assert.equal(parameters[1].schema.type, 'integer');
  assert.equal(parameters[1].schema.format, 'int32');
});

test('array csv and multi collection formats retain their serialization', () => {
  const parameters = convert(['csv', 'multi'].map(collectionFormat => ({
    in: 'query', name: collectionFormat, type: 'array', items: { type: 'string' }, collectionFormat
  })));
  assert.equal(parameters[0].schema.type, 'array');
  assert.equal(parameters[0].explode, false);
  assert.equal(parameters[1].schema.type, 'array');
  assert.equal(parameters[1].explode, true);
});
