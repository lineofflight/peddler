# frozen_string_literal: true

# Builds the peddler_native extension from source. Used by `gem install peddler`
# (source gem) and requires a Rust toolchain and Ruby headers. Platform gems
# ship prebuilt extensions and never run this file.
require "mkmf"
require "rb_sys/mkmf"

create_rust_makefile("peddler/peddler_native") do |r|
  # Resolve against the shipped Cargo.lock only.
  r.extra_cargo_args += ["--locked"]
end
