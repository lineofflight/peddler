# frozen_string_literal: true

require "active_support/inflector"

module Generator
  module Config
    BASE_PATH = File.expand_path("../..", __dir__)

    # Configure ActiveSupport::Inflector with Amazon SP-API acronyms
    ActiveSupport::Inflector.inflections do |inflect|
      ["FBA", "SKU", "ASIN", "URL", "TDS", "SAFET", "CGST", "SGST", "IGST"].each do |acronym|
        inflect.acronym(acronym)
      end
    end

    class << self
      def template_path(template_name)
        # RBS templates don't have .rb extension
        extension = template_name.start_with?("rbs_") ? ".erb" : ".rb.erb"
        File.join(BASE_PATH, "lib/generator/templates/#{template_name}#{extension}")
      end
    end
  end
end
