# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/merchant_fulfillment_v0/address"
require "peddler/types/merchant_fulfillment_v0/weight"
require "peddler/types/merchant_fulfillment_v0/length"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Additional information required to purchase shipping.
      AdditionalSellerInput = Structure.new do
        # @return [String] The data type of the additional information.
        attribute(:data_type, String, from: "DataType")

        # @return [String] The value when the data type is string.
        attribute(:value_as_string, String, from: "ValueAsString")

        # @return [:boolean] The value when the data type is boolean.
        attribute(:value_as_boolean, :boolean, from: "ValueAsBoolean")

        # @return [Integer] The value when the data type is integer.
        attribute(:value_as_integer, Integer, from: "ValueAsInteger")

        # @return [String] The value when the data type is a date-time formatted string.
        attribute(:value_as_timestamp, String, from: "ValueAsTimestamp")

        # @return [Address]
        attribute(:value_as_address, Address, from: "ValueAsAddress")

        # @return [Weight]
        attribute(:value_as_weight, Weight, from: "ValueAsWeight")

        # @return [Length]
        attribute(:value_as_dimension, Length, from: "ValueAsDimension")

        # @return [Money]
        attribute(:value_as_currency, Money, from: "ValueAsCurrency")
      end
    end
  end
end
