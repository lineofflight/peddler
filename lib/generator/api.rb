# frozen_string_literal: true

require "json"
require "erb"

require "generator/config"
require "generator/formatter"
require "generator/utils"
require "generator/path"

module Generator
  class API
    include Formatter
    include Utils

    OBSOLETE_APIS = ["reports_2020_09_04", "feeds_2020_09_04"]

    attr_reader :file

    def initialize(file)
      @file = file
    end

    def generate
      return if obsolete?

      handle_duplicate_operations
      File.write(file_path, render)
    end

    def title
      split_long_comment_line(model["info"]["title"], base_indent: 4)
    end

    def description
      description = model["info"]["description"]
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
      "Peddler::Helpers::#{pascalcase(name_with_version)}"
    end

    def helper_library_name
      "peddler/helpers/#{name_with_version}"
    end

    def class_name
      pascalcase(name_with_version)
    end

    def name_with_version
      [name, version].join("_")
    end

    def obsolete?
      OBSOLETE_APIS.any? { |api| name_with_version.include?(api) }
    end

    def operations
      @operations ||= paths.flat_map(&:operations).compact
    end

    def paths
      model["paths"].map { |path, methods| Path.new(path, methods) }
    end

    def file_path
      File.join(Config::BASE_PATH, "lib/#{library_name}.rb")
    end

    private

    def handle_duplicate_operations
      # Group by operation ID
      operation_map = operations.group_by { |op| snakecase(op.operation["operationId"]) }

      # Find duplicates
      duplicates = operation_map.select { |_, ops| ops.size > 1 }

      if duplicates.any?
        puts "Warning: found duplicate operations in #{name_with_version}:"
        duplicates.each do |method_name, ops|
          verbs = ops.map(&:verb).join(", ")
          puts "#{method_name} (#{verbs})"
        end
      end

      # Handle duplicates
      duplicates.each do |method_name, ops|
        if name_with_version == "shipping_v2" && method_name == "link_carrier_account"
          # Special case for ShippingV2's link_carrier_account - choose POST version
          post_op = ops.find { |op| op.verb == "post" }
          if post_op
            # Replace all occurrences with just the POST version
            operation_map[method_name] = [post_op]
          end
        else
          # For any other duplicates, raise an error
          verbs = ops.map(&:verb).join(", ")
          raise "Error: Found duplicate operation '#{method_name}' in #{name_with_version} " \
            "with HTTP verbs: #{verbs}. Please handle this case specifically."
        end
      end

      # Create flattened list of operations with duplicates resolved
      @operations = operation_map.values.flatten
    end

    def render
      ERB.new(template, trim_mode: "-").result(binding)
    end

    def template
      File.read(Config.template_path("api"))
    end

    def name
      file.split("/")[-2].tr("-", "_").sub(/(?:_api)?_model$/, "")
    end

    def version
      model["info"]["version"].tr("-", "_")
    end

    def model
      @model ||= JSON.parse(File.read(file))
    end
  end
end
