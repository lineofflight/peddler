# frozen_string_literal: true

require "zeitwerk"
require_relative "../../peddler/inflector"

module Generator
  # Provides a temporary Zeitwerk loader for introspecting generated files during RBS generation.
  # This loader is separate from the main gem loader and is only used during code generation.
  class IntrospectionLoader
    class << self
      # Sets up and returns a configured Zeitwerk loader for introspection
      def setup
        return @loader if @loader

        lib_dir = File.expand_path("../../../lib", __dir__ || raise)
        root_file = File.join(lib_dir, "peddler.rb")

        @loader = Zeitwerk::Loader.new
        @loader.push_dir(lib_dir)
        @loader.inflector = Peddler::Inflector.new(root_file)
        @loader.ignore("#{lib_dir}/generator")
        @loader.enable_reloading
        @loader.setup

        @loader
      end

      # Reloads all files (call this after generating new files)
      def reload
        @loader&.reload
      end
    end
  end
end
