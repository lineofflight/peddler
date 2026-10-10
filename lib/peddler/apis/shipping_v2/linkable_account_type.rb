# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # Info About Linkable Account Type
      LinkableAccountType = Structure.new do
        attribute?(:account_type, String, from: "accountType")

        attribute?(:carrier_account_inputs, [CarrierAccountInput], from: "carrierAccountInputs")
      end
    end
  end
end
