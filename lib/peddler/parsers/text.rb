require 'peddler/parsers/base'

module Peddler
  module Parsers
    class Text < Base
      def self.handle?(type)
        type == :txt
      end

      alias :to_s :document
    end
  end
end
