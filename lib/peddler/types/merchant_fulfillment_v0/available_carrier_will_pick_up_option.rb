# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/merchant_fulfillment_v0/currency_amount"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Indicates whether the carrier will pick up the package, and what fee is charged, if any.
      AvailableCarrierWillPickUpOption = Structure.new do
        # @return [String]
        attribute(:carrier_will_pick_up_option, String, from: "CarrierWillPickUpOption")

        # @return [CurrencyAmount] The fee charged.
        attribute(:charge, CurrencyAmount, from: "Charge")
      end
    end
  end
end
