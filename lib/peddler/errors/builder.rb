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
        Errors.const_set name, Class.new(Error)
      end
    end
  end
end
