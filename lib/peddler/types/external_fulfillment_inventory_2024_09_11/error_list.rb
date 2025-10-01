# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_inventory_2024_09_11/error"

module Peddler
  module Types
    module ExternalFulfillmentInventory20240911
      # An object containing a list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] A list of error responses returned when a request is unsuccessful.
        attribute(:errors, [Error])
      end
    end
  end
end
