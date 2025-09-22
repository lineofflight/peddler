# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Indicates whether the carrier will pick up the package, and what fee is charged, if any.
      AvailableCarrierWillPickUpOption = Structure.new do
        # @return [String]
        attribute(:carrier_will_pick_up_option, String, from: "CarrierWillPickUpOption")

        # @return [Types::Money] The fee charged.
        attribute(:charge, Types::Money, from: "Charge")
      end
    end
  end
end
