# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The request schema for remove the Carrier Account associated with the provided merchant.
      UnlinkCarrierAccountRequest = Structure.new do
        attribute?(:account_id, String, from: "accountId")

        attribute?(:client_reference_details, [ClientReferenceDetail], from: "clientReferenceDetails")
      end
    end
  end
end
