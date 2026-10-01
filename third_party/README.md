# Vendored Progenitor implementation

`progenitor-impl/` is the crates.io `progenitor-impl` 0.15.0 package, published
from https://github.com/oxidecomputer/progenitor at revision
`76a3b70f0eb11e044b52ee15bd07bcc370c8adb5` (see `.cargo_vcs_info.json`).
Upstream source and package notices are preserved. The package is licensed under
MPL-2.0; `LICENSE` is copied from the upstream repository at that revision because
the published package omits the license file.

The sole source change is `raw-response.patch` (+3/-1 lines): operation extension
`x-peddler-raw-response: true` opts declared responses into the existing raw
`ByteStream` response mode. Statuses, headers and original body bytes reach the
shared Peddler collector without JSON parsing. Other operations retain upstream
behavior. This is a local build-time Cargo patch, not a remote fork or publication.
The crate is excluded from workspace membership, formatting and lint checks.
