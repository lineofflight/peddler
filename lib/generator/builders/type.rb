# frozen_string_literal: true

require "erb"
require_relative "../support/config"
require_relative "../support/file_writer"
require_relative "../support/money_detector"
require_relative "../support/naming"
require_relative "../resolvers/type_resolver"
require_relative "../support/schema_helpers"
require "structure/rbs"

module Generator
  class Type
    include FileWriter
    include SchemaHelpers

    NAMESPACES = {
      "notifications" => "Notifications",
      "reports" => "Reports",
      "feeds" => "Feeds",
      "data_kiosk" => "DataKiosk",
    }.freeze

    attr_reader :name, :definition, :api_name, :specification
    attr_accessor :circular_dependencies, :cycle_edges

    def initialize(name, definition, api_name, specification = nil)
      @name = name
      @definition = definition
      @api_name = api_name
      @specification = specification
    end

    def generate
      write_file(file_path, render)
    end

    def class_name
      Naming.class_name(name)
    end

    def namespace
      prefix = api_name.split("/", 2).first
      NAMESPACES[prefix]
    end

    # The module of the schema a type belongs to, named after the schema's file as the schema's own `class_name` is
    def namespace_name
      return unless namespace

      Naming.constant(api_name.split("/", 2).last.camelize)
    end

    def attribute_declaration_for(prop_name, prop_def)
      name = attribute_name_for(prop_name, prop_def)
      type = ruby_type_for(prop_def, prop_name: prop_name)
      required = required_properties.include?(prop_name)
      nullable = Array(prop_def["type"]).include?("null")

      # A name comes from the spec, and a spec is data: the symbol and the string are written as Ruby reads them
      # back, whatever the name holds.
      parts = [name.to_sym.inspect, type]
      parts << "null: false" if required ? !nullable : prop_def["x-non-null"]
      parts << "from: #{prop_name.dump}" if name != prop_name

      "#{required ? "attribute" : "attribute?"}(#{parts.join(", ")})"
    end

    def properties
      props = if definition["allOf"]
        merge_from_all_of("properties") { |props| props || {} }
      else
        definition["properties"] || {}
      end

      sorted_properties(props)
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
      filename = class_name.underscore
      base = namespace ? "peddler/#{api_name}" : "peddler/apis/#{api_name}"

      "#{base}/#{filename}"
    end

    def ruby_type_for(prop_def, for_rbs: false, prop_name: nil)
      resolved_type = type_resolver.resolve(prop_def, for_rbs: for_rbs, prop_name: prop_name)

      # Handle self-references properly
      return resolved_type if resolved_type == ":self"

      # Only use string class names for the specific edges that cause cycles
      if resolved_type.is_a?(String) &&
          resolved_type !~ /^[:\[]/ && resolved_type != "String" && resolved_type != "Integer" &&
          resolved_type != "Float" && !resolved_type.include?("Hash") && !resolved_type.include?("Array") &&
          resolved_type != "Money" && resolved_type != ":boolean"
        return "\"#{resolved_type}\"" if cycle_edge?(resolved_type)
      end

      if resolved_type.is_a?(String)
        inner_type = array_inner_type(resolved_type)
        return "[\"#{inner_type}\"]" if cycle_edge?(inner_type)
      end

      resolved_type
    end

    def type_dependencies
      dependencies = []
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

    # Returns just the class definition without module wrapping
    # Used for consolidated RBS generation
    def rbs_class_definition
      if array_type?
        array_rbs_class_definition
      else
        structure_rbs_class_definition
      end
    end

    private

    # True when the [name, type] edge is one of the cycle-breaking edges, so the
    # reference must be emitted as a lazy string class name rather than a constant.
    def cycle_edge?(type)
      !!(type && cycle_edges&.include?([name, type]))
    end

    # Inner element type of an array-shaped resolved type ("[Foo]" -> "Foo"), or
    # nil when it is not an array shape.
    def array_inner_type(resolved_type)
      resolved_type[/^\[(.+)\]$/, 1] if resolved_type.is_a?(String)
    end

    def sorted_properties(props)
      required = required_properties
      required_props = props.select { |name, _| required.include?(name) }.sort.to_h
      optional_props = props.reject { |name, _| required.include?(name) }.sort.to_h
      required_props.merge(optional_props)
    end

    def merge_from_all_of(field_name)
      if field_name == "properties"
        result = {}
        definition["allOf"].each do |schema|
          if schema["$ref"]
            ref_name = schema["$ref"].split("/").last
            ref_def = specification&.dig("definitions", ref_name)
            if ref_def && ref_def[field_name]
              value = yield(ref_def[field_name])
              result.merge!(value) if value.is_a?(Hash)
            end
          elsif schema[field_name]
            value = yield(schema[field_name])
            result.merge!(value) if value.is_a?(Hash)
          end
        end
      else
        result = []
        definition["allOf"].each do |schema|
          if schema["$ref"]
            ref_name = schema["$ref"].split("/").last
            ref_def = specification&.dig("definitions", ref_name)
            if ref_def && ref_def[field_name]
              value = yield(ref_def[field_name])
              result.concat(value) if value.is_a?(Array)
            end
          elsif schema[field_name]
            value = yield(schema[field_name])
            result.concat(value) if value.is_a?(Array)
          end
        end
      end
      result
    end

    def extract_dependencies_from_property(prop_def)
      dependencies = []
      return dependencies unless prop_def.is_a?(Hash)

      if prop_def["$ref"]
        type_name = prop_def["$ref"].split("/").last
        dependencies << type_name
      end
      if prop_def["type"] == "array" && prop_def["items"].is_a?(Hash) && prop_def["items"]["$ref"]
        item_type = prop_def["items"]["$ref"].split("/").last
        dependencies << item_type
      end

      # If a $ref points to an array type, also extract its item dependencies
      if prop_def["$ref"]
        ref_def = specification&.dig("definitions", prop_def["$ref"].split("/").last)
        if ref_def && ref_def["type"] == "array" && ref_def["items"].is_a?(Hash) && ref_def["items"]["$ref"]
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
      @type_resolver ||= TypeResolver.new(name, specification, api_name)
    end

    def file_path
      File.join(Config::BASE_PATH, "lib/#{library_name}.rb")
    end

    def format_property_comment(prop_def)
      super(prop_def, base_indent: 8)
    end

    def class_description
      return unless definition["description"]
      return if generic_placeholder?(definition["description"])

      description = convert_html_links_to_markdown(definition["description"])
      description = convert_doc_links_to_full_url(description)
      split_long_comment_line(description, base_indent: 6)
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

    # Check if any property uses Time or Date types (requires 'time' library)
    def uses_time_types?
      properties.any? do |_name, prop_def|
        type = ruby_type_for(prop_def)
        type == "Time" || type == "Date" || type.to_s.include?("Time") || type.to_s.include?("Date")
      end
    end

    # Check if any property uses URI (requires 'uri' library)
    def uses_uri_types?
      properties.any? { |_name, prop_def| ruby_type_for(prop_def).to_s.include?("URI") }
    end

    def array_type?
      definition["type"] == "array"
    end

    def array_item_type
      return unless array_type? && definition["items"]

      definition["items"]["$ref"]&.split("/")&.last
    end

    def array_item_type_class_name
      item_type = array_item_type
      return unless item_type

      Naming.class_name(item_type)
    end

    def array_template
      File.read(Config.template_path("array"))
    end

    def structure_rbs_class_definition
      parent = if namespace
        Peddler.const_get(namespace).const_get(namespace_name)
      else
        Peddler::APIs.const_get(api_name.camelize)
      end
      klass = parent.const_get(class_name)

      rbs_content = Structure::RBS.emit(klass)
      raise "Structure::RBS.emit returned nil for #{api_name.camelize}::#{class_name}" unless rbs_content

      # Fix the class name if it's fully qualified and return
      class_lines = rbs_content.lines
      class_lines[0] = class_lines[0].sub(/class .*::(\w+)/, 'class \1')
      class_lines.join
    rescue => e
      raise "Couldn't generate RBS for #{api_name.camelize}::#{class_name}: #{e.message}"
    end

    def array_rbs_class_definition
      item_type = array_item_type
      if item_type && generated_type?(item_type)
        item_class_name = Naming.class_name(item_type)
        <<~RBS
          class #{class_name} < Array[#{item_class_name}]
            def self.parse: (Array[untyped]) -> #{class_name}
          end
        RBS
      else
        <<~RBS
          class #{class_name} < Array[untyped]
            def self.parse: (Array[untyped]) -> #{class_name}
          end
        RBS
      end
    end
  end
end
