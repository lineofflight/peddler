# frozen_string_literal: true

require "erb"
require "fileutils"
require "generator/config"
require "generator/formatter"

module Generator
  class RBSType
    include Formatter

    attr_reader :type, :api_name, :specification

    def initialize(type, api_name, specification = nil)
      @type = type
      @api_name = api_name
      @specification = specification
    end

    def generate
      FileUtils.mkdir_p(File.dirname(rbs_file_path))
      File.write(rbs_file_path, render_rbs)
    end

    def class_name
      type.class_name
    end

    def properties
      type.properties
    end

    def required_properties
      type.required_properties
    end

    def required?(prop_name)
      required_properties.include?(prop_name)
    end

    def library_name
      "peddler/types/#{api_name}/#{type.name.underscore}"
    end

    private

    def rbs_file_path
      File.join(Config::BASE_PATH, "sig/#{library_name}.rbs")
    end

    def rbs_type_for(prop_def)
      case prop_def["type"]
      when "string"
        "String"
      when "integer"
        "Integer"
      when "boolean"
        "bool"
      when "number"
        "Float"
      when "array"
        if prop_def["items"]
          item_type = rbs_type_for(prop_def["items"])
          "Array[#{item_type}]"
        else
          "Array[untyped]"
        end
      when "object"
        if prop_def["additionalProperties"]
          # additionalProperties can be true (any type), false (no additional props), or a schema
          case prop_def["additionalProperties"]
          when true
            "Hash[String, untyped]"
          when false
            "Hash[String, untyped]" # Still a hash, just with specific keys
          else
            value_type = rbs_type_for(prop_def["additionalProperties"])
            "Hash[String, #{value_type}]"
          end
        else
          "Hash[String, untyped]"
        end
      else
        if prop_def["$ref"]
          ref_type = prop_def["$ref"].split("/").last
          # Check if it's Money type
          if ref_type == "Money" || ref_type == "MoneyType"
            "Money"
          else
            # Try to resolve the reference to its actual type
            resolve_ref_type(ref_type)
          end
        elsif prop_def["allOf"]
          # Handle allOf by using the first type
          rbs_type_for(prop_def["allOf"].first)
        elsif prop_def["oneOf"]
          # Handle oneOf as union type
          types = prop_def["oneOf"].map { |schema| rbs_type_for(schema) }
          "(#{types.join(" | ")})"
        else
          "untyped"
        end
      end
    end

    def attribute_name_for(prop_name, prop_def)
      type.attribute_name_for(prop_name, prop_def)
    end

    def resolve_ref_type(ref_type)
      # If we have the specification, try to resolve the reference
      if specification && specification["definitions"] && specification["definitions"][ref_type]
        ref_def = specification["definitions"][ref_type]

        case ref_def["type"]
        when "string"
          # Special cases for string types that represent specific values
          case ref_type
          when "Decimal", "BigDecimal"
            "Float" # Or we could use String if we want to preserve precision
          else
            "String"
          end
        when "integer"
          "Integer"
        when "number"
          "Float"
        when "boolean"
          "bool"
        when "array"
          if ref_def["items"]
            item_type = rbs_type_for(ref_def["items"])
            "Array[#{item_type}]"
          else
            "Array[untyped]"
          end
        when "object"
          # This is an actual object type that should have been generated
          ref_type.camelize
        else
          # Unknown type or no type specified - treat as untyped
          "untyped"
        end
      else
        # Can't resolve - assume it's a type name that needs proper casing
        ref_type.camelize
      end
    end

    def render_rbs
      ERB.new(rbs_template, trim_mode: "-").result(binding)
    end

    def array_type?
      type.definition["type"] == "array"
    end

    def array_item_type
      return unless array_type? && type.definition["items"]

      if type.definition["items"]["$ref"]
        ref_type = type.definition["items"]["$ref"].split("/").last
        # Check if the referenced type is actually generated as a class
        # Enums and some other types are not generated as separate classes
        if type_exists?(ref_type)
          ref_type
        else
          # For enums and other non-generated types, determine the base type
          resolve_base_type(ref_type)
        end
      end
    end

    def resolve_base_type(ref_type)
      ref_def = specification&.dig("definitions", ref_type)
      return "untyped" unless ref_def

      case ref_def["type"]
      when "string" then "String"
      when "integer" then "Integer"
      when "boolean" then "bool"
      when "number" then "Float"
      else "untyped"
      end
    end

    def type_exists?(type_name)
      # Check if a corresponding Ruby type file exists
      type_file = File.join(
        Config::BASE_PATH,
        "lib/peddler/types/#{api_name}/#{type_name.underscore}.rb",
      )
      File.exist?(type_file)
    end

    def rbs_template
      if array_type?
        array_rbs_template
      else
        object_rbs_template
      end
    end

    def array_rbs_template
      <<~ERB
        module Peddler
          module Types
            module <%= api_name.camelize %>
              class <%= class_name %> < Array[<%= array_item_type ? array_item_type.camelize : "untyped" %>]
                def self.parse: (Array[untyped] array) -> instance
              end
            end
          end
        end
      ERB
    end

    def object_rbs_template
      <<~ERB
        module Peddler
          module Types
            module <%= api_name.camelize %>
              class <%= class_name %> < Data
        <% properties.each do |prop_name, prop_def| -%>
        <% attr_name = attribute_name_for(prop_name, prop_def) -%>
        <% is_required = required?(prop_name) -%>
                attr_reader <%= attr_name %>: <%= rbs_type_for(prop_def) %><%= is_required ? "" : "?" %>
        <% end -%>

                def self.parse: (Hash[String, untyped] hash) -> instance

                def initialize: (
        <% properties.each_with_index do |(prop_name, prop_def), index| -%>
        <% attr_name = attribute_name_for(prop_name, prop_def) -%>
        <% is_required = required?(prop_name) -%>
                  <%= is_required ? "" : "?" %><%= attr_name %>: <%= rbs_type_for(prop_def) %><%= "," unless index == properties.size - 1 %>
        <% end -%>
                ) -> void
              end
            end
          end
        end
      ERB
    end
  end
end
