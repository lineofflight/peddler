# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ExternalFulfillmentInventory20240911
      # A list of inventory requests.
      class BatchInventoryRequestList < Array
        class << self
          def parse(array)
            new(array.map { |item| InventoryRequest.parse(item) })
          end
        end
      end
    end
  end
end
