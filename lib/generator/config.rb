# frozen_string_literal: true

require "active_support/inflector"

module Generator
  module Config
    BASE_PATH = File.expand_path("../..", __dir__ || raise("__dir__ is nil"))
    GENERATED_FILE_NOTICE = "This file is generated. Edit template if necessary."

    # Configure ActiveSupport::Inflector with Amazon SP-API acronyms
    ActiveSupport::Inflector.inflections do |inflect|
      ["FBA", "SKU", "ASIN", "URL", "TDS", "SAFET", "CGST", "SGST", "IGST"].each do |acronym|
        inflect.acronym(acronym)
      end
    end

    class << self
      def template_path(template_name)
        # RBS templates are in templates/rbs/, Ruby templates are in templates/
        File.join(BASE_PATH, "lib/generator/templates/#{template_name}.erb")
      end
    end
  end
end
