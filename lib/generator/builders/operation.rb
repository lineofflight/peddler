# frozen_string_literal: true

require "erb"
require_relative "../support/config"
require_relative "../support/formatter"
require_relative "../support/naming"
require_relative "parameter_builder"
require_relative "response_model"
require_relative "../parsers/rate_limit_parser"

module Generator
  class Operation
    include Formatter

    DEFAULT_TEMPLATE = File.read(Config.template_path("operation"))

    attr_reader :path, :verb, :operation, :api_name_with_version, :template

    def initialize(path, verb, operation, api_name_with_version, template: DEFAULT_TEMPLATE)
      @path = path
      @verb = verb
      @operation = operation
      @api_name_with_version = api_name_with_version
      @template = template
    end

    def operation_id
      operation["operationId"]
    end

    def render
      ERB.new(template, trim_mode: "-").result(binding)
    end

    def description
      description = operation["description"]

      # Remove usage plan details
      # Some API models have literal \n strings instead of actual newlines
      delimiter = description.include?("\\n") ? "\\n" : "\n"
      lines = description.split(delimiter)
      usage_plan_index = lines.find_index { |line| line.downcase.include?("usage plan") }
      lines = lines[0...usage_plan_index] if usage_plan_index
      # Join lines back together, preserving blank lines for proper paragraph separation
      description = lines.join("\n").strip

      # Ensure **Note:** and **Examples:** start on new lines with blank lines before them
      # Handle both **Note:** and __Note__: formats (will be normalized to ** later)
      description = description.gsub(/(\S)\s*((\*\*|__)(Note|Examples?):(\*\*|__))/, "\\1\n\n\\2")

      description = convert_html_links_to_yard(description)
      description = convert_doc_links_to_full_url(description)

      split_long_comment_line(description, base_indent: 6)
    end

    def tags
      output = parameters.map do |param|
        param_type = param["type"] ? param["type"].capitalize : "Object"
        param_type = "Hash" if param["schema"]
        if param_type == "Array"
          items_type = param.dig("items", "type")
          param_type = items_type ? "Array<#{items_type.capitalize}>" : "Array"
        end
        param_name = param["name"].underscore
        param_description = param["description"]&.gsub(/\s+/, " ")
        param_description = convert_html_links_to_yard(param_description) if param_description
        param_description = convert_doc_links_to_full_url(param_description) if param_description

        "@param #{param_name} [#{param_type}] #{param_description}"
      end

      if static_sandbox?
        output.unshift("@note This operation can make a static sandbox call.")
      elsif dynamic_sandbox?
        output.unshift("@note This operation can make a dynamic sandbox call.")
      end
      output << "@return [Peddler::Response] The API response"

      output.map do |line|
        line = convert_html_links_to_yard(line)
        line = convert_doc_links_to_full_url(line)
        split_long_comment_line(line, base_indent: 6, wrap_indent: 2)
      end
    end

    def method_definition
      method_name = operation["operationId"].underscore

      required_params = parameters.select { |p| p["required"] }&.map { |p| p["name"].underscore } || []
      optional_params = parameters.reject do |p|
        p["required"]
      end.map do |p|
        default_value = p["default"]

        # Handle array parameters with string defaults (OpenAPI spec inconsistency)
        formatted_default = if p["type"] == "array" && default_value.is_a?(String)
          "[\"#{default_value}\"]"
        elsif default_value.is_a?(String)
          "\"#{default_value}\""
        elsif default_value.is_a?(Array)
          default_value.inspect
        else
          default_value || "nil"
        end

        "#{p["name"].underscore}: #{formatted_default}"
      end
      params = required_params + optional_params

      format_method_definition(method_name, params, base_indent: 6)
    end

    def sandbox_rule
      if !static_sandbox? && !dynamic_sandbox?
        "cannot_sandbox!\n\n"
      elsif sandbox_only?
        "must_sandbox!\n\n"
      end
    end

    def body_param_name
      body_param = parameters.find { |p| p["in"] == "body" }
      body_param["name"].underscore if body_param
    end

    def query_params
      hash = {}
      parameters.select { |p| p["in"] == "query" }.each do |p|
        param_name = p["name"].underscore
        value = param_name

        # If parameter is array type, add array handling
        if p["type"] == "array"
          value = "stringify_array(#{param_name})"
        end

        hash[p["name"]] = value
      end
      hash
    end

    def request_args
      args = ["path"]
      args << "body:" if body_param_name
      args << "params:" if query_params.any?

      args
    end

    def has_typed_response?
      !!operation_id && response_model[:model]
    end

    def response_model
      @response_model ||= ResponseModel.new(operation).build
    end

    def parameters
      @parameters ||= ParameterBuilder.new(operation, path.parameters, rate_limit).build
    end

    def rate_limit
      @rate_limit ||= RateLimitParser.new(operation).parse
    end

    private

    def parser_class_name
      return unless has_typed_response?

      # Apply acronym transformations to match the generated constant name
      Naming.class_name(response_model[:model])
    end

    def name
      (operation_id || raise("operation_id is nil")).underscore
    end

    def dynamic_sandbox?
      path.has_dynamic_sandbox? || !!operation.dig("x-amzn-api-sandbox", "dynamic")
    end

    def static_sandbox?
      code = operation["responses"].keys.find { |code| code.start_with?("2") }

      !!operation["responses"][code]&.dig("x-amzn-api-sandbox", "static")
    end

    def sandbox_only?
      path.sandbox_only? || !!operation["x-amzn-api-sandbox-only"]
    end
  end
end
