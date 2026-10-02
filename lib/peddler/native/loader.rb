# frozen_string_literal: true

require "rbconfig"

module Peddler
  module Native
    # Loads the compiled extension, following the rake-compiler convention.
    #
    # Fat platform gems ship one build per Ruby minor under
    # lib/peddler/<major.minor>/. Source gems, `rake compile` and single-Ruby
    # platform gems (constrained to that Ruby by required_ruby_version) place a
    # single build at lib/peddler/. Developer builds may be on the load path.
    # A build for another Ruby minor is never loaded.
    module Loader
      EXTENSION = "peddler_native"
      DIR = File.expand_path("../..", __FILE__)

      class << self
        def require_extension(dir: DIR, abi: RUBY_VERSION[/\A\d+\.\d+/], dlext: RbConfig::CONFIG["DLEXT"],
          requirer: Kernel.method(:require))
          versioned = File.join(dir, abi, "#{EXTENSION}.#{dlext}")
          return requirer.call(versioned) if File.file?(versioned)

          packaged = packaged_abis(dir)
          unless packaged.empty?
            raise LoadError, "This peddler gem contains native extensions for Ruby #{packaged.join(", ")} " \
              "(file type .#{dlext}), but this is Ruby #{abi} on #{RbConfig::CONFIG["arch"]}. " \
              "Use a matching Ruby and platform, or install the source gem " \
              "(gem install peddler --platform ruby), which needs a Rust toolchain."
          end

          plain = File.join(dir, "#{EXTENSION}.#{dlext}")
          return requirer.call(plain) if File.file?(plain)

          begin
            requirer.call(EXTENSION)
          rescue LoadError => error
            raise unless error.path == EXTENSION

            raise LoadError, "No peddler native extension found for Ruby #{abi}. Install a platform gem or the " \
              "source gem, or build one with `rake compile`."
          end
        end

        private

        def packaged_abis(dir)
          return [] unless File.directory?(dir)

          Dir.children(dir).select do |name|
            name.match?(/\A\d+\.\d+\z/) && !Dir.glob(File.join(dir, name, "#{EXTENSION}.*")).empty?
          end.sort_by { |name| name.split(".").map(&:to_i) }
        end
      end
    end
  end
end
