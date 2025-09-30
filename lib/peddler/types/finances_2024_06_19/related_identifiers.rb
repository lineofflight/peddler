# frozen_string_literal: true

require "peddler/types/finances_2024_06_19/related_identifier"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module Finances20240619
      # Related business identifiers of the transaction.
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
