# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v2/client_reference_detail"

module Peddler
  module Types
    module ShippingV2
      # The request schema for remove the Carrier Account associated with the provided merchant.
      UnlinkCarrierAccountRequest = Structure.new do
        # @return [String]
        attribute?(:account_id, String, from: "accountId")

        # @return [Array<ClientReferenceDetail>]
        attribute?(:client_reference_details, [ClientReferenceDetail], from: "clientReferenceDetails")
      end
    end
  end
end
