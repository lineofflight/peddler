# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Carrier Account details used to fetch rates.
      CarrierAccount = Structure.new do
        # @return [String]
        attribute(:carrier_account_id, String, from: "carrierAccountId")

        # @return [String]
        attribute(:carrier_id, String, from: "carrierId")
      end
    end
  end
end
