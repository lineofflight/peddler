# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # Request schema.
      CreateShipmentRequest = Structure.new do
        # Shipment information required to create a shipment.
        attribute(:shipment_request_details, ShipmentRequestDetails, null: false, from: "ShipmentRequestDetails")

        attribute(:shipping_service_id, String, null: false, from: "ShippingServiceId")

        # Hazardous materials options for a package. Consult the terms and conditions for each carrier for more
        # information about hazardous materials. Known values: `None`, `LQHazmat`.
        attribute?(:hazmat_type, String, from: "HazmatType")

        attribute?(:label_format_option, LabelFormatOptionRequest, from: "LabelFormatOption")

        # A list of additional seller inputs required to ship this shipment.
        attribute?(:shipment_level_seller_inputs_list, [AdditionalSellerInputs], from: "ShipmentLevelSellerInputsList")

        # Identifies a shipping service order made by a carrier.
        attribute?(:shipping_service_offer_id, String, from: "ShippingServiceOfferId")
      end
    end
  end
end
