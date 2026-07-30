# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Item information for a fulfillment preview.
      PreviewLineItem = Structure.new do
        # @return [Amount]
        attribute(:amount, Amount, null: false)

        # @return [PreviewProduct]
        attribute(:product, PreviewProduct, null: false)
      end
    end
  end
end
