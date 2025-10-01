# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module Finances20240619
      # Additional information related to Amazon Pay.
      AmazonPayContext = Structure.new do
        # @return [String] Channel details of related transaction.
        attribute?(:channel, String)

        # @return [String] Order type of the transaction.
        attribute?(:order_type, String, from: "orderType")

        # @return [String] Store name related to transaction.
        attribute?(:store_name, String, from: "storeName")
      end
    end
  end
end
