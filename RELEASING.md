# Releasing Peddler

A release is 5 gems and 1 crate: 4 platform gems with the compiled extension, the source gem, and the `peddler` crate. Nothing publishes them for you. `rake release` refuses to run, since it would push the source gem alone.

Steps marked **never run** have not been done once on this repository. Expect the first release to find something.

## 1. Version

The gem and the crate have versions of their own.

- The gem: `lib/peddler/version.rb`.
- The crate, when it changed: `crates/peddler/Cargo.toml`, then `cargo build -p peddler` to bring `Cargo.lock` along. Every build is `--locked`, so a lock that trails the manifest fails.
- `CHANGELOG.md`: rename `[Unreleased]` to the version and its date, such as `## [6.0.0] - 2026-10-07`, and start a new `[Unreleased]`.

Open a pull request with these. It touches `lib/peddler/**`, so the Packaging workflow runs on it and builds every artifact before a tag exists. Merge when it passes.

A prerelease is a version with a letter in it, such as `6.0.0.pre.1`. RubyGems installs one only when asked.

## 2. Tag

```sh
git tag v6.0.0
git push origin v6.0.0
```

The tag's push makes the GitHub Release from the changelog entry (`release` in `.github/workflows/ci.yml`), marked as a prerelease when the version has a letter in it. **Never run** in this form.

## 3. Build the artifacts on the tag

```sh
gh workflow run packaging.yml --ref v6.0.0
gh run watch
```

Packaging builds and tests everything and publishes nothing:

- `crate`: `cargo package`, then a fresh consumer that builds against the packaged crate. Run by hand on macOS only
- `source-gem`: built, audited, installed and smoke tested on Ruby 3.3, 3.4 and 4.0. Run by hand on macOS only
- `cross-gem`: the 4 platform gems, each with a binary for Ruby 3.3, 3.4 and 4.0, built in rb-sys-dock containers and audited. Each carries `THIRD_PARTY_LICENSES.html`, the licenses of the Rust crates in its binary. **Never run**
- `smoke`: each platform gem installed without Rust on its own platform and Ruby, 12 legs. **Never run**

Every job must pass. Then download what it built.

```sh
gh run download <run-id> --dir artifacts
```

`artifacts` holds `peddler-6.0.0-arm64-darwin.gem`, `peddler-6.0.0-x86_64-darwin.gem`, `peddler-6.0.0-aarch64-linux-gnu.gem`, `peddler-6.0.0-x86_64-linux-gnu.gem`, `peddler-6.0.0.gem` and `peddler-0.1.0.crate`, each in a directory of its own.

### The license notices

A platform gem links 105 to 108 Rust crates into its binary, by platform, so it ships their licenses. `tools/third_party_licenses.rb` writes `THIRD_PARTY_LICENSES.html` for a platform from `Cargo.lock`: the crates linked into the extension for that platform, each with its version, its license and the text. It is never edited by hand and never committed. The gem task runs the tool, and `tools/gem_audit.rb` refuses a platform gem without the file.

The tool needs cargo-about, at the version it names:

```sh
cargo install cargo-about --version 0.9.2 --locked
bundle exec rake native gem
```

Build into an empty `pkg`. The gem task does not add a new file to a package directory an earlier build left there, and then fails with `["THIRD_PARTY_LICENSES.html"] are not files`.

`tools/third_party_licenses/about.toml` lists the licenses a crate may have. When a dependency arrives under another one, the tool fails and names the crate, and so does the `cross-gem` job. Read the license. If Peddler can ship under it, add it to `accepted`. If not, replace the crate.

The notices carry each crate's own license file, with its copyright line. cargo-about doesn't take the file of every crate by itself, and would print the standard text of the license in its place. `about.toml` has a `clarify` entry for each of these crates, 5 today, which points at the file the crate ships and holds a checksum of the text. When an update changes such a file, or brings a crate whose file cargo-about doesn't take, the tool fails and names the crate. Find the license files the crate ships under `~/.cargo/registry/src/`, read them, and add or update the entry. The checksum is `shasum -a 256` of the file, or of the part from `start` to `end`.

To move to a newer cargo-about, change `CARGO_ABOUT` in the tool and the version in `packaging.yml` together, and compare the notices before and after.

On the first run, read the glibc version the Linux binaries need and state it in the README's platform table.

```sh
gem unpack artifacts/gem-x86_64-linux/peddler-6.0.0-x86_64-linux-gnu.gem
objdump -T peddler-6.0.0-x86_64-linux-gnu/lib/peddler/4.0/peddler_native.so | grep -o 'GLIBC_[0-9.]*' | sort -Vu | tail -1
```

## 4. Push the gems

Push the 4 platform gems first and the source gem last. While only the source gem is out, Bundler gives it to everyone, and they compile Rust.

```sh
gem push artifacts/gem-arm64-darwin/peddler-6.0.0-arm64-darwin.gem
gem push artifacts/gem-x86_64-darwin/peddler-6.0.0-x86_64-darwin.gem
gem push artifacts/gem-aarch64-linux/peddler-6.0.0-aarch64-linux-gnu.gem
gem push artifacts/gem-x86_64-linux/peddler-6.0.0-x86_64-linux-gnu.gem
gem push artifacts/source-gem/peddler-6.0.0.gem
```

RubyGems asks for a one-time password each time: the gem requires MFA. Pushing a platform gem is **never run**.

A pushed gem can be yanked but its version can't be used again. If a push fails partway, fix what failed and push the rest. Don't rebuild.

## 5. Publish the crate

Skip this when the crate's version didn't change. From a clean checkout of the tag:

```sh
cargo publish -p peddler --locked
```

It packages and builds the crate again before it uploads. The first publish needs `cargo login` and claims the name `peddler` on crates.io. A published version can't be replaced. **Never run**.

## 6. Check

- [rubygems.org/gems/peddler/versions](https://rubygems.org/gems/peddler/versions) lists the version 5 times: once plain and once for each platform.
- On a machine without Rust, `gem install peddler -v 6.0.0` installs a platform gem, and `ruby tools/native_smoke.rb --binary` passes when run from outside the repository.
- On Alpine, or with `gem install peddler -v 6.0.0 --platform ruby`, the source gem compiles and `ruby tools/native_smoke.rb` passes.
- [docs.rs/peddler](https://docs.rs/peddler) built the crate's documentation.
- The GitHub Release exists, with the changelog entry, and is a prerelease only if the version is one.
- The documentation site was deployed. A tag of 3 numbers deploys it, and so does `main`.
