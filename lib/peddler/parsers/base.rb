module Peddler
  module Parsers
    class Base
      def self.xml?
        false
      end

      attr :document

      def initialize(document)
        @document = document
      end
    end
  end
end
