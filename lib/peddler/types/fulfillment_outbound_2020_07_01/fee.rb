# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Fee type and cost.
      Fee = Structure.new do
        # @return [String] The type of fee.
        attribute(:name, String)

        # @return [Money] The amount of the fee.
        attribute(:amount, Money)
      end
    end
  end
end
