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

      def build(name)
        return Errors.const_get(name) if Errors.const_defined?(name)
        Errors.const_set(name, Class.new(Error))
      end
    end
  end
end
