require 'peddler/parsers/base'
require 'peddler/parsers/csv'

module Peddler
  module Parsers
    class Text < Base
      # Pass Windows-31J if content is in Japanese.
      def to_csv(encoding = 'ISO-8859-1')
        CSV.new(document)
      end
    end
  end
end
