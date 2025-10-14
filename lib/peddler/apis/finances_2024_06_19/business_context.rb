# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Finances20240619
      # Information about the line of business associated with a transaction.
      BusinessContext = Structure.new do
        # @return [String] The store name associated with the transaction.
        attribute?(:store_name, String, from: "storeName")
      end
    end
  end
end
