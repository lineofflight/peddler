# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # Contains the list of programs that Amazon associates with an item.
      #
      # Possible programs are:
      # - **Subscribe and Save**: Offers recurring, scheduled deliveries to Amazon customers and Amazon Business
      # customers for their frequently ordered products. - **FBM Ship+**: Unlocks expedited shipping without the extra
      # cost. Helps you to provide accurate and fast delivery dates to Amazon customers. You also receive protection
      # from late deliveries, a discount on expedited shipping rates, and cash back when you ship.
      AmazonPrograms = Structure.new do
        # @return [Array<String>] A list of the programs that Amazon associates with the order item.
        #
        # **Possible values**: `SUBSCRIBE_AND_SAVE`, `FBM_SHIP_PLUS`
        attribute(:programs, [String], null: false, from: "Programs")
      end
    end
  end
end
