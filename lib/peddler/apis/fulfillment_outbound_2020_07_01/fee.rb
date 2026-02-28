# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # Fee type and cost.
      Fee = Structure.new do
        # @return [Money] The amount of the fee.
        attribute(:amount, Money, null: false)

        # @return [String] The type of fee.
        attribute(:name, String, null: false)
      end
    end
  end
end
