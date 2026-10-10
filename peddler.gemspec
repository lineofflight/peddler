# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
require "peddler/version"

# This is the source gem. Platform gems are derived from it by rake-compiler
# (`rake native:<platform> gem`, see rakelib/gem.rake): it drops the Rust
# sources and adds the compiled extensions under lib/peddler/<ruby minor>/.
Gem::Specification.new do |gem|
  gem.name     = "peddler"
  gem.version  = Peddler::VERSION
  gem.summary  = "Amazon Selling Partner API (SP-API) in Ruby"
  gem.authors  = ["Hakan Ensari"]
  gem.email    = ["hakanensari@gmail.com"]
  gem.homepage = "https://github.com/lineofflight/peddler"
  gem.license  = "MIT"

  ruby_files = Dir["lib/peddler/**/*.rb", "lib/peddler/**/*.json", "sig/peddler/**/*.rbs",
    "sig/inline/**/*.rbs"]
    .append("lib/peddler.rb", "LICENSE", "README.md", "CHANGELOG.md", "UPGRADING.md")
  # The Cargo workspace closure the extension needs to resolve and build with --locked.
  rust_files = ["Cargo.toml", "Cargo.lock"] +
    ["crates/peddler/Cargo.toml", "crates/peddler/README.md", "crates/peddler-ruby/Cargo.toml",
      "crates/peddler-ruby/build.rs", "crates/peddler-ruby/extconf.rb"] +
    Dir["crates/{peddler,peddler-ruby}/src/**/*.rs"]
  gem.files = ruby_files + rust_files
  gem.extensions = ["crates/peddler-ruby/extconf.rb"]

  gem.required_ruby_version = ">= 3.3"
  gem.required_rubygems_version = ">= 3.5.0"

  gem.add_dependency("bigdecimal", ">= 3.1", "< 5")
  gem.add_dependency("rb_sys", "~> 0.9.130")
  gem.add_dependency("structure", "~> 4.2")
  gem.add_dependency("zeitwerk", "~> 2.6")

  # The site that .github/workflows/build-docs.yml deploys. Without this RubyGems links to rubydoc.info, which
  # builds with YARD and knows nothing of the inline RBS.
  gem.metadata["documentation_uri"] = "https://lineofflight.github.io/peddler/"
  gem.metadata["rubygems_mfa_required"] = "true"
end
