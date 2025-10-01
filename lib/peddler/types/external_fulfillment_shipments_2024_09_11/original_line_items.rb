# frozen_string_literal: true

require "peddler/types/external_fulfillment_shipments_2024_09_11/original_line_item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # The line items from the original shipment that corresponds to this shipment.
      class OriginalLineItems < Array
        class << self
          def parse(array)
            new(array.map { |item| OriginalLineItem.parse(item) })
          end
        end
      end
    end
  end
end
