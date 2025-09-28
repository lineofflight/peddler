# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_v0/amazon_prep_fees_details"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FulfillmentInboundV0
      # A list of preparation instructions and fees for Amazon to prep goods for shipment.
      class AmazonPrepFeesDetailsList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| AmazonPrepFeesDetails.parse(item) }) : new
          end
        end
      end
    end
  end
end
