# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/fulfillment_preview_item"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of fulfillment preview item information.
      class FulfillmentPreviewItemList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| FulfillmentPreviewItem.parse(item) })
          end
        end
      end
    end
  end
end
