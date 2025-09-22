# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/client_reference_detail"

module Peddler
  module Types
    module ShippingV2
      # The request schema for remove the Carrier Account associated with the provided merchant.
      UnlinkCarrierAccountRequest = Structure.new do
        # @return [Array<ClientReferenceDetail>]
        attribute(:client_reference_details, [ClientReferenceDetail], from: "clientReferenceDetails")

        # @return [String]
        attribute(:account_id, String, from: "accountId")
      end
    end
  end
end
