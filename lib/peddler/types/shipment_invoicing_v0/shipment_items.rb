# frozen_string_literal: true

require "peddler/types/shipment_invoicing_v0/shipment_item"

module Peddler
  module Types
    module ShipmentInvoicingV0
      # A list of shipment items.
      class ShipmentItems < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ShipmentItem.parse(item) })
          end
        end
      end
    end
  end
end
