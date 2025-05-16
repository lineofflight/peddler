# frozen_string_literal: true

require "generator/utils"
require "generator/operation"
require "uri"

module Generator
  class Path
    include Utils

    HTTP_METHODS = ["delete", "get", "patch", "post", "put"].freeze

    attr_reader :methods

    def initialize(path, methods)
      @path = path
      @methods = methods
    end

    def operations
      methods.select { |k, _| HTTP_METHODS.include?(k) }.map do |method, operation|
        Operation.new(self, method, operation)
      end
    end

    def to_s
      path
    end

    def path
      @path.gsub(/\{([^}]+)\}/) do
        "\#{URI.encode_uri_component(#{snakecase(Regexp.last_match(1))})}"
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
