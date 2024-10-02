# frozen_string_literal: true

require "generator/config"
require "generator/utils"
require "generator/operation"

module Generator
  class Path
    include Utils

    attr_reader :methods

    def initialize(path, methods)
      @path = path
      @methods = methods
    end

    def operations
      methods.select { |k, _| Config::HTTP_METHODS.include?(k) }.map do |method, operation|
        Operation.new(self, method, operation)
      end
    end

    def path
      @path.gsub(/\{([^}]+)\}/) do
        "\#{#{snakecase(Regexp.last_match(1))}}"
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
