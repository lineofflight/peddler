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

    def required_libraries
      apis.map(&:library_name).append("peddler/token").sort
    end

    def apis_with_latest_version
      apis.group_by(&:name).transform_values do |api_list|
        find_latest_version(api_list.map(&:version))
      end.sort.to_h
    end

    private

    def find_latest_version(versions)
      versions.sort_by do |version|
        if version.start_with?("v")
          [1, version]
        else
          [2, version]
        end
      end.last
    end

    def render_template
      ERB.new(template, trim_mode: "-").result(binding)
    end

    def file_path
      File.join(Config::BASE_PATH, "lib/peddler.rb")
    end

    def template
      File.read(Config.template_path("entrypoint"))
    end
  end
end
