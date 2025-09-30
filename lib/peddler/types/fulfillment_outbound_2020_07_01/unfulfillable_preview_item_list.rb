# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/unfulfillable_preview_item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of unfulfillable preview item information.
      class UnfulfillablePreviewItemList < Array
        class << self
          def parse(array)
            new(array.map { |item| UnfulfillablePreviewItem.parse(item) })
          end
        end
      end
    end
  end
end
