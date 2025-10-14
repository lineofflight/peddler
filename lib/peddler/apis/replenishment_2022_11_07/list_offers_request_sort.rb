# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Replenishment20221107
      # Use these parameters to sort the response.
      ListOffersRequestSort = Structure.new do
        # @return [String] The attribute to use to sort the results.
        attribute(:key, String)

        # @return [String] The sort order.
        attribute(:order, String)
      end
    end
  end
end
