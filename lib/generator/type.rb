# frozen_string_literal: true

require "erb"
require "fileutils"
require "generator/config"
require "generator/formatter"
require "generator/type_resolver"

module Generator
  class Type
    include Formatter

    attr_reader :name, :definition, :api_name, :specification

    def initialize(name, definition, api_name, specification = nil)
      @name = name
      @definition = definition
      @api_name = api_name
      @specification = specification
    end

    def generate
      # Ensure directory exists before writing
      FileUtils.mkdir_p(File.dirname(file_path))
      File.write(file_path, render)
    end

    def class_name
      # Use ActiveSupport's camelize to properly handle class names
      name.camelize
    end

    def properties
      definition["properties"] || {}
    end

    def required_properties
      definition["required"] || []
    end

    def library_name
      "peddler/types/#{api_name}/#{name.underscore}"
    end

    def ruby_type_for(prop_def, for_comment: false)
      type_resolver.resolve(prop_def, for_comment: for_comment)
    end

    def type_dependencies
      dependencies = []
      properties.each do |_prop_name, prop_def|
        dependencies.concat(extract_dependencies_from_property(prop_def))
      end
      # Only include dependencies that actually get generated as type files
      # Exclude self-references to avoid circular dependencies
      dependencies.select { |dep| generated_type?(dep) && dep != name }.uniq
    end

    def needs_money?
      properties.any? do |_prop_name, prop_def|
        if prop_def["$ref"]
          type_name = prop_def["$ref"].split("/").last
          type_name == "Money" || type_name == "MoneyType"
        else
          false
        end
      end
    end

    def attribute_name_for(prop_name, prop_def)
      underscored = prop_name.underscore
      # For boolean attributes, strip is_ prefix for more idiomatic Ruby
      if prop_def["type"] == "boolean"
        underscored.sub(/^is_/, "")
      else
        underscored
      end
    end

    private

    def extract_dependencies_from_property(prop_def)
      dependencies = []

      if prop_def["$ref"]
        # Extract type name from $ref like "#/definitions/LowestPricedOffersInput"
        type_name = prop_def["$ref"].split("/").last
        dependencies << type_name
      end
      # Extract dependencies from array items
      if prop_def["type"] == "array" && prop_def["items"] && prop_def["items"]["$ref"]
        item_type = prop_def["items"]["$ref"].split("/").last
        dependencies << item_type
      end

      # If a $ref points to an array type, also extract its item dependencies
      if prop_def["$ref"]
        ref_def = specification&.dig("definitions", prop_def["$ref"].split("/").last)
        if ref_def && ref_def["type"] == "array" && ref_def["items"] && ref_def["items"]["$ref"]
          item_type = ref_def["items"]["$ref"].split("/").last
          dependencies << item_type
        end
      end

      dependencies
    end

    def generated_type?(type_name)
      type_resolver.generated_type?(type_name)
    end

    def type_resolver
      @type_resolver ||= TypeResolver.new(name, specification)
    end

    def file_path
      File.join(Config::BASE_PATH, "lib/#{library_name}.rb")
    end

    def format_property_comment(prop_def)
      return_type = ruby_type_for(prop_def, for_comment: true)
      if prop_def["description"]
        split_long_comment_line("@return [#{return_type}] #{prop_def["description"]}", base_indent: 8)
      else
        "        # @return [#{return_type}]"
      end
    end

    def render
      ERB.new(template, trim_mode: "-").result(binding)
    end

    def template
      File.read(Config.template_path("type"))
    end
  end
end
