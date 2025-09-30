# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/get_fulfillment_preview_item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of fulfillment preview item information.
      class GetFulfillmentPreviewItemList < Array
        class << self
          def parse(array)
            new(array.map { |item| GetFulfillmentPreviewItem.parse(item) })
          end
        end
      end
    end
  end
end
