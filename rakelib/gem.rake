# frozen_string_literal: true

require "rb_sys/extensiontask"

GEMSPEC = Gem::Specification.load(File.expand_path("../peddler.gemspec", __dir__))
# The licenses of the Rust crates a platform gem links into its binary. See tools/third_party_licenses.rb.
NOTICES = "THIRD_PARTY_LICENSES.html"

# `rake compile` builds the extension into lib/peddler through extconf.rb, as
# `gem install` does for the source gem. `rake native gem` builds a gem for the
# running Ruby only (rake-compiler constrains required_ruby_version to it).
# `rake native:<platform> gem` with RUBY_CC_VERSION=3.3:3.4:4.0 builds the fat
# platform gem with binaries in lib/peddler/<ruby minor>/; it needs the
# rb-sys-dock containers (see .github/workflows/packaging.yml).
# Every platform gem gets the license notices of the crates in its binary,
# written by tools/third_party_licenses.rb, which needs cargo-about.
# The extension task asks cargo for package metadata when it is defined, so it
# is skipped on machines without Rust. Other rake tasks keep working.
cargo = ENV.fetch("PATH", "").split(File::PATH_SEPARATOR).any? { |dir| File.executable?(File.join(dir, "cargo")) }
if cargo
  RbSys::ExtensionTask.new("peddler_native", GEMSPEC) do |ext|
    ext.ext_dir = "crates/peddler-ruby"
    ext.lib_dir = "lib/peddler"
    ext.cross_compile = true
    ext.cross_platform = ["arm64-darwin", "x86_64-darwin", "aarch64-linux", "x86_64-linux"]
    ext.cross_compiling do |spec|
      # Platform gems carry binaries only; drop everything that exists for the Rust build.
      spec.files.reject! { |file| file.match?(%r{\A(Cargo\.|crates/)}) }
      spec.extensions.clear
      # Only glibc Linux is supported. A plain "-linux" gem would also be picked by musl hosts.
      if spec.platform.os == "linux" && spec.platform.version.nil?
        spec.platform = Gem::Platform.new([spec.platform.cpu, "linux", "gnu"])
      end
      # The binary links Rust crates statically, so the gem carries their licenses.
      sh RbConfig.ruby, "tools/third_party_licenses.rb", spec.platform.to_s, NOTICES
      spec.files << NOTICES
    end
  end
end
