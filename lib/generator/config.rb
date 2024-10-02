# frozen_string_literal: true

module Generator
  module Config
    BASE_PATH = File.expand_path("../..", __dir__)
    OUTPUT_DIR = File.join(BASE_PATH, "lib/peddler/api")

    HTTP_METHODS = ["delete", "get", "patch", "post", "put"].freeze
    MAX_LINE_LENGTH = 120
    OBSOLETE_APIS = ["reports_2020_09_04", "feeds_2020_09_04"]

    class << self
      def template_path(template_name)
        File.join(BASE_PATH, "templates/#{template_name}.rb.erb")
      end

      def api_model_files
        Dir.glob(File.join(BASE_PATH, "bin/selling-partner-api-models/models/**/*.json"))
      end

      def obsolete?(name_with_version)
        OBSOLETE_APIS.any? { |api| name_with_version.include?(api) }
      end
    end
  end
end
