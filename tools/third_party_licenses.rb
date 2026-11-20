#!/usr/bin/env ruby
# frozen_string_literal: true

# Writes the license notices of a platform gem: ruby tools/third_party_licenses.rb arm64-darwin [OUTPUT]
#
# A platform gem links Rust crates statically into its extension, so it carries their licenses. The notices list
# exactly the crates linked into peddler_native for the platform, each with its version, its license and the text,
# and the Rust standard library, which is linked too.
#
# - cargo names the crates: the normal dependencies of the extension for the target. That leaves out build
#   scripts, tests and procedural macros, which run when the extension is built and are not in it, and the
#   generator, which is another workspace.
# - cargo-about finds the license and its text in each crate, and fails when a crate has a license that
#   tools/third_party_licenses/about.toml doesn't accept. It runs offline, so it reads only what the crates ship,
#   and cargo fetches every crate of the lockfile first: cargo-about resolves them for all platforms.
# - Where cargo-about finds no license file in a crate, it would print the standard text of the license, which
#   has no copyright line of the crate. That fails here: about.toml has an entry for each such crate.
# - The toolchain ships the license and copyright notices of the standard library: std, core, alloc and the
#   crates they bundle. They are copied in, with the toolchain's version. A toolchain without them fails.
# - The Windows binary also links MinGW-w64's runtime and its winpthreads library statically, from the MinGW-w64
#   of the rb-sys-dock image. Their notices are kept here, as MinGW-w64 ships them, and follow the standard
#   library's in the Windows gem. cargo-about covers crates only.
#
# The file is stamped with what it was written from. When that is unchanged, the file is left as it is and
# cargo-about is not needed: the containers that cross-compile have none, so the packaging workflow writes the
# notices before it starts them. The file is written under another name and renamed, so it is whole or absent.
require "digest"
require "erb"
require "json"
require "open3"
require "rubygems"

# The containers that cross-compile run in the C locale, where Ruby would read the notices as US-ASCII.
Encoding.default_external = Encoding::UTF_8

CARGO_ABOUT = "0.9.2"
ROOT = File.expand_path("..", __dir__)
CONFIG = "tools/third_party_licenses/about.toml"
TEMPLATE = "tools/third_party_licenses/notices.html.erb"
MANIFEST = "crates/peddler-ruby/Cargo.toml"
# The notices of what MinGW-w64 7.0.0, in the rb-sys-dock image, links into the Windows binary, by what they cover
MINGW = {
  "The MinGW-w64 runtime" => "tools/third_party_licenses/COPYING.MinGW-w64-runtime-v7.0.0.txt",
  "winpthreads" => "tools/third_party_licenses/winpthreads-COPYING-v7.0.0.txt",
}.freeze
# What the notices are written from, beside the toolchain. The manifests are among them: a feature can link
# another crate without a change to the lockfile.
INPUTS = [
  "Cargo.lock",
  "Cargo.toml",
  "crates/peddler/Cargo.toml",
  MANIFEST,
  CONFIG,
  TEMPLATE,
  "tools/third_party_licenses.rb",
  "lib/peddler/version.rb",
  *MINGW.values,
].freeze
# Where a toolchain keeps the notices of the standard library, under its sysroot
STANDARD_LIBRARY = "share/doc/rust/COPYRIGHT-library.html"
# Crates that ship no license file at all, as "name version", for which the standard text is all there is
NO_LICENSE_FILE = [].freeze

Crate = Struct.new(:name, :version, :license, :texts)
Notice = Struct.new(:id, :name, :text, :crates, :standard)

def run(*command)
  output, error, status = Open3.capture3(*command, chdir: ROOT)
  abort("#{command.first(3).join(" ")} failed:\n#{error}") unless status.success?

  output
end

def h(text) = ERB::Util.html_escape(text)

def meta(name, content) = %(<meta name="#{name}" content="#{h(content)}">)

# The Rust target of each platform gem that is built
TARGETS = {
  "arm64-darwin" => "aarch64-apple-darwin",
  "x86_64-darwin" => "x86_64-apple-darwin",
  "aarch64-linux-gnu" => "aarch64-unknown-linux-gnu",
  "x86_64-linux-gnu" => "x86_64-unknown-linux-gnu",
  "aarch64-linux-musl" => "aarch64-unknown-linux-musl",
  "x86_64-linux-musl" => "x86_64-unknown-linux-musl",
  "arm-linux-gnu" => "arm-unknown-linux-gnueabihf",
  "arm-linux-musl" => "arm-unknown-linux-musleabihf",
  "x64-mingw-ucrt" => "x86_64-pc-windows-gnu",
}.freeze

# The crates linked into the extension, as [name, version], without Peddler's own.
def linked(triple)
  own = JSON.parse(run("cargo", "metadata", "--format-version", "1", "--no-deps", "--locked"))
    .fetch("packages").map { |package| package.fetch("name") }
  tree = run("cargo", "tree", "--locked", "-p", "peddler_native", "--target", triple, "--edges", "normal,no-proc-macro",
    "--prefix", "none", "--format", "{p}")
  crates = tree.lines.map { |line| line.split.first(2) }.uniq.reject { |name, _| own.include?(name) }
  crates.map { |name, version| [name, version.delete_prefix("v")] }.sort
end

# The notices of the standard library as the toolchain ships them: the body of its document.
def standard_library
  path = File.join(run("rustc", "--print", "sysroot").strip, STANDARD_LIBRARY)
  body = File.read(path)[%r{<body>(.*)</body>}m, 1] if File.file?(path)
  return body.strip if body && !body.strip.empty?

  abort("#{path} is missing or empty, so the toolchain has no license notices for the standard library, which is " \
    "linked into the extension. A toolchain that rustup installs has them, in its rustc component.")
end

platform = Gem::Platform.new(ARGV.fetch(0) { abort("usage: ruby tools/third_party_licenses.rb PLATFORM [OUTPUT]") })
# A Linux gem without a libc in its name is named for glibc.
platform = platform.os == "linux" && platform.version.nil? ? [platform.cpu, "linux", "gnu"].join("-") : platform.to_s
triple = TARGETS.fetch(platform) { abort("no platform gem is built for #{platform}") }
output = File.expand_path(ARGV.fetch(1, "THIRD_PARTY_LICENSES.html"), ROOT)
digest = Digest::SHA256.hexdigest(INPUTS.map { |path| File.read(File.join(ROOT, path)) }.join("\0"))
stamp = "cargo-about #{CARGO_ABOUT}; #{platform}; #{triple}; #{digest}"
toolchain = run("rustc", "--version").strip
installed = Open3.capture2e("cargo", "about", "--version").first.strip
written = File.exist?(output) ? File.read(output) : ""
if written.include?(meta("generator", stamp)) && written.rstrip.end_with?("</html>")
  if written.include?(meta("toolchain", toolchain))
    puts "#{File.basename(output)} is up to date for #{platform}"
    exit
  elsif installed != "cargo-about #{CARGO_ABOUT}"
    # A container that cross-compiles: it can't write the notices again, and nothing else has changed.
    warn("#{File.basename(output)} was written with #{written[/<meta name="toolchain" content="([^"]*)">/, 1]} and " \
      "this is #{toolchain}: its entry for the standard library is the other toolchain's")
    exit
  end
end

unless installed == "cargo-about #{CARGO_ABOUT}"
  abort("cargo-about #{CARGO_ABOUT} is needed, found #{installed.lines.first.to_s.strip.inspect}. " \
    "Install it with: cargo install cargo-about --version #{CARGO_ABOUT} --locked --features cli")
end

library = standard_library
run("cargo", "fetch", "--locked")
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
  users = (license.fetch("used_by").map { |use| use.fetch("crate").values_at("name", "version") } & crates).sort
  next if users.empty?

  Notice.new(license.fetch("id"), license.fetch("name"), license.fetch("text"), users.map { |user| user.join(" ") },
    license.fetch("source_path").nil?)
end
standard = notices.select(&:standard).flat_map { |notice| notice.crates.map { |crate| "#{crate} (#{notice.id})" } }
unexplained = standard.reject { |crate| NO_LICENSE_FILE.include?(crate[/\A\S+ \S+/]) }
unless unexplained.empty?
  abort("cargo-about took no license file of #{unexplained.join(", ")}, so the notices would have the standard text " \
    "without the crate's copyright line. Point a clarify entry in #{CONFIG} at the file the crate ships, or add the " \
    "crate to NO_LICENSE_FILE if it ships none.")
end
counts = notices.flat_map { |notice| [notice.id] * notice.crates.size }.tally.sort_by { |id, count| [-count, id] }
# A file that stands for several licenses of a crate is printed once.
notices = notices.group_by(&:text).map do |text, same|
  Notice.new(same.map(&:id).uniq.join(", "), same.map(&:name).uniq.join(", "), text, same.flat_map(&:crates).uniq.sort)
end
crates = crates.map do |name, version|
  texts = notices.each_index.select { |index| notices[index].crates.include?("#{name} #{version}") }
  abort("cargo-about found no license text for #{name} #{version}") if texts.empty? || !licenses.key?([name, version])

  Crate.new(name, version, licenses.fetch([name, version]), texts)
end

version = File.read(File.join(ROOT, "lib/peddler/version.rb"))[/VERSION = "(.+)"/, 1]
mingw = platform == "x64-mingw-ucrt" ? MINGW.transform_values { |path| File.read(File.join(ROOT, path)) } : {}
# Written beside the file and renamed, so that a run that is cut off leaves no half of it.
draft = "#{output}.#{Process.pid}.tmp"
File.write(draft, ERB.new(File.read(File.join(ROOT, TEMPLATE)), trim_mode: "-").result(binding))
File.rename(draft, output)
puts "#{File.basename(output)}: #{crates.size} crates for #{platform}; texts by license: " \
  "#{counts.map { |id, count| "#{id} #{count}" }.join(", ")}; #{standard.size} on a standard text; " \
  "standard library of #{toolchain}"
