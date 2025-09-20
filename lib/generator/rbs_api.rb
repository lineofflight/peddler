# frozen_string_literal: true

require "erb"
require "fileutils"
require "generator/config"
require "generator/formatter"
require "generator/parameter_builder"

module Generator
  class RBSApi
    include Formatter

    attr_reader :api, :api_name

    def initialize(api, api_name)
      @api = api
      @api_name = api_name
    end

    def generate
      FileUtils.mkdir_p(File.dirname(rbs_file_path))
      File.write(rbs_file_path, render_rbs)
    end

    def class_name
      api.class_name
    end

    def operations
      api.operations
    end

    private

    def build_parameters_list(operation)
      # Use the same ParameterBuilder as the Ruby generator to ensure consistency
      rate_limit = extract_rate_limit(operation)
      shared_params = operation.path.respond_to?(:parameters) ? operation.path.parameters : []
      ParameterBuilder.new(operation.operation, shared_params, rate_limit).build
    end

    def extract_rate_limit(operation)
      # Extract rate limit from operation description if present
      description = operation.operation["description"] || ""
      if description =~ /\|\s*([\d.]+)\s*\|.*?\|\s*\d+\s*\|/
        ::Regexp.last_match(1).to_f
      end
    end

    def rbs_file_path
      File.join(Config::BASE_PATH, "sig/peddler/apis/#{api_name}.rbs")
    end

    def render_operation(operation)
      # Skip operations without an operation_id
      return unless operation.operation_id

      params = render_parameters(operation)

      method_name = operation.operation_id.underscore

      <<~RBS.strip
        def #{method_name}: (#{params}) -> Peddler::Response
      RBS
    end

    def render_parameters(operation)
      positional_params = []
      keyword_params = []

      # Build parameters list to match Ruby generator's ordering
      params = build_parameters_list(operation)

      # Process parameters in the same order as Ruby generator
      params.each do |param|
        param_name = param["name"]&.underscore
        type = if param["in"] == "body" || param_name&.end_with?("_request", "_request_body", "_body")
          "untyped"
        else
          parameter_rbs_type(param)
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

    def parameter_rbs_type(param)
      case param["type"]
      when "string"
        "String"
      when "integer"
        "Integer"
      when "boolean"
        "bool"
      when "number"
        "Float"
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

    def render_rbs
      ERB.new(rbs_template, trim_mode: "-").result(binding)
    end

    def rbs_template
      <<~ERB
        module Peddler
          module APIs
            class <%= class_name %> < API
        <% operations.each do |operation| -%>
        <% rendered = render_operation(operation) -%>
        <% if rendered -%>
              <%= rendered %>
        <% end -%>
        <% end -%>
            end
          end
        end
      ERB
    end
  end
end
