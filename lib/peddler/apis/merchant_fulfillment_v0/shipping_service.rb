# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # A shipping service offer made by a carrier.
      ShippingService = Structure.new do
        # @return [String] The name of the carrier.
        attribute(:carrier_name, String, from: "CarrierName")

        # @return [Money] The amount that the carrier will charge for the shipment.
        attribute(:rate, Money, from: "Rate")

        # @return [Money] The amount that the carrier will charge for the shipment with adjustments.
        attribute(:rate_with_adjustments, Money, from: "RateWithAdjustments")

        # @return [:boolean] When true, additional seller inputs are required.
        attribute(:requires_additional_seller_inputs, :boolean, from: "RequiresAdditionalSellerInputs")

        # @return [String] The date that the carrier will ship the package.
        attribute(:ship_date, String, from: "ShipDate")

        # @return [String]
        attribute(:shipping_service_id, String, from: "ShippingServiceId")

        # @return [String] A plain text representation of a carrier's shipping service. For example, "UPS Ground" or
        # "FedEx Standard Overnight".
        attribute(:shipping_service_name, String, from: "ShippingServiceName")

        # @return [String] An Amazon-defined shipping service offer identifier.
        attribute(:shipping_service_offer_id, String, from: "ShippingServiceOfferId")

        # @return [ShippingServiceOptions] Extra services offered by the carrier.
        attribute(:shipping_service_options, ShippingServiceOptions, from: "ShippingServiceOptions")

        # @return [Array<RateItem>] A list of adjustments applied to a shipping service.
        attribute?(:adjustment_item_list, [RateItem], from: "AdjustmentItemList")

        # @return [Array<LabelFormatOption>]
        attribute?(:available_format_options_for_label, [LabelFormatOption], from: "AvailableFormatOptionsForLabel")

        # @return [Array<LabelFormat>]
        attribute?(:available_label_formats, Array, from: "AvailableLabelFormats")

        # @return [AvailableShippingServiceOptions]
        attribute?(:available_shipping_service_options, AvailableShippingServiceOptions, from: "AvailableShippingServiceOptions")

        # @return [Benefits]
        attribute?(:benefits, Benefits, from: "Benefits")

        # @return [String] The earliest date by which the shipment will be delivered.
        attribute?(:earliest_estimated_delivery_date, String, from: "EarliestEstimatedDeliveryDate")

        # @return [String] The latest date by which the shipment will be delivered.
        attribute?(:latest_estimated_delivery_date, String, from: "LatestEstimatedDeliveryDate")
      end
    end
  end
end
