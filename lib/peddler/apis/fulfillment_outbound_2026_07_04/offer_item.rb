# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Item information for a getOffers request.
      OfferItem = Structure.new do
        # @return [ProductIdentifier]
        attribute?(:product_identifier, ProductIdentifier, from: "productIdentifier")
      end
    end
  end
end
