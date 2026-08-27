# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # Amount-based purchase conditions for basket building promotions. Customers must spend a minimum dollar amount.
      AmountThreshold = Structure.new do
        # @return [Money] The minimum spend amount customers must meet.
        attribute(:currency, Money, null: false)

        # @return [String] The type of amount requirement. Only `AT_LEAST` is supported for spend-based conditions.
        attribute(:type, String, null: false)
      end
    end
  end
end
