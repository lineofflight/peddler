require 'peddler/parsers/base'

module Peddler
  module Parsers
    class XML < Base
      def self.handle?(type)
        type == :xml
      end

      def at_xpath(path)
        document.at_xpath(with_namespace(path))
      end

      def xpath(path)
        document.xpath(with_namespace(path))
      end

      private

      def with_namespace(path)
        path.split('/').map { |attr| "xmlns:#{attr}" }.join('/')
      end
    end
  end
end
