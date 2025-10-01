# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "peddler/types/merchant_fulfillment_v0/address"
require "peddler/types/merchant_fulfillment_v0/length"
require "peddler/types/merchant_fulfillment_v0/weight"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Additional information required to purchase shipping.
      AdditionalSellerInput = Structure.new do
        # @return [String] The data type of the additional information.
        attribute?(:data_type, String, from: "DataType")

        # @return [Address]
        attribute?(:value_as_address, Address, from: "ValueAsAddress")

        # @return [:boolean] The value when the data type is boolean.
        attribute?(:value_as_boolean, :boolean, from: "ValueAsBoolean")

        # @return [Money]
        attribute?(:value_as_currency, Money, from: "ValueAsCurrency")

        # @return [Length]
        attribute?(:value_as_dimension, Length, from: "ValueAsDimension")

        # @return [Integer] The value when the data type is integer.
        attribute?(:value_as_integer, Integer, from: "ValueAsInteger")

        # @return [String] The value when the data type is string.
        attribute?(:value_as_string, String, from: "ValueAsString")

        # @return [String] The value when the data type is a date-time formatted string.
        attribute?(:value_as_timestamp, String, from: "ValueAsTimestamp")

        # @return [Weight]
        attribute?(:value_as_weight, Weight, from: "ValueAsWeight")
      end
    end
  end
end
