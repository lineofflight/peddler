# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # The Response for the LinkCarrierAccount operation.
      LinkCarrierAccountResponse = Structure.new do
        # @return [String]
        attribute(:registration_status, String, from: "registrationStatus")

        # @return [String]
        attribute(:account_id, String, from: "accountId")
      end
    end
  end
end
