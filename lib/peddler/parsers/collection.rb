require 'peddler/parsers/xml'

module Peddler
  module Parsers
    class Collection < XML
      include Enumerable

      def each
        raise NotImplementedError
      end

      def empty?
        count == 0
      end

      def inspect
        "#<#{self.class} (#{count})>"
      end

      alias :to_s :inspect
    end
  end
end
