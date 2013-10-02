module Peddler
  module Parsers
    class Base
      def self.handle?(type)
        raise NotImplementedError
      end

      attr :document

      def initialize(document)
        @document = document
      end
    end
  end
end
