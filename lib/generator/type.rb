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
      if definition["allOf"]
        merge_from_all_of("properties") { |props| props || {} }
      else
        definition["properties"] || {}
      end
    end

    def required_properties
      if definition["allOf"]
        result = merge_from_all_of("required") { |req| req || [] }
        result.is_a?(Array) ? result.uniq : result
      else
        definition["required"] || []
      end
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
          TypeResolver::MONEY_TYPES.include?(type_name)
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

    def merge_from_all_of(field_name)
      result = field_name == "properties" ? {} : []

      definition["allOf"].each do |schema|
        if schema["$ref"]
          # Resolve reference and get its field
          ref_name = schema["$ref"].split("/").last
          ref_def = specification["definitions"][ref_name]
          if ref_def && ref_def[field_name]
            value = yield(ref_def[field_name])
            if result.is_a?(Hash)
              result.merge!(value)
            else
              result.concat(value)
            end
          end
        elsif schema[field_name]
          value = yield(schema[field_name])
          if result.is_a?(Hash)
            result.merge!(value)
          else
            result.concat(value)
          end
        end
      end

      result
    end

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
      if array_type?
        array_template
      else
        File.read(Config.template_path("type"))
      end
    end

    def array_type?
      definition["type"] == "array"
    end

    def array_item_type
      return unless array_type? && definition["items"]

      definition["items"]["$ref"]&.split("/")&.last
    end

    def array_template
      <<~ERB
        # frozen_string_literal: true

        <% if array_item_type && generated_type?(array_item_type) -%>
        require "peddler/types/<%= api_name %>/<%= array_item_type.underscore %>"
        <% end -%>

        module Peddler
          module Types
            module <%= api_name.camelize %>
        <% if definition["description"] -%>
        <%= split_long_comment_line(definition["description"], base_indent: 6) %>
        <% end -%>
              class <%= class_name %> < Array
                class << self
                  def parse(array)
                    return new unless array.is_a?(Array)

        <% if array_item_type && generated_type?(array_item_type) -%>
                    new(array.map { |item| <%= array_item_type.camelize %>.parse(item) })
        <% else -%>
                    new(array)
        <% end -%>
                  end
                end
              end
            end
          end
        end
      ERB
    end
  end
end
