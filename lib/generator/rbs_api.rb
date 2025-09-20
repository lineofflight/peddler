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
      # Reuse the Operation's parameters method which already includes rate_limit via ParameterBuilder
      operation.parameters
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

        # Special handling for rate_limit parameter
        if param_name == "rate_limit"
          keyword_params << "?rate_limit: Float"
          next
        end

        type = if param["in"] == "body" || param_name&.end_with?("_request", "_request_body", "_body")
          # TODO: Eventually we should type body parameters properly based on their schema
          "Hash"
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

    def parameter_rbs_type(param, nullable: false)
      base_type = case param["type"]
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
