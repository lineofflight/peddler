# frozen_string_literal: true

require_relative "response_model"

module Generator
  class Operation
    attr_reader :verb

    def initialize(verb, operation)
      @verb = verb
      @operation = operation
    end

    def operation_id
      operation["operationId"]
    end

    def has_typed_response?
      !!operation_id && response_model[:model]
    end

    def response_model
      @response_model ||= ResponseModel.new(operation).build
    end

    private

    attr_reader :operation
  end
end
