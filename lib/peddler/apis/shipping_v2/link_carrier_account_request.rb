# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The request schema for verify and add the merchant's account with a certain carrier.
      LinkCarrierAccountRequest = Structure.new do
        attribute(:carrier_account_attributes, [CarrierAccountAttribute], null: false, from: "carrierAccountAttributes")

        attribute(:carrier_account_type, String, null: false, from: "carrierAccountType")

        attribute?(:client_reference_details, [ClientReferenceDetail], from: "clientReferenceDetails")

        attribute?(:encrypted_carrier_account_attributes, [CarrierAccountAttribute], from: "encryptedCarrierAccountAttributes")
      end
    end
  end
end
