# frozen_string_literal: true

require "peddler/types/money"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Fee type and cost.
      Fee = Structure.new do
        # @return [String] The type of fee.
        attribute(:name, String)

        # @return [Types::Money] The amount of the fee.
        attribute(:amount, Types::Money)
      end
    end
  end
end
