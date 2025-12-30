# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FinancesV0
      # A list of `RemovalShipmentItem`.
      class RemovalShipmentItemList < Array
        class << self
          def parse(array)
            new(array.map { |item| RemovalShipmentItem.parse(item) })
          end
        end
      end
    end
  end
end
