# frozen_string_literal: true

require "erb"
require "generator/config"
require "generator/utils"
require "generator/parameter_builder"

module Generator
  class Operation
    include Utils

    attr_reader :path, :method, :operation

    def initialize(path, method, operation)
      @path = path
      @method = method
      @operation = operation
    end

    def render
      ERB.new(template, trim_mode: "-").result(binding)
    end

    def generate_method_docs
      formatted_description = format_text(description, 6)
      param_docs = generate_parameter_docs

      "#{formatted_description}\n#\n#{param_docs}\n# @return [Hash] The API response"
    end

    def generate_parameter_docs
      output = parameters.map do |param|
        param_type = param["type"] ? param["type"].capitalize : "Object"
        param_type = "Hash" if param["schema"]
        if param_type == "Array"
          items_type = param.dig("items", "type")
          param_type = items_type ? "Array<#{items_type.capitalize}>" : "Array"
        end
        param_description = param["description"]&.gsub(/\s+/, " ")
        if param_description
          param_description = convert_links_to_markdown(param_description)
        end
        format_text("@param [#{param_type}] #{snakecase(param["name"])} #{param_description}", 6)
      end

      if static_sandbox?
        output.unshift(format_text("@note This operation can make a static sandbox call.", 6))
      elsif dynamic_sandbox?
        output.unshift(format_text("@note This operation can make a dynamic sandbox call.", 6))
      end

      output.join("\n")
    end

    def method_definition(base_indent = 6)
      return if parameters.empty?

      required_params = parameters.select { |p| p["required"] }&.map { |p| snakecase(p["name"]) } || []
      optional_params = parameters.reject do |p|
        p["required"]
      end&.map do |p|
        default_value = p["default"]
        formatted_default = default_value.is_a?(String) ? "\"#{default_value}\"" : default_value
        "#{snakecase(p["name"])}: #{formatted_default ? formatted_default : "nil"}"
      end || []
      params = required_params + optional_params

      prefix = "def #{method_name}("
      suffix = ")"
      max_width = Config::MAX_LINE_LENGTH - base_indent - 2

      lines = []
      current_line = prefix
      params.each do |param|
        if current_line.length + param.length + 3 > max_width
          lines << current_line + ","
          current_line = param
        else
          current_line += current_line == prefix ? param : ", #{param}"
        end
      end
      lines << current_line + suffix

      lines.join("\n")
    end

    def description
      clean_description(operation["description"])
    end

    def parameters
      @parameters ||= ParameterBuilder.new(operation, path.parameters, rate_limit).build
    end

    def method_name
      @name ||= snakecase(operation.delete("operationId"))
    end

    def body_param
      find_body_param
    end

    def query_params
      find_query_params
    end

    def static_sandbox?
      return @static_sandbox if defined?(@static_sandbox)

      @static_sandbox = begin
        code = operation["responses"].keys.find { |code| code.start_with?("2") }
        operation["responses"][code]&.delete("x-amzn-api-sandbox")&.fetch("static")
      end
    end

    private

    def template
      File.read(Config.template_path("operation"))
    end

    def rate_limit
      @rate_limit ||= extract_rate_limit(operation["description"])
    end

    def dynamic_sandbox?
      path.has_dynamic_sandbox? || operation_has_dynamic_sandbox?
    end

    def operation_has_dynamic_sandbox?
      return @operation_has_dynamic_sandbox if defined?(@operation_has_dynamic_sandbox)

      @operation_has_dynamic_sandbox = !!operation.delete("x-amzn-api-sandbox")&.key?("dynamic")
    end

    def find_body_param
      operation["parameters"]&.find { |p| p["in"] == "body" }
    end

    def find_query_params
      operation["parameters"]&.select { |p| p["in"] == "query" }
    end

    def extract_rate_limit(description)
      return unless description

      table_match = description.match(/Burst \|\n\|(?: *---- *\|){2,3}\n(?:\|[^|]*){0,1}\| (\S+) \|[^|]*\|/)
      table_match[1].to_f if table_match
    end

    def clean_description(description)
      return "" unless description

      description = description.gsub("**Note:**", "@note")
      description = convert_links_to_markdown(description)
      description = convert_doc_links_to_full_url(description)
      lines = description.split("\n")
      usage_plan_index = lines.find_index { |line| line.downcase.include?("usage plan") }
      lines = lines[0...usage_plan_index] if usage_plan_index
      lines.reject! { |line| line.strip == "" }
      lines.join("\n").strip
    end
  end
end
