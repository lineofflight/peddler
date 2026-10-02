# frozen_string_literal: true

# What the Rust generator writes, for the git gate in generate:verify
RUST_GENERATED_PATHS = [
  "lib/peddler/native/apis.rb",
  "sig/peddler/native/apis.rbs",
  "crates/peddler/src/apis",
  "crates/peddler/src/data_kiosk",
  "crates/peddler/src/feeds",
  "crates/peddler/src/notifications",
  "crates/peddler/src/reports",
  "crates/peddler-codegen/operation-inventory.json",
].freeze

namespace :generate do
  namespace :rust do
    desc "Sync pinned specs and verify Ruby/GraphQL and locked Node generation dependencies"
    task :setup do
      require_relative "../lib/generator/specs"
      Generator::Specs.sync(ref: Generator::Specs.pinned_sha)
      sh "bundle", "exec", "ruby", "-e", 'require "graphql"; require "active_support/inflector"'
      sh "npm", "ci", "--prefix", "tools/openapi"
    end

    desc "Check pinned Rust output without rewriting generated files"
    task verify: :setup do
      sh "cargo", "run", "-p", "peddler-codegen", "--locked", "--", "--root", ".", "--check"
    end
  end

  desc "Generate Rust models and wire clients from pinned specs"
  task rust: "rust:setup" do
    sh "cargo", "run", "-p", "peddler-codegen", "--locked", "--", "--root", "."
  end
end
