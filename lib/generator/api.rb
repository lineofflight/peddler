# frozen_string_literal: true

require "json"
require "erb"

require "generator/config"
require "generator/utils"
require "generator/path"

module Generator
  class API
    include Utils

    attr_reader :file

    def initialize(file)
      @file = file
    end

    def generate
      return if obsolete?

      File.write(output_file_path, render_template)
    end

    def operations
      @operations ||= payload["paths"].flat_map do |path, methods|
        Path.new(path, methods).operations
      end.compact
    end

    def title
      payload["info"]["title"]
    end

    def description
      payload["info"]["description"]
    end

    def library_name
      "peddler/api/#{name_with_version}"
    end

    def class_name
      pascalcase(name_with_version)
    end

    def name_with_version
      [name, version].join("_")
    end

    def payload
      @payload ||= JSON.parse(File.read(file))
    end

    def obsolete?
      Config.obsolete?(name_with_version)
    end

    private

    def render_template
      ERB.new(template, trim_mode: "-").result(binding)
    end

    def output_file_path
      File.join(Config::BASE_PATH, "lib/#{library_name}.rb")
    end

    def template
      File.read(Config.template_path("api"))
    end

    def name
      file.split("/")[-2].tr("-", "_").sub(/(?:_api)?_model$/, "")
    end

    def version
      payload["info"]["version"].tr("-", "_")
    end
  end
end
