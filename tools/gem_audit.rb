#!/usr/bin/env ruby
# frozen_string_literal: true

# Content audit for built peddler gems: ruby tools/gem_audit.rb pkg/*.gem
# Reads the file list from the gem's data archive, not just its metadata.
require "rubygems/package"

FORBIDDEN = [
  %r{(\A|/)\.git(/|\z)}, %r{(\A|/)target/}, %r{(\A|/)tmp/}, /selling-partner-api-models/, %r{(\A|/)cassettes?/},
  %r{(\A|/)node_modules/}, %r{(\A|/)\.env}, %r{(\A|/)credentials(\.|/|\z)}, %r{test/config\.json\z},
  %r{\A\.superpowers/}, %r{\Atools/}, %r{\Alib/generator}, %r{\Acrates/peddler-codegen/}, /\.(pem|key)\z/
].freeze
CLOSURE = ["Cargo.lock", "crates/peddler-ruby/extconf.rb"].freeze
RUST = %r{\A(Cargo\.|crates/)}
BINARY = %r{\Alib/peddler/(\d+\.\d+/)?peddler_native\.(bundle|so)\z}

abort("usage: ruby tools/gem_audit.rb pkg/peddler-*.gem") if ARGV.empty?

problems = ARGV.flat_map do |path|
  spec = Gem::Package.new(path).spec
  files = []
  Gem::Package.new(path).contents.each { |file| files << file }
  binaries = files.grep(BINARY)
  found = files.flat_map { |file| FORBIDDEN.select { |pattern| file.match?(pattern) }.map { "#{path}: forbidden #{file}" } }
  found << "#{path}: license is not MIT" unless spec.licenses == ["MIT"] && files.include?("LICENSE")
  if spec.platform == Gem::Platform::RUBY
    found << "#{path}: source gem lacks the Cargo closure" unless (CLOSURE - files).empty?
    found << "#{path}: source gem ships binaries" unless binaries.empty?
  else
    found << "#{path}: platform gem has no binary" if binaries.empty?
    found << "#{path}: Linux gem is not -gnu (#{spec.platform})" if spec.platform.os == "linux" && spec.platform.version != "gnu"
    found << "#{path}: platform gem ships Rust sources" if files.any? { |file| file.match?(RUST) }
    found << "#{path}: platform gem declares rb_sys" if spec.runtime_dependencies.any? { |dep| dep.name == "rb_sys" }
    found << "#{path}: platform gem is not bound to a Ruby range" unless spec.required_ruby_version.to_s.include?("<")
    versions = binaries.filter_map { |file| file[%r{lib/peddler/(\d+\.\d+)/}, 1] }
    bound = spec.required_ruby_version
    found << "#{path}: binary for a Ruby the gem does not allow" if versions.any? { |v| !bound.satisfied_by?(Gem::Version.new("#{v}.0")) }
  end
  found
end
problems.each { |problem| warn(problem) }
abort("audit failed") unless problems.empty?
puts("audit ok: #{ARGV.join(", ")}")
