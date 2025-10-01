# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v2/carrier_account_input"

module Peddler
  module Types
    module ShippingV2
      # Info About Linkable Account Type
      LinkableAccountType = Structure.new do
        # @return [String]
        attribute?(:account_type, String, from: "accountType")

        # @return [Array<CarrierAccountInput>]
        attribute?(:carrier_account_inputs, [CarrierAccountInput], from: "carrierAccountInputs")
      end
    end
  end
end
