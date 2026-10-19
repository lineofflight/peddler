#!/usr/bin/env ruby
# frozen_string_literal: true

# Content audit for built peddler gems: ruby tools/gem_audit.rb pkg/*.gem
# Reads the file list from the gem's data archive, not just its metadata.
require "rubygems/package"
require "tmpdir"

FORBIDDEN = [
  %r{(\A|/)\.git(/|\z)}, %r{(\A|/)target/}, %r{(\A|/)tmp/}, /selling-partner-api-models/, %r{(\A|/)cassettes?/},
  %r{(\A|/)node_modules/}, %r{(\A|/)\.env}, %r{(\A|/)credentials(\.|/|\z)}, %r{test/config\.json\z},
  %r{\A\.superpowers/}, %r{\Atools/}, %r{\Alib/generator}, %r{\Acrates/peddler-codegen/}, /\.(pem|key)\z/
].freeze
CLOSURE = ["Cargo.lock", "crates/peddler-ruby/extconf.rb"].freeze
RUST = %r{\A(Cargo\.|crates/)}
BINARY = %r{\Alib/peddler/(\d+\.\d+/)?peddler_native\.(bundle|so)\z}
# The libc a Linux gem names. A plain "-linux" gem would also be picked by musl hosts.
LIBCS = ["gnu", "musl"].freeze
# The licenses of the crates linked into a binary. See tools/third_party_licenses.rb.
NOTICES = "THIRD_PARTY_LICENSES.html"
# A line of each MinGW-w64 notice, its runtime's and winpthreads', which the Windows binary links statically
MINGW = ["MinGW-w64 runtime licensing", "Copyright (c) 2011 mingw-w64 project"].freeze

# The Ruby that carries inline RBS. An application's Steep reads a gem's sig/ and nothing else, so each of these
# files ships with the signatures rake rbs:export wrote from it.
INLINE = %r{\Alib/(peddler|peddler/[^/]+|peddler/(?:lwa|native)/.+)\.rb\z}
# The WebMock adapter has no types: WebMock has no signatures.
UNTYPED = ["lib/peddler/webmock.rb"].freeze
SIGNATURES = %r{\Asig/(inline|peddler)/.+\.rbs\z}
# Names the libraries the signatures need. Without it `rbs collection` leaves them out, and an application's check
# of what they type is blind.
MANIFEST = "sig/manifest.yaml"

# A file of a gem, or nil if the gem has none of that name
def content(path, name)
  Dir.mktmpdir do |dir|
    Gem::Package.new(path).extract_files(dir, name)
    file = File.join(dir, name)
    File.read(file, encoding: Encoding::UTF_8) if File.file?(file)
  end
end

abort("usage: ruby tools/gem_audit.rb pkg/peddler-*.gem") if ARGV.empty?

problems = ARGV.flat_map do |path|
  spec = Gem::Package.new(path).spec
  files = []
  Gem::Package.new(path).contents.each { |file| files << file }
  binaries = files.grep(BINARY)
  found = files.flat_map { |file| FORBIDDEN.select { |pattern| file.match?(pattern) }.map { "#{path}: forbidden #{file}" } }
  exported = (files - UNTYPED).grep(INLINE) { "sig/inline/#{Regexp.last_match(1)}.rbs" }
  found.concat((exported - files).map { |file| "#{path}: lacks #{file}" })
  found.concat((files.grep(%r{\Asig/inline/}) - exported).map { |file| "#{path}: #{file} has no Ruby file" })
  found.concat((files.grep(%r{\Asig/}) - [MANIFEST]).grep_v(SIGNATURES).map { |file| "#{path}: forbidden #{file}" })
  found << "#{path}: lacks #{MANIFEST}" unless files.include?(MANIFEST)
  found << "#{path}: lacks the signatures of the typed models" if files.grep(%r{\Asig/peddler/apis/}).empty?
  found << "#{path}: license is not MIT" unless spec.licenses == ["MIT"] && files.include?("LICENSE")
  if spec.platform == Gem::Platform::RUBY
    found << "#{path}: source gem lacks the Cargo closure" unless (CLOSURE - files).empty?
    found << "#{path}: source gem ships binaries" unless binaries.empty?
  else
    found << "#{path}: platform gem has no binary" if binaries.empty?
    notices = content(path, NOTICES)
    found << "#{path}: platform gem lacks #{NOTICES}" unless notices
    found << "#{path}: #{NOTICES} lists no crate" if notices && !notices.include?('<tr class="crate">')
    found << "#{path}: #{NOTICES} is cut short" if notices && !notices.rstrip.end_with?("</body>\n</html>")
    if spec.platform.os == "mingw" && notices && !MINGW.all? { |line| notices.include?(line) }
      found << "#{path}: #{NOTICES} lacks the notices of MinGW-w64"
    end
    if spec.platform.os == "linux" && !LIBCS.include?(spec.platform.version)
      found << "#{path}: Linux gem is neither -gnu nor -musl (#{spec.platform})"
    end
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
