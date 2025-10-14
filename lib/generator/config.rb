# frozen_string_literal: true

require "active_support/inflector"
require_relative "../peddler/acronyms"

module Generator
  module Config
    BASE_PATH = File.expand_path("../..", __dir__ || raise("__dir__ is nil"))
    GENERATED_FILE_NOTICE = "This file is generated. Do not edit."

    # Configure ActiveSupport::Inflector with Amazon SP-API acronyms
    ActiveSupport::Inflector.inflections do |inflect|
      Peddler::Acronyms.values.each do |acronym|
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
