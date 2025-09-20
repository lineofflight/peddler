# frozen_string_literal: true

module Peddler
  module Types
    module OrdersV0
      # For partial shipment status updates, the list of order items and quantities to be updated.
      class OrderItems < Array
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
