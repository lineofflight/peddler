# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShippingV1
      # The account related with the shipment.
      Party = Structure.new do
        # @return [String]
        attribute?(:account_id, String, from: "accountId")
      end
    end
  end
end
