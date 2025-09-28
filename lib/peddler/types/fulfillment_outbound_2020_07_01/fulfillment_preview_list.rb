# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/fulfillment_preview"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of fulfillment preview information.
      class FulfillmentPreviewList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| FulfillmentPreview.parse(item) }) : new
          end
        end
      end
    end
  end
end
