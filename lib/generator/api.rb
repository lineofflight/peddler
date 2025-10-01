# frozen_string_literal: true

require "json"
require "erb"

require "generator/config"
require "generator/logger"
require "generator/formatter"
require "generator/path"
require "generator/type_resolver"

module Generator
  class API
    include Formatter
    include Logger

    attr_reader :file

    def initialize(file)
      @file = file
    end

    def generate
      File.write(file_path, render)
    end

    def title
      split_long_comment_line(model["info"]["title"], base_indent: 4)
    end

    def description
      description = model["info"]["description"]
      description = convert_html_links_to_yard(description)
      description = convert_doc_links_to_full_url(description)

      split_long_comment_line(description, base_indent: 4)
    end

    def library_name
      "peddler/apis/#{name_with_version}"
    end

    def has_helper?
      File.exist?("lib/" + helper_library_name + ".rb")
    end

    def helper_class_name
      "Peddler::Helpers::#{name_with_version.camelize}"
    end

    def helper_library_name
      "peddler/helpers/#{name_with_version}"
    end

    def class_name
      name_with_version.camelize
    end

    def name
      file.split("/")[-2].tr("-", "_").sub(/(?:_api)?_model$/, "")
    end

    def version
      model["info"]["version"].tr("-", "_")
    end

    def name_with_version
      [name, version].join("_")
    end

    def operations
      @operations ||= begin
        ops = paths.flat_map { |path| path.operations(name_with_version) }.compact
        deduplicate_operations(ops)
      end
    end

    def type_names
      openapi_spec["definitions"]
        .select { |name, def_| def_["type"] == "object" && !TypeResolver::MONEY_TYPES.include?(name) && !def_["additionalProperties"] }
        .keys
        .sort
    end

    def paths
      model["paths"].map { |path, methods| Path.new(path, methods) }
    end

    def file_path
      File.join(Config::BASE_PATH, "lib/#{library_name}.rb")
    end

    def openapi_spec
      model
    end

    def github_model_filename
      parts = file.split("/")
      "#{parts[-2]}/#{parts[-1]}"
    end

    private

    def deduplicate_operations(ops)
      # Group by operation ID
      operation_map = ops.group_by { |op| op.operation["operationId"].underscore }

      # Find duplicates
      duplicates = operation_map.select { |_, ops| ops.size > 1 }

      if duplicates.any?
        duplicates.each do |method_name, ops|
          verbs = ops.map(&:verb).join(", ")
          logger.warn("Found duplicate operation in #{name_with_version}: #{method_name} (#{verbs})")
        end
      end

      # Handle duplicates
      duplicates.each do |method_name, ops|
        if name_with_version == "shipping_v2" && method_name == "link_carrier_account"
          # Special case for ShippingV2's link_carrier_account - choose POST version
          post_op = ops.find { |op| op.verb == "post" }
          operation_map[method_name] = [post_op] if post_op
        else
          # For any other duplicates, raise an error
          verbs = ops.map(&:verb).join(", ")
          raise "Error: Found duplicate operation '#{method_name}' in #{name_with_version} " \
            "with HTTP verbs: #{verbs}. Please handle this case specifically."
        end
      end

      # Return flattened list of operations with duplicates resolved
      operation_map.values.flatten
    end

    def render
      ERB.new(template, trim_mode: "-").result(binding)
    end

    def template
      File.read(Config.template_path("api"))
    end

    def model
      @model ||= JSON.parse(File.read(file))
    end
  end
end
