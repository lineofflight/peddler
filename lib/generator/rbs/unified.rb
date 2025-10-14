# frozen_string_literal: true

require "erb"
require_relative "../config"
require_relative "../support/formatter"
require_relative "../support/file_writer"
require_relative "../builders/parameter_builder"

module Generator
  module RBS
    # Unified RBS generator that combines API operations and type definitions in a single file
    class Unified
      include Formatter
      include FileWriter

      attr_reader :api, :api_name, :api_types

      def initialize(api, api_name, api_types)
        @api = api
        @api_name = api_name
        @api_types = api_types
      end

      def generate
        write_file(rbs_file_path, content)
      end

      def class_name
        api.class_name
      end

      def operations
        api.operations
      end

      def content
        lines = []
        lines << "# #{Config::GENERATED_FILE_NOTICE}"
        lines << ""
        lines << "module Peddler"
        lines << "  module APIs"
        lines << "    class #{class_name} < API"

        # Add nested type definitions first (RBS convention)
        sorted_types = api_types.sort_by(&:class_name)
        sorted_types.each do |type|
          class_def = type.rbs_class_definition
          # Indent the class definition with 6 spaces (inside the API class)
          indented_class = indent(class_def, 6)
          lines << indented_class
          lines << "" # Add blank line between classes
        end

        # Add blank line between types and operations if we have both
        lines << "" if api_types.any? && operations.any?

        # Add API operations
        operations.each do |operation|
          operation_line = render_operation(operation)
          lines << "      #{operation_line}" if operation_line
        end

        # Remove trailing blank line if present
        lines.pop if lines.last == ""

        lines << "    end"
        lines << "  end"
        lines << "end"

        lines.join("\n") + "\n"
      end

      private

      def indent(text, spaces)
        prefix = " " * spaces
        text.lines.map { |line| line.strip.empty? ? line : "#{prefix}#{line}" }.join
      end

      def rbs_file_path
        File.join(Config::BASE_PATH, "sig/peddler/apis/#{api_name}.rbs")
      end

      def render_operation(operation)
        # Skip operations without an operation_id
        operation_id = operation.operation_id
        return unless operation_id

        params = render_parameters(operation)

        method_name = operation_id.underscore

        "def #{method_name}: (#{params}) -> Peddler::Response"
      end

      def render_parameters(operation)
        positional_params = []
        keyword_params = []

        # Build parameters list to match Ruby generator's ordering
        params = build_parameters_list(operation)

        # Process parameters in the same order as Ruby generator
        params.each do |param|
          param_name = param["name"]&.underscore

          # Special handling for rate_limit parameter
          if param_name == "rate_limit"
            # When rate_limit has no default (i.e., it's :unknown), it can be nil
            rate_limit_type = param["default"].nil? ? "Float?" : "Float"
            keyword_params << "?rate_limit: #{rate_limit_type}"
            next
          end

          type = if param["in"] == "body" || param_name&.end_with?("_request", "_request_body", "_body")
            # TODO: Eventually we should type body parameters properly based on their schema
            # Body parameters with nil defaults should be nullable
            base_type = "Hash[untyped, untyped]"
            !param["required"] && param["default"].nil? ? "#{base_type}?" : base_type
          else
            # Optional parameters should have nullable types
            parameter_rbs_type(param, nullable: !param["required"])
          end

          if param["required"]
            positional_params << type
          elsif param_name
            keyword_params << "?#{param_name}: #{type}"
          end
        end

        # Combine parameters - positional first, then keyword
        all_params = positional_params + keyword_params
        all_params.join(", ")
      end

      def build_parameters_list(operation)
        # Reuse the Operation's parameters method which already includes rate_limit via ParameterBuilder
        operation.parameters
      end

      def parameter_rbs_type(param, nullable: false)
        base_type = case param["type"]
        when "string"
          "String"
        when "integer"
          "Integer"
        when "boolean"
          "bool"
        when "number"
          "Numeric"
        when "array"
          if param["items"]
            item_type = param["items"]["type"] || "untyped"
            "Array[#{parameter_item_type(item_type)}]"
          else
            "Array[untyped]"
          end
        else
          "untyped"
        end

        # Optional parameters can be nil
        nullable && base_type != "untyped" ? "#{base_type}?" : base_type
      end

      def parameter_item_type(type)
        case type
        when "string" then "String"
        when "integer" then "Integer"
        when "boolean" then "bool"
        when "number" then "Float"
        else "untyped"
        end
      end
    end
  end
end
