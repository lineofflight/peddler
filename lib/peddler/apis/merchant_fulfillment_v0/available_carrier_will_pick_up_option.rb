# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # Indicates whether the carrier will pick up the package, and what fee is charged, if any.
      AvailableCarrierWillPickUpOption = Structure.new do
        # @return [String]
        attribute(:carrier_will_pick_up_option, String, from: "CarrierWillPickUpOption")

        # @return [Money] The fee charged.
        attribute(:charge, Money, from: "Charge")
      end
    end
  end
end
