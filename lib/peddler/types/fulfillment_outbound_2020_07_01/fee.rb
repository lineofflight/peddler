# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Fee type and cost.
      Fee = Structure.new do
        # @return [Money] The amount of the fee.
        attribute(:amount, Money)

        # @return [String] The type of fee.
        attribute(:name, String)
      end
    end
  end
end
