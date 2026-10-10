# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Replenishment20221107
      # Use these parameters to sort the response.
      ListOffersRequestSort = Structure.new do
        # The attribute to use to sort the results.
        attribute(:key, String, null: false)

        # The sort order.
        attribute(:order, String, null: false)
      end
    end
  end
end
