# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Replenishment20221107
      # Use these parameters to sort the response.
      ListOfferMetricsRequestSort = Structure.new do
        # @return [String]
        attribute(:key, String, null: false)

        # @return [String] The sort order.
        attribute(:order, String, null: false)
      end
    end
  end
end
