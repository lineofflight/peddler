# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module OrdersV0
      # For partial shipment status updates, the list of order items and quantities to be updated.
      class OrderItems < Array
        class << self
          def parse(array)
            new(array)
          end
        end
      end
    end
  end
end
