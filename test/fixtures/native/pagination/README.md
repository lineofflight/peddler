# Pagination fixtures

`cases.json` holds synthetic page sequences replayed by both the Rust stream
(`crates/peddler/tests/pagination.rs`) and the Ruby enumerator
(`test_native/pagination_test.rb`) against loopback servers. Each case names a
generated mapping or gives an explicit one, the caller arguments, scripted
responses, the exact requests expected (path, sorted query pairs and body), the
yielded statuses and an optional final pagination error. Tokens and identifiers
are dummy values; bodies marked SECRET must never appear in an error.
