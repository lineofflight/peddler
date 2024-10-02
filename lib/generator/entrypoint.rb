# frozen_string_literal: true

require "erb"

require "generator/config"
require "generator/utils"

module Generator
  class Entrypoint
    include Utils

    attr_reader :apis

    def initialize(apis)
      @apis = apis
    end

    def generate
      File.write(file_path, render_template)
    end

    private

    def render_template
      ERB.new(template, trim_mode: "-").result(binding)
    end

    def file_path
      File.join(Config::BASE_PATH, "lib/peddler.rb")
    end

    def template
      File.read(Config.template_path("entrypoint"))
    end

    def generate_require_statements
      apis.map { |api| "require \"#{api.library_name}\"" }.join("\n")
    end
  end
end
