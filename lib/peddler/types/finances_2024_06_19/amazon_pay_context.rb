# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module Finances20240619
      # Additional information related to Amazon Pay.
      AmazonPayContext = Structure.new do
        # @return [String] Store name related to transaction.
        attribute?(:store_name, String, from: "storeName")

        # @return [String] Order type of the transaction.
        attribute?(:order_type, String, from: "orderType")

        # @return [String] Channel details of related transaction.
        attribute?(:channel, String)
      end
    end
  end
end
