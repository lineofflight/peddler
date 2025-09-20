# frozen_string_literal: true

require "erb"
require "generator/config"
require "generator/formatter"
require "generator/parameter_builder"

module Generator
  class Operation
    include Formatter

    attr_reader :path, :verb, :operation, :api_name_with_version, :specification

    DEFAULT_PAYLOAD_KEY = "payload"

    def initialize(path, verb, operation, api_name_with_version = nil, specification = nil)
      @path = path
      @verb = verb
      @operation = operation
      @api_name_with_version = api_name_with_version
      @specification = specification
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
      description = description.gsub(/(\S)\s*(\*\*(Note|Examples?):\*\*)/, "\\1\n\n\\2")

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
          default_value
        end

        "#{p["name"].underscore}: #{formatted_default ? formatted_default : "nil"}"
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
      body_param["name"].underscore if body_param
    end

    def query_params
      parameters.select do |p|
        p["in"] == "query"
      end.reduce({}) do |hash, p|
        param_name = p["name"].underscore
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

    def has_typed_response?
      !!operation_id && response_model[:model]
    end

    def response_model
      @response_model ||= build_response_model
    end

    def parameters
      @parameters ||= ParameterBuilder.new(operation, path.parameters, rate_limit).build
    end

    private

    def build_response_model
      success_response = find_success_response
      return default_response_model unless success_response && success_response["schema"]

      schema = success_response["schema"]

      if schema["$ref"]
        build_ref_response_model(schema["$ref"])
      elsif schema["properties"] && schema["properties"]["payload"]
        handle_inline_payload_response(schema["properties"]["payload"])
      else
        default_response_model
      end
    end

    def build_ref_response_model(ref)
      response_type_name = ref.split("/").last
      {
        type: :response,
        model: response_type_name,
        path: [],
      }
    end

    def default_response_model
      { type: :raw, model: nil, path: ["payload"] }
    end

    def find_success_response
      responses = operation["responses"]
      # Amazon SP-API uses various 2xx codes: 200 (OK), 201 (Created), 202 (Accepted), 204 (No Content)
      responses["200"] || responses["201"] || responses["202"] || responses["204"]
    end

    def handle_ref_response(schema)
      response_def_name = schema["$ref"].split("/").last
      definitions = specification&.dig("definitions")
      response_def = definitions&.dig(response_def_name)

      return default_response_model unless response_def&.dig("properties", "payload")

      payload_schema = response_def["properties"]["payload"]
      return default_response_model unless payload_schema["$ref"]

      actual_model_name = payload_schema["$ref"].split("/").last
      determine_model_type(actual_model_name, definitions)
    end

    def determine_model_type(model_name, definitions)
      if model_name.end_with?("List")
        handle_list_model(model_name, definitions)
      elsif plural_array_type?(model_name)
        build_plural_array_model(model_name)
      else
        build_single_model(model_name)
      end
    end

    def plural_array_type?(model_name)
      model_name.end_with?("s") && !model_name.match?(/(?:Address|Info|Status|Data)$/)
    end

    def build_plural_array_model(model_name)
      {
        type: :array,
        model: model_name.sub(/s$/, ""),
        path: ["payload", model_name],
      }
    end

    def build_single_model(model_name)
      {
        type: :single,
        model: model_name,
        path: ["payload"],
      }
    end

    def handle_list_model(model_name, definitions)
      model_def = definitions&.dig(model_name)

      if model_def&.dig("properties")
        array_property = find_array_property(model_def["properties"], definitions)
        return build_array_property_model(array_property) if array_property
      end

      # Fallback for List models
      build_list_fallback_model(model_name)
    end

    def build_array_property_model(array_property)
      array_property_name, singular_model_name = array_property
      {
        type: :array,
        model: singular_model_name,
        path: ["payload", array_property_name],
      }
    end

    def build_list_fallback_model(model_name)
      {
        type: :array,
        model: model_name.sub(/List$/, ""),
        path: ["payload", model_name],
      }
    end

    def find_array_property(properties, definitions)
      properties.each do |prop_name, prop_def|
        next unless prop_def["$ref"]

        ref_name = prop_def["$ref"].split("/").last
        ref_def = definitions&.dig(ref_name)

        if ref_def&.dig("type") == "array" && ref_def.dig("items", "$ref")
          singular_model_name = ref_def["items"]["$ref"].split("/").last
          return [prop_name, singular_model_name]
        end
      end

      nil
    end

    def handle_inline_payload_response(payload_schema)
      if payload_schema["$ref"]
        handle_payload_ref(payload_schema["$ref"])
      elsif payload_schema["properties"]
        handle_properties_payload(payload_schema)
      else
        default_response_model
      end
    end

    def handle_payload_ref(ref)
      model_name = ref.split("/").last
      build_single_model(model_name)
    end

    def handle_properties_payload(payload_schema)
      return default_response_model unless payload_schema["properties"]

      array_prop = find_array_in_properties(payload_schema["properties"])

      if array_prop
        build_properties_array_model(array_prop[0])
      else
        build_properties_single_model(payload_schema["properties"].keys.first)
      end
    end

    def find_array_in_properties(properties)
      properties.find { |_, prop| prop["type"] == "array" }
    end

    def build_properties_array_model(array_name)
      {
        type: :array,
        model: array_name.sub(/s$/, ""),
        path: ["payload", array_name],
      }
    end

    def build_properties_single_model(model_name)
      {
        type: :single,
        model: model_name,
        path: ["payload", model_name],
      }
    end

    def parser_class
      return unless has_typed_response?

      model = response_model
      return unless model && model[:model]

      api_class = api_name_with_version.camelize

      # For response types, we use the response class directly as the parser
      # The type class knows how to parse the JSON response
      "Peddler::Types::#{api_class}::#{model[:model]}"
    end

    def parsing_logic
      return unless has_typed_response?

      model = response_model
      return unless model && model[:model]

      type_class = build_type_class_name(model[:model])

      case model[:type]
      when :response
        parse_response_type(type_class)
      when :single
        parse_single_type(type_class, model[:path])
      when :array
        parse_array_type(type_class, model[:path])
      else
        "response.parse"
      end
    end

    def build_type_class_name(model_name)
      api_class = api_name_with_version.camelize
      "Peddler::Types::#{api_class}::#{model_name}"
    end

    def parse_response_type(type_class)
      "#{type_class}.parse(response.parse)"
    end

    def parse_single_type(type_class, path)
      dig_path = build_dig_path(path)
      "#{type_class}.parse(response.parse.dig(#{dig_path}))"
    end

    def parse_array_type(type_class, path)
      if path.size == 2 && path.first == DEFAULT_PAYLOAD_KEY
        parse_nested_array(type_class, path.last)
      else
        parse_simple_array(type_class)
      end
    end

    def parse_nested_array(type_class, array_name)
      "(response.parse.dig(\"#{DEFAULT_PAYLOAD_KEY}\", \"#{array_name}\") || []).map { |item| #{type_class}.parse(item) }"
    end

    def parse_simple_array(type_class)
      "(response.parse.dig(\"#{DEFAULT_PAYLOAD_KEY}\") || []).map { |item| #{type_class}.parse(item) }"
    end

    def build_dig_path(path)
      path.map { |p| "\"#{p}\"" }.join(", ")
    end

    def use_ternary?
      return false unless has_typed_response?

      # Calculate the full ternary line length
      typed_response = parsing_logic || "response.parse"
      ternary_line = "typed? ? #{typed_response} : response"

      # Use ternary if it fits in 120 characters (with 8 spaces for indentation)
      ternary_line.length <= 112 # 120 chars - 8 spaces indentation
    end

    def name
      operation_id.underscore
    end

    def sandbox_test_case
      return unless static_sandbox?

      # Find the first successful response code (2xx)
      success_code = operation["responses"].keys.find { |code| code.start_with?("2") }
      return unless success_code

      sandbox_data = operation["responses"][success_code]["x-amzn-api-sandbox"]
      return unless sandbox_data&.key?("static")

      # Return the first static test case
      sandbox_data["static"].first
    end

    def sandbox_params
      test_case = sandbox_test_case
      return "" unless test_case

      request_params = test_case.dig("request", "parameters") || {}

      # Build parameter list in correct order
      method_params = parameters.select { |p| p["required"] }.map { |p| p["name"].underscore }

      param_values = method_params.map do |param_name|
        # Find the matching parameter in sandbox data
        sandbox_param = request_params.find { |k, _| k.underscore == param_name }

        if sandbox_param
          value = sandbox_param[1]["value"]
          # Handle arrays
          if value.is_a?(Array)
            value.inspect
          elsif value.is_a?(String)
            "\"#{value}\""
          else
            value
          end
        else
          # This shouldn't happen for required params in sandbox tests
          "nil"
        end
      end

      # Add optional parameters with sandbox values
      optional_sandbox_params = request_params.reject do |name, _|
        method_params.include?(name.underscore)
      end

      optional_sandbox_params.each do |name, param_data|
        value = param_data["value"]
        formatted_value = if value.is_a?(Array)
          value.inspect
        elsif value.is_a?(String)
          "\"#{value}\""
        else
          value
        end
        param_values << "#{name.underscore}: #{formatted_value}"
      end

      # Check if there's a body parameter in the test case
      if test_case.dig("request", "body")
        param_values << "body: #{test_case["request"]["body"].to_json}"
      end

      param_values.join(", ")
    end

    def typed_test_assertion
      test_case = sandbox_test_case
      return "" unless test_case && has_typed_response?

      model = response_model
      method_call = "api.sandbox.typed.#{name}(#{sandbox_params})"

      case model[:type]
      when :single
        type_class = "Peddler::Types::#{api_name_with_version.camelize}::#{model[:model]}"
        "result = #{method_call}\n\n        assert_instance_of(#{type_class}, result)"
      when :array
        type_class = "Peddler::Types::#{api_name_with_version.camelize}::#{model[:model]}"
        <<~ASSERTION
          results = #{method_call}

                assert_kind_of(Array, results)
                assert_instance_of(#{type_class}, results.first) unless results.empty?
        ASSERTION
      else
        ""
      end
    end

    # CAUTION: This method parses rate limits from human-readable documentation. This is inherently fragile. Amazon
    # could change their documentation format at any time without considering it a breaking change. However, this is the
    # only source for rate limit data in their OpenAPI specifications.
    #
    # Extracts the rate value (requests per second) from the usage plan table
    # Example table:
    # | Rate (requests per second) | Burst |
    # | ---- | ---- |
    # | 0.0167 | 20 |
    #
    # Returns: 0.0167 (rate value in requests per second)
    def rate_limit
      # This regex:
      # 1. Finds the "Usage Plan:" section
      # 2. Locates the table with Rate and Burst columns
      # 3. Extracts the rate value from the data row
      # This regex is robust and handles various table formats by looking for "Burst |" in the header and then
      # extracting the rate value from the data row. It works with both 2-column and 3-column tables.
      # Note: API models may use either literal \n strings or actual newline characters
      pattern = %r{
        Burst\s*\|                      # Find "Burst |" at end of table header
        (?:\\n|\n)                      # Either literal \n string or actual newline
        \|(?:\s*-+\s*\|){2,3}           # Separator line (2-3 columns of dashes)
        (?:\\n|\n)                      # Either literal \n string or actual newline
        (?:\|[^|]*){0,1}                # Optional first column (e.g., "Default" in 3-column format)
        \|\s*(\S+)\s*\|                 # Capture rate value (always before burst value)
        [^|]*\|                         # Skip to burst column
      }mx

      match = operation["description"].match(pattern)
      if match
        rate_value = match[1]
        # Handle "n" as a special case - indicates variable/dynamic rate limits
        # We return :unknown to signal that rate limiting exists but no default is provided
        # See: https://developer-docs.amazon.com/sp-api/docs/fulfillment-inbound-api-rate-limits
        return :unknown if rate_value.downcase == "n"

        rate_value.to_f
      elsif operation["description"].match?(/Usage\s+[Pp]lans?:/)
        # Fail when we can't extract rate limit but Usage Plan exists. This likely means Amazon changed their
        # documentation format.
        raise "Failed to extract rate limit for #{operation["operationId"]}. Usage Plan found in description but " \
          "regex failed to match. This usually means Amazon changed their documentation format."
      end
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
