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

      def to_h
        map { |el| el.respond_to?(:to_h) ? el.to_h : el }
      end

      alias :to_s :inspect
    end
  end
end
