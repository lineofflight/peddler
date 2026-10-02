# frozen_string_literal: true

require "erb"
require_relative "../support/config"
require_relative "../support/file_writer"

module Generator
  module RBS
    class Entrypoint
      include FileWriter

      def generate
        write_file(file_path, render_template)
      end

      private

      def render_template
        ERB.new(template, trim_mode: "-").result(binding)
      end

      def file_path
        File.join(Config::BASE_PATH, "sig/peddler.rbs")
      end

      def template
        File.read(Config.template_path("rbs/entrypoint"))
      end
    end
  end
end
