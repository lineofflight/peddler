# frozen_string_literal: true

require "erb"
require "fileutils"
require "generator/config"
require "generator/formatter"
require "generator/type_resolver"
require "structure/rbs"

module Generator
  class Type
    include Formatter

    attr_reader :name, :definition, :api_name, :specification
    attr_accessor :circular_dependencies, :cycle_edges

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

    def ruby_type_for(prop_def, for_comment: false, for_rbs: false)
      resolved_type = type_resolver.resolve(prop_def, for_comment: for_comment, for_rbs: for_rbs)

      # Handle self-references properly
      return resolved_type if resolved_type == ":self"

      # Only use string class names for the specific edges that cause cycles
      unless for_comment
        # Handle direct references
        if resolved_type.is_a?(String) &&
            resolved_type !~ /^[:\[]/ && resolved_type != "String" && resolved_type != "Integer" &&
            resolved_type != "Float" && !resolved_type.include?("Hash") && !resolved_type.include?("Array") &&
            resolved_type != "Money" && resolved_type != ":boolean"
          # Check if THIS specific edge causes a cycle
          if cycle_edges&.include?([name, resolved_type])
            # Return as a string for lazy loading
            return "\"#{resolved_type}\""
          end
        end

        # Handle arrays containing cycle-causing types
        if resolved_type.is_a?(String) && resolved_type =~ /^\[(.+)\]$/
          inner_type = ::Regexp.last_match(1)
          # Only use string class for actual cycles
          if inner_type && cycle_edges&.include?([name, inner_type])
            # Return as array with string class name for lazy loading
            return "[\"#{inner_type}\"]"
          end
        end
      end

      resolved_type
    end

    def type_dependencies
      dependencies = [] #: Array[String]
      properties.each do |_prop_name, prop_def|
        dependencies.concat(extract_dependencies_from_property(prop_def))
      end
      # Only include dependencies that actually get generated as type files
      # Exclude self-references to avoid requiring ourselves
      # Only exclude the specific edges that cause cycles (not all edges between circular types!)
      dependencies.select do |dep|
        generated_type?(dep) &&
          dep != name &&
          !(cycle_edges && cycle_edges.include?([name, dep]))
      end.uniq
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

    def uses_string_class_names?
      properties.any? do |_prop_name, prop_def|
        resolved_type = type_resolver.resolve(prop_def)

        # Check for self-references
        if resolved_type == class_name || resolved_type == "[#{class_name}]"
          return true
        end

        # Check for cycle-causing edges
        if resolved_type.is_a?(String)
          # Handle direct types
          if resolved_type !~ /^[:\[]/ && resolved_type != "String" && resolved_type != "Integer" &&
              resolved_type != "Float" && resolved_type != "Hash" && resolved_type != "Array" &&
              resolved_type != "Money" && resolved_type != ":boolean"
            return true if cycle_edges&.include?([name, resolved_type])
          end

          # Handle arrays
          if resolved_type =~ /^\[(.+)\]$/
            inner_type = ::Regexp.last_match(1)
            return true if inner_type && cycle_edges&.include?([name, inner_type])
          end
        end

        false
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

    def generate_rbs
      # Generate RBS file path
      rbs_path = File.join(Config::BASE_PATH, "sig/#{library_name}.rbs")
      FileUtils.mkdir_p(File.dirname(rbs_path))

      # Generate the appropriate RBS content
      rbs_content = if array_type?
        generate_array_rbs
      else
        generate_structure_rbs
      end

      File.write(rbs_path, rbs_content)
    end

    private

    def merge_from_all_of(field_name)
      if field_name == "properties"
        result = {} #: Hash[String, untyped]
        definition["allOf"].each do |schema|
          if schema["$ref"]
            ref_name = schema["$ref"].split("/").last
            ref_def = specification&.dig("definitions", ref_name)
            if ref_def && ref_def[field_name]
              value = yield(ref_def[field_name]) #: untyped
              result.merge!(value) if value.is_a?(Hash)
            end
          elsif schema[field_name]
            value = yield(schema[field_name]) #: untyped
            result.merge!(value) if value.is_a?(Hash)
          end
        end
      else
        result = [] #: Array[String]
        definition["allOf"].each do |schema|
          if schema["$ref"]
            ref_name = schema["$ref"].split("/").last
            ref_def = specification&.dig("definitions", ref_name)
            if ref_def && ref_def[field_name]
              value = yield(ref_def[field_name]) #: untyped
              result.concat(value) if value.is_a?(Array)
            end
          elsif schema[field_name]
            value = yield(schema[field_name]) #: untyped
            result.concat(value) if value.is_a?(Array)
          end
        end
      end
      result
    end

    def extract_dependencies_from_property(prop_def)
      dependencies = [] #: Array[String]

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
      File.read(Config.template_path("array"))
    end

    def generate_structure_rbs
      # Load the specific type
      require library_name
      klass = Peddler::Types.const_get(api_name.camelize).const_get(class_name)

      # Generate RBS using Structure::RBS
      rbs_content = Structure::RBS.emit(klass)
      raise "Structure::RBS.emit returned nil for #{api_name.camelize}::#{class_name}" unless rbs_content

      # Wrap in proper module structure
      wrap_rbs_in_modules(rbs_content)
    rescue => e
      raise "Couldn't generate RBS for #{api_name.camelize}::#{class_name}: #{e.message}"
    end

    def generate_array_rbs
      template = File.read(Config.template_path("rbs/array"))
      ERB.new(template, trim_mode: "-").result(binding)
    end

    def wrap_rbs_in_modules(rbs_content)
      # Extract the class definition from Structure::RBS output
      class_lines = rbs_content.lines

      # Fix the class name if it's fully qualified
      class_lines[0] = class_lines[0].sub(/class .*::(\w+)/, 'class \1')

      # Build the properly nested module structure
      lines = [] #: Array[String]
      lines << "# #{Generator::Config::GENERATED_FILE_NOTICE}"
      lines << ""
      lines << "module Peddler"
      lines << "  module Types"
      lines << "    module #{api_name.camelize}"

      # Indent the class definition properly
      class_lines.each do |line|
        lines << "      #{line}".rstrip
      end

      lines << "    end"
      lines << "  end"
      lines << "end"

      lines.join("\n") + "\n"
    end
  end
end
