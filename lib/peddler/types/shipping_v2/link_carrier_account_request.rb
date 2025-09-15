# frozen_string_literal: true

require "peddler/types/shipping_v2/client_reference_detail"
require "peddler/types/shipping_v2/carrier_account_attribute"

module Peddler
  module Types
    module ShippingV2
      # The request schema for verify and add the merchant's account with a certain carrier.
      LinkCarrierAccountRequest = Structure.new do
        # @return [Array<ClientReferenceDetail>]
        attribute(:client_reference_details, [ClientReferenceDetail], from: "clientReferenceDetails")

        # @return [String]
        attribute(:carrier_account_type, String, from: "carrierAccountType")

        # @return [Array<CarrierAccountAttribute>]
        attribute(:carrier_account_attributes, [CarrierAccountAttribute], from: "carrierAccountAttributes")

        # @return [Array<CarrierAccountAttribute>]
        attribute(:encrypted_carrier_account_attributes, [CarrierAccountAttribute], from: "encryptedCarrierAccountAttributes")
      end
    end
  end
end
