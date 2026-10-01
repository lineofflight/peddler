# frozen_string_literal: true

namespace :generate do
  namespace :rust do
    desc "Sync pinned specs and install locked generation-only Node dependencies"
    task :setup do
      require_relative "../lib/generator/specs"
      Generator::Specs.sync(ref: Generator::Specs.pinned_sha)
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
