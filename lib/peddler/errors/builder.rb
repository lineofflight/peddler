# frozen_string_literal: true

require 'singleton'
require 'peddler/errors/error'

module Peddler
  module Errors
    # @api private
    class Builder
      include Singleton

      def self.build(name)
        instance.build(name)
      end

      def initialize
        @mutex = Mutex.new
      end

      def build(name)
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
