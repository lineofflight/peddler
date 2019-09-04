# frozen_string_literal: true

require 'excon'
require 'forwardable'
require 'peddler/errors/class_generator'
require 'peddler/errors/parser'

module Peddler
  module Errors
    # @api private
    class Builder
      extend Forwardable

      DIGIT_AS_FIRST_CHAR = /^\d/.freeze
      private_constant :DIGIT_AS_FIRST_CHAR

      def_delegator :error, :response

      def self.call(error)
        new(error).build
      end

      attr_reader :error

      def initialize(error)
        @error = error
      end

      def build
        parse_original_response
        return if no_error_response?
        return if bad_class_name?

        error_class.new(error_message, error)
      end

      private

      def bad_class_name?
        error_name.match?(DIGIT_AS_FIRST_CHAR)
      end

      def no_error_response?
        response.parse.nil?
      end

      def error_class
        ClassGenerator.call(error_name)
      end

      def error_name
        response.code
      end

      def error_message
        response.message
      end

      def parse_original_response
        error.instance_variable_set :@response, Parser.new(error.response)
      end
    end
  end
end
