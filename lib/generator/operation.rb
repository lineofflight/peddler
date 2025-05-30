# frozen_string_literal: true

require "erb"
require "generator/config"
require "generator/formatter"
require "generator/utils"
require "generator/parameter_builder"

module Generator
  class Operation
    include Formatter
    include Utils

    attr_reader :path, :verb, :operation

    def initialize(path, verb, operation)
      @path = path
      @verb = verb
      @operation = operation
    end

    def render
      ERB.new(template, trim_mode: "-").result(binding)
    end

    def description
      description = operation["description"]

      # Remove usage plan details
      lines = description.split("\n")
      usage_plan_index = lines.find_index { |line| line.downcase.include?("usage plan") }
      lines = lines[0...usage_plan_index] if usage_plan_index
      lines.reject! { |line| line.strip == "" }
      description = lines.join("\n").strip

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
        param_name = snakecase(param["name"])
        param_description = param["description"]&.gsub(/\s+/, " ")

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
      method_name = snakecase(operation.delete("operationId"))

      required_params = parameters.select { |p| p["required"] }&.map { |p| snakecase(p["name"]) } || []
      optional_params = parameters.reject do |p|
        p["required"]
      end.map do |p|
        default_value = p["default"]
        formatted_default = default_value.is_a?(String) ? "\"#{default_value}\"" : default_value

        "#{snakecase(p["name"])}: #{formatted_default ? formatted_default : "nil"}"
      end
      params = required_params + optional_params

      format_method_definition(method_name, params, base_indent: 6)
    end

    def sandbox_rule
      if !static_sandbox? && !dynamic_sandbox?
        "cannot_sandbox!\n\n"
      elsif path.sandbox_only?
        "must_sandbox!\n\n"
      end
    end

    def body_param_name
      body_param = parameters.find { |p| p["in"] == "body" }
      snakecase(body_param["name"]) if body_param
    end

    def query_params
      parameters.select do |p|
        p["in"] == "query"
      end.reduce({}) do |hash, p|
        param_name = snakecase(p["name"])
        value = param_name

        # If parameter is array type, add array handling
        if p["type"] == "array"
          value = "stringify_array(#{param_name})"
        end

        hash.merge(p["name"] => value)
      end
    end

    def request_args
      args = ["path"]
      args << "body:" if body_param_name
      args << "params:" if query_params.any?

      args
    end

    private

    def parameters
      @parameters ||= ParameterBuilder.new(operation, path.parameters, rate_limit).build
    end

    def rate_limit
      match = operation["description"].match(/Burst \|\n\|(?: *---- *\|){2,3}\n(?:\|[^|]*){0,1}\| (\S+) \|[^|]*\|/)
      match[1].to_f if match
    end

    def dynamic_sandbox?
      path.has_dynamic_sandbox? || !!operation.dig("x-amzn-api-sandbox", "dynamic")
    end

    def static_sandbox?
      code = operation["responses"].keys.find { |code| code.start_with?("2") }

      !!operation["responses"][code]&.dig("x-amzn-api-sandbox", "static")
    end

    def template
      File.read(Config.template_path("operation"))
    end
  end
end
