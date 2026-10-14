# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # Info About Linkable Account Type
      LinkableAccountType = Structure.new do
        # @return [String] Known values: `SHIPPER_ACCOUNT`, `SHIPPER_ACCOUNT_WITH_INVOICE`, `AMAZON_ACCOUNT`.
        attribute?(:account_type, String, from: "accountType")

        # @return [Array<CarrierAccountInput>]
        attribute?(:carrier_account_inputs, [CarrierAccountInput], from: "carrierAccountInputs")
      end
    end
  end
end
