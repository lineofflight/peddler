# frozen_string_literal: true

require "generator/operation"

module Generator
  class Path
    HTTP_METHODS = ["delete", "get", "patch", "post", "put"].freeze

    attr_reader :methods

    def initialize(path, methods)
      @path = path
      @methods = methods
    end

    def operations(api_name_with_version = nil, specification = nil)
      methods.select { |k, _| HTTP_METHODS.include?(k) }.map do |method, operation|
        Operation.new(self, method, operation, api_name_with_version, specification)
      end
    end

    def to_s
      path
    end

    def path
      # Use atomic grouping (?>...) to prevent ReDoS
      @path.gsub(/\{(?>([^}]+))\}/) do
        "\#{percent_encode(#{Regexp.last_match(1).underscore})}"
      end
    end

    def parameters
      methods.fetch("parameters", [])
    end

    def has_dynamic_sandbox?
      !!methods.dig("x-amzn-api-sandbox", "dynamic")
    end

    def sandbox_only?
      methods.key?("x-amzn-api-sandbox-only")
    end
  end
end
