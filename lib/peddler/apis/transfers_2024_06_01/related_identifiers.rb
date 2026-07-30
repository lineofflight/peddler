# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class Transfers20240601
      # Related business identifiers of the payout.
      class RelatedIdentifiers < Array
        class << self
          def parse(array)
            new(array.map { |item| RelatedIdentifier.parse(item) })
          end
        end
      end
    end
  end
end
