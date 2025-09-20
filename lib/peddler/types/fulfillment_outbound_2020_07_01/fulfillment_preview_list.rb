# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/fulfillment_preview"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of fulfillment preview information.
      class FulfillmentPreviewList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| FulfillmentPreview.parse(item) })
          end
        end
      end
    end
  end
end
