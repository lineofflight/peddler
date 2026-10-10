# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # Item information for a fulfillment preview.
      PreviewLineItem = Structure.new do
        attribute(:amount, Amount, null: false)

        attribute(:product, PreviewProduct, null: false)
      end
    end
  end
end
