# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Finances20240619
      # Additional information related to Amazon Pay.
      AmazonPayContext = Structure.new do
        # @return [String] Channel details of related transaction.
        attribute?(:channel, String)

        # @return [String] The transaction's order type.
        attribute?(:order_type, String, from: "orderType")

        # @return [String] The name of the store that is related to the transaction.
        attribute?(:store_name, String, from: "storeName")
      end
    end
  end
end
