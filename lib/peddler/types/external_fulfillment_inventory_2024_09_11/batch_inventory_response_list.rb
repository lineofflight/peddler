# frozen_string_literal: true

require "peddler/types/external_fulfillment_inventory_2024_09_11/inventory_response"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ExternalFulfillmentInventory20240911
      # A list of inventory request responses.
      class BatchInventoryResponseList < Array
        class << self
          def parse(array)
            new(array.map { |item| InventoryResponse.parse(item) })
          end
        end
      end
    end
  end
end
