# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # Request schema.
      CreateShipmentRequest = Structure.new do
        # @return [ShipmentRequestDetails] Shipment information required to create a shipment.
        attribute(:shipment_request_details, ShipmentRequestDetails, from: "ShipmentRequestDetails")

        # @return [String]
        attribute(:shipping_service_id, String, from: "ShippingServiceId")

        # @return [String] Hazardous materials options for a package. Consult the terms and conditions for each carrier
        #   for more information about hazardous materials.
        attribute?(:hazmat_type, String, from: "HazmatType")

        # @return [LabelFormatOptionRequest]
        attribute?(:label_format_option, LabelFormatOptionRequest, from: "LabelFormatOption")

        # @return [Array<AdditionalSellerInputs>] A list of additional seller inputs required to ship this shipment.
        attribute?(:shipment_level_seller_inputs_list, [AdditionalSellerInputs], from: "ShipmentLevelSellerInputsList")

        # @return [String] Identifies a shipping service order made by a carrier.
        attribute?(:shipping_service_offer_id, String, from: "ShippingServiceOfferId")
      end
    end
  end
end
