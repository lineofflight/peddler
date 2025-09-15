# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/currency_amount"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Extra services provided by a carrier.
      ShippingServiceOptions = Structure.new do
        # @return [String] The delivery confirmation level.
        attribute(:delivery_experience, String, from: "DeliveryExperience")

        # @return [CurrencyAmount] The declared value of the shipment. The carrier uses this value to determine the
        # amount to use to insure the shipment. If `DeclaredValue` is greater than the carrier's minimum insurance
        # amount, the seller is charged for the additional insurance, as determined by the carrier. For information
        # about optional insurance coverage, refer to Seller Central Help:
        # [UK](https://sellercentral.amazon.co.uk/gp/help/200204080),
        # [US](https://sellercentral.amazon.com/gp/help/200204080).
        attribute(:declared_value, CurrencyAmount, from: "DeclaredValue")

        # @return [:boolean] When true, the carrier will pick up the package. Note: Scheduled carrier pickup is
        # available only using Dynamex (US), DPD (UK), and Royal Mail (UK).
        attribute(:carrier_will_pick_up, :boolean, from: "CarrierWillPickUp")

        # @return [String]
        attribute(:carrier_will_pick_up_option, String, from: "CarrierWillPickUpOption")

        # @return [String] The seller's preferred label format.
        attribute(:label_format, String, from: "LabelFormat")
      end
    end
  end
end
