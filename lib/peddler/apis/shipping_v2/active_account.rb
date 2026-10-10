# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # Active Account Details
      ActiveAccount = Structure.new do
        attribute?(:account_id, String, from: "accountId")

        attribute?(:carrier_id, String, from: "carrierId")
      end
    end
  end
end
