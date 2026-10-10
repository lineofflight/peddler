# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # Indicates whether the carrier will pick up the package, and what fee is charged, if any.
      AvailableCarrierWillPickUpOption = Structure.new do
        attribute(:carrier_will_pick_up_option, String, null: false, from: "CarrierWillPickUpOption")

        # The fee charged.
        attribute(:charge, Money, null: false, from: "Charge")
      end
    end
  end
end
