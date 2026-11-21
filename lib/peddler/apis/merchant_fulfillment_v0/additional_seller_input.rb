# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # Additional information required to purchase shipping.
      AdditionalSellerInput = Structure.new do
        # The data type of the additional information.
        attribute?(:data_type, String, from: "DataType")

        attribute?(:value_as_address, Address, from: "ValueAsAddress")

        # The value when the data type is boolean.
        attribute?(:value_as_boolean, :boolean, from: "ValueAsBoolean")

        attribute?(:value_as_currency, Money, from: "ValueAsCurrency")

        attribute?(:value_as_dimension, Length, from: "ValueAsDimension")

        # The value when the data type is integer.
        attribute?(:value_as_integer, Integer, from: "ValueAsInteger")

        # The value when the data type is string.
        attribute?(:value_as_string, String, from: "ValueAsString")

        # The value when the data type is a date-time formatted string.
        attribute?(:value_as_timestamp, String, from: "ValueAsTimestamp")

        attribute?(:value_as_weight, Weight, from: "ValueAsWeight")
      end
    end
  end
end
