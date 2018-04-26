# frozen_string_literal: true

require 'singleton'
require 'peddler/errors/error'

module Peddler
  module Errors
    # @api private
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
          return Errors.const_get(name) if Errors.const_defined?(name)
          Errors.const_set(name, Class.new(Error))
        end
      end

      private

      def with_mutex
        @mutex.synchronize { yield }
      end
    end
  end
end
