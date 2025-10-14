# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ExternalFulfillmentInventory20240911
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
