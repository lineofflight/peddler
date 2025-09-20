# frozen_string_literal: true

module Peddler
  module Types
    module EasyShip20220323
      # A list of serial numbers for the items associated with the `OrderItemId` value.
      class OrderItemSerialNumbers < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array)
          end
        end
      end
    end
  end
end
