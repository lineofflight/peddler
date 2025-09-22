# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module Replenishment20221107
      # Use these parameters to sort the response.
      ListOffersRequestSort = Structure.new do
        # @return [String] The sort order.
        attribute(:order, String)

        # @return [String] The attribute to use to sort the results.
        attribute(:key, String)
      end
    end
  end
end
