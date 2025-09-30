# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_v0/invalid_sku"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FulfillmentInboundV0
      # A list of invalid SKU values and the reason they are invalid.
      class InvalidSKUList < Array
        class << self
          def parse(array)
            new(array.map { |item| InvalidSKU.parse(item) })
          end
        end
      end
    end
  end
end
