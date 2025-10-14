# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class EasyShip20220323
      # A list of serial numbers for the items associated with the `OrderItemId` value.
      class OrderItemSerialNumbers < Array
        class << self
          def parse(array)
            new(array)
          end
        end
      end
    end
  end
end
