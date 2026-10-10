# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # Carrier Account details used to fetch rates.
      CarrierAccount = Structure.new do
        attribute(:carrier_account_id, String, null: false, from: "carrierAccountId")

        attribute(:carrier_id, String, null: false, from: "carrierId")
      end
    end
  end
end
