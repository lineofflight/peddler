# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Finances20240619
      # Information about the line of business associated with a transaction.
      BusinessContext = Structure.new do
        # The store name associated with the transaction. Known values: `AMAZON_HAUL`, `AMAZON_FBA_FROM_ORIGIN`.
        attribute?(:store_name, String, from: "storeName")
      end
    end
  end
end
