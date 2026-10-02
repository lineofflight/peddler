# frozen_string_literal: true

require_relative "../builders/operation"

module Generator
  class Path
    HTTP_METHODS = ["delete", "get", "patch", "post", "put"].freeze

    attr_reader :path, :methods

    def initialize(path, methods)
      @path = path
      @methods = methods
    end

    def operations
      methods.select { |k, _| HTTP_METHODS.include?(k) }.map do |method, operation|
        Operation.new(method, operation)
      end
    end
  end
end
