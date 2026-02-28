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

    def attribute_declaration_for(prop_name, prop_def)
      name = attribute_name_for(prop_name, prop_def)
      type = ruby_type_for(prop_def, prop_name: prop_name)
      required = required_properties.include?(prop_name)
      nullable = Array(prop_def["type"]).include?("null")

      parts = [":#{name}", type]
      parts << "null: false" if required ? !nullable : prop_def["x-non-null"]
      parts << "from: \"#{prop_name}\"" if name != prop_name

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
      # Use the acronym-transformed class name for filename to match Zeitwerk expectations
      # This ensures filenames like "claim_proof_urls.rb" instead of "claim_proof_ur_ls.rb"
      filename = class_name.underscore

      # For notification, report, feed, and data_kiosk nested types, use peddler/...
      if api_name.start_with?("notifications/", "reports/", "feeds/", "data_kiosk/")
        "peddler/#{api_name}/#{filename}"
      else
        "peddler/apis/#{api_name}/#{filename}"
      end
    end

    def ruby_type_for(prop_def, for_comment: false, for_rbs: false, prop_name: nil)
      resolved_type = type_resolver.resolve(prop_def, for_comment: for_comment, for_rbs: for_rbs, prop_name: prop_name)

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

    def needs_money?
      properties.any? do |_prop_name, prop_def|
        if prop_def["$ref"]
          type_name = prop_def["$ref"].split("/").last
          MoneyDetector.money_type?(type_name)
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
        # Extract type name from $ref like "#/definitions/LowestPricedOffersInput"
        type_name = prop_def["$ref"].split("/").last
        dependencies << type_name
      end
      # Extract dependencies from array items
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
      return_type = ruby_type_for(prop_def, for_comment: true)
      if prop_def["description"] && !generic_placeholder?(prop_def["description"])
        description = convert_html_links_to_yard(prop_def["description"])
        description = convert_doc_links_to_full_url(description)
        split_long_comment_line("@return [#{return_type}] #{description}", base_indent: 8, wrap_indent: 2)
      else
        "        # @return [#{return_type}]"
      end
    end

    def class_description
      return unless definition["description"]
      return if generic_placeholder?(definition["description"])

      description = convert_html_links_to_yard(definition["description"])
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
      # Get the constant - Zeitwerk will autoload it
      if api_name.start_with?("notifications/")
        notification_name = api_name.sub("notifications/", "").camelize
        klass = Peddler::Notifications.const_get(notification_name).const_get(class_name)
      elsif api_name.start_with?("reports/")
        report_name = api_name.sub("reports/", "").camelize
        klass = Peddler::Reports.const_get(report_name).const_get(class_name)
      elsif api_name.start_with?("feeds/")
        feed_name = api_name.sub("feeds/", "").camelize
        klass = Peddler::Feeds.const_get(feed_name).const_get(class_name)
      elsif api_name.start_with?("data_kiosk/")
        data_kiosk_name = api_name.sub("data_kiosk/", "").camelize
        klass = Peddler::DataKiosk.const_get(data_kiosk_name).const_get(class_name)
      else
        klass = Peddler::APIs.const_get(api_name.camelize).const_get(class_name)
      end

      # Generate RBS using Structure::RBS
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
      # Generate the array class definition inline (no template needed)
      item_type = array_item_type
      if item_type && generated_type?(item_type)
        # Apply acronym transformations to item type
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
