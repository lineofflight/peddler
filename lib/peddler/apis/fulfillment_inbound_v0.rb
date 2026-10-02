# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Fulfillment Inbound
    #
    # The Selling Partner API for Fulfillment Inbound lets you create applications that create and update inbound
    # shipments of inventory to Amazon's fulfillment network.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/fulfillment-inbound-api-model/fulfillmentInboundV0.json
    module FulfillmentInboundV0
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "fulfillment_inbound_v0.get_bill_of_lading" => -> { GetBillOfLadingResponse },
        "fulfillment_inbound_v0.get_labels" => -> { GetLabelsResponse },
        "fulfillment_inbound_v0.get_prep_instructions" => -> { GetPrepInstructionsResponse },
        "fulfillment_inbound_v0.get_shipment_items" => -> { GetShipmentItemsResponse },
        "fulfillment_inbound_v0.get_shipment_items_by_shipment_id" => -> { GetShipmentItemsResponse },
        "fulfillment_inbound_v0.get_shipments" => -> { GetShipmentsResponse },
      }.freeze
    end
  end
end
