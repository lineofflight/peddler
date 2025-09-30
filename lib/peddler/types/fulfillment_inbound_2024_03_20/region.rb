# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Representation of a location used within the inbounding experience.
      Region = Structure.new do
        # @return [String] ISO 3166 standard alpha-2 country code.
        attribute?(:country_code, String, from: "countryCode")

        # @return [String] State.
        attribute?(:state, String)

        # @return [String] An identifier for a warehouse, such as a FC, IXD, upstream storage.
        attribute?(:warehouse_id, String, from: "warehouseId")
      end
    end
  end
end
