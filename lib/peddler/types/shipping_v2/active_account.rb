# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Active Account Details
      ActiveAccount = Structure.new do
        # @return [String]
        attribute?(:account_id, String, from: "accountId")

        # @return [String]
        attribute?(:carrier_id, String, from: "carrierId")
      end
    end
  end
end
