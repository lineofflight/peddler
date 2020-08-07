# frozen_string_literal: true

require 'singleton'
require 'peddler/errors/error'

module Peddler
  module Errors
    # @!visibility private
    class ClassGenerator
      include Singleton

      def self.call(name)
        instance.generate(name)
      end

      def initialize
        @mutex = Mutex.new
      end

      def generate(name)
        with_mutex do
          if Errors.const_defined?(name)
            error = Errors.const_get(name)
            return error if error <= Error

            raise TypeError, "#{name} must be a Peddler::Errors::Error"
          end

          Errors.const_set(name, Class.new(Error))
        end
      end

      private

      def with_mutex(&block)
        @mutex.synchronize(&block)
      end
    end
  end
end
