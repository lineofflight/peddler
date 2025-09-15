# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module Finances20240619
      # Information about the line of business associated with a transaction.
      BusinessContext = Structure.new do
        # @return [String] The store name associated with the transaction.
        attribute(:store_name, String, from: "storeName")
      end
    end
  end
end
