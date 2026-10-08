#!/usr/bin/env ruby
# frozen_string_literal: true

# Writes the license notices of a platform gem: ruby tools/third_party_licenses.rb arm64-darwin [OUTPUT]
#
# A platform gem links Rust crates statically into its extension, so it carries their licenses. The notices list
# exactly the crates linked into peddler_native for the platform, each with its version, its license and the text.
#
# - cargo names the crates: the normal dependencies of the extension for the target. That leaves out build
#   scripts, tests and procedural macros, which run when the extension is built and are not in it, and the
#   generator, which is another workspace.
# - cargo-about finds the license and its text in each crate, and fails when a crate has a license that
#   tools/third_party_licenses/about.toml doesn't accept. It runs offline, so it reads only what the crates ship.
#
# The file is stamped with what it was written from. When that is unchanged, the file is left as it is and
# cargo-about is not needed: the containers that cross-compile have none, so the packaging workflow writes the
# notices before it starts them.
require "digest"
require "erb"
require "json"
require "open3"
require "rubygems"

CARGO_ABOUT = "0.9.2"
ROOT = File.expand_path("..", __dir__)
CONFIG = "tools/third_party_licenses/about.toml"
TEMPLATE = "tools/third_party_licenses/notices.html.erb"
MANIFEST = "crates/peddler-ruby/Cargo.toml"
INPUTS = ["Cargo.lock", CONFIG, TEMPLATE, "tools/third_party_licenses.rb", "lib/peddler/version.rb"].freeze

Crate = Struct.new(:name, :version, :license, :texts)
Notice = Struct.new(:id, :name, :text, :crates)

def run(*command)
  output, error, status = Open3.capture3(*command, chdir: ROOT)
  abort("#{command.first(3).join(" ")} failed:\n#{error}") unless status.success?

  output
end

def h(text) = ERB::Util.html_escape(text)

# The Rust target of a platform gem. Only the 4 that are built have one.
def target(platform)
  cpu = platform.cpu == "arm64" ? "aarch64" : platform.cpu
  triple = { "darwin" => "#{cpu}-apple-darwin", "linux" => "#{cpu}-unknown-linux-gnu" }[platform.os]
  supported = ["aarch64", "x86_64"].include?(cpu) && triple && platform.version != "musl"
  supported ? triple : abort("no platform gem is built for #{platform}")
end

# The crates linked into the extension, as [name, version], without Peddler's own.
def linked(triple)
  own = JSON.parse(run("cargo", "metadata", "--format-version", "1", "--no-deps", "--locked"))
    .fetch("packages").map { |package| package.fetch("name") }
  tree = run("cargo", "tree", "--locked", "-p", "peddler_native", "--target", triple, "--edges", "normal,no-proc-macro",
    "--prefix", "none", "--format", "{p}")
  crates = tree.lines.map { |line| line.split.first(2) }.uniq.reject { |name, _| own.include?(name) }
  crates.map { |name, version| [name, version.delete_prefix("v")] }.sort
end

platform = Gem::Platform.new(ARGV.fetch(0) { abort("usage: ruby tools/third_party_licenses.rb PLATFORM [OUTPUT]") })
triple = target(platform)
output = File.expand_path(ARGV.fetch(1, "THIRD_PARTY_LICENSES.html"), ROOT)
digest = Digest::SHA256.hexdigest(INPUTS.map { |path| File.read(File.join(ROOT, path)) }.join("\0"))
stamp = "cargo-about #{CARGO_ABOUT}; #{triple}; #{digest}"
if File.exist?(output) && File.read(output).include?(%(<meta name="generator" content="#{stamp}">))
  puts "#{File.basename(output)} is up to date for #{triple}"
  exit
end

installed = Open3.capture2e("cargo", "about", "--version").first.strip
unless installed == "cargo-about #{CARGO_ABOUT}"
  abort("cargo-about #{CARGO_ABOUT} is needed, found #{installed.lines.first.to_s.strip.inspect}. " \
    "Install it with: cargo install cargo-about --version #{CARGO_ABOUT} --locked")
end

crates = linked(triple)
# cargo-about writes some keys of a crate's manifest twice.
report = JSON.parse(
  run("cargo", "about", "generate", "--format", "json", "--locked", "--offline", "--target", triple, "--manifest-path",
    MANIFEST, "--config", CONFIG),
  allow_duplicate_key: true,
)
licenses = report.fetch("crates").to_h do |crate|
  [crate.fetch("package").values_at("name", "version"), crate.fetch("license")]
end
notices = report.fetch("licenses").filter_map do |license|
  users = license.fetch("used_by").map { |use| use.fetch("crate").values_at("name", "version") } & crates
  Notice.new(license.fetch("id"), license.fetch("name"), license.fetch("text"), users.sort.map { |user| user.join(" ") }) unless users.empty?
end
crates = crates.map do |name, version|
  texts = notices.each_index.select { |index| notices[index].crates.include?("#{name} #{version}") }
  abort("cargo-about found no license text for #{name} #{version}") if texts.empty? || !licenses.key?([name, version])

  Crate.new(name, version, licenses.fetch([name, version]), texts)
end

version = File.read(File.join(ROOT, "lib/peddler/version.rb"))[/VERSION = "(.+)"/, 1]
File.write(output, ERB.new(File.read(File.join(ROOT, TEMPLATE)), trim_mode: "-").result(binding))
counts = notices.flat_map { |notice| [notice.id] * notice.crates.size }.tally.sort_by { |id, count| [-count, id] }
puts "#{File.basename(output)}: #{crates.size} crates for #{triple}; texts by license: " \
  "#{counts.map { |id, count| "#{id} #{count}" }.join(", ")}"
