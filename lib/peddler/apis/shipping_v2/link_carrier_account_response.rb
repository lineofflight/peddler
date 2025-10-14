# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The Response for the LinkCarrierAccount operation.
      LinkCarrierAccountResponse = Structure.new do
        # @return [String]
        attribute?(:account_id, String, from: "accountId")

        # @return [String]
        attribute?(:registration_status, String, from: "registrationStatus")
      end
    end
  end
end
