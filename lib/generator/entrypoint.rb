# frozen_string_literal: true

require "erb"

require "generator/config"
require "generator/version_selector"

module Generator
  class Entrypoint
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
        latest_version = VersionSelector.find_latest_version(api_list.map(&:version))
        api_list.find { |api| api.version == latest_version }
      end.sort.to_h
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
  end
end
