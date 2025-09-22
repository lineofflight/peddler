# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/merchant_fulfillment_v0/shipping_service_options"
require "peddler/types/merchant_fulfillment_v0/available_shipping_service_options"
require "peddler/types/merchant_fulfillment_v0/label_format_option"
require "peddler/types/merchant_fulfillment_v0/benefits"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # A shipping service offer made by a carrier.
      ShippingService = Structure.new do
        # @return [String] A plain text representation of a carrier's shipping service. For example, "UPS Ground" or
        # "FedEx Standard Overnight".
        attribute(:shipping_service_name, String, from: "ShippingServiceName")

        # @return [String] The name of the carrier.
        attribute(:carrier_name, String, from: "CarrierName")

        # @return [String]
        attribute(:shipping_service_id, String, from: "ShippingServiceId")

        # @return [String] An Amazon-defined shipping service offer identifier.
        attribute(:shipping_service_offer_id, String, from: "ShippingServiceOfferId")

        # @return [String] The date that the carrier will ship the package.
        attribute(:ship_date, String, from: "ShipDate")

        # @return [String] The earliest date by which the shipment will be delivered.
        attribute(:earliest_estimated_delivery_date, String, from: "EarliestEstimatedDeliveryDate")

        # @return [String] The latest date by which the shipment will be delivered.
        attribute(:latest_estimated_delivery_date, String, from: "LatestEstimatedDeliveryDate")

        # @return [Money] The amount that the carrier will charge for the shipment.
        attribute(:rate, Money, from: "Rate")

        # @return [ShippingServiceOptions] Extra services offered by the carrier.
        attribute(:shipping_service_options, ShippingServiceOptions, from: "ShippingServiceOptions")

        # @return [AvailableShippingServiceOptions]
        attribute(:available_shipping_service_options, AvailableShippingServiceOptions, from: "AvailableShippingServiceOptions")

        # @return [Array<LabelFormat>]
        attribute(:available_label_formats, Array, from: "AvailableLabelFormats")

        # @return [Array<LabelFormatOption>]
        attribute(:available_format_options_for_label, [LabelFormatOption], from: "AvailableFormatOptionsForLabel")

        # @return [:boolean] When true, additional seller inputs are required.
        attribute(:requires_additional_seller_inputs, :boolean, from: "RequiresAdditionalSellerInputs")

        # @return [Benefits]
        attribute(:benefits, Benefits, from: "Benefits")
      end
    end
  end
end
