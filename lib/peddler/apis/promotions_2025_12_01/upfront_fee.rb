# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # Upfront fee (or a flat fee) for each promotion submitted.
      UpfrontFee = Structure.new do
        # @return [String]
        attribute(:frequency, String, null: false)

        # @return [Money]
        attribute(:rate, Money, null: false)
      end
    end
  end
end
