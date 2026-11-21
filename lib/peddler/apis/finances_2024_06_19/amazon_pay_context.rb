# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Finances20240619
      # Additional information related to Amazon Pay.
      AmazonPayContext = Structure.new do
        # The channel of the transaction. For example: `MFN`.
        attribute?(:channel, String)

        # The order type of the transaction.
        attribute?(:order_type, String, from: "orderType")

        # The name of the store that is related to the transaction.
        attribute?(:store_name, String, from: "storeName")
      end
    end
  end
end
