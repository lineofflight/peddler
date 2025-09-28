# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_v0/prep_details"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FulfillmentInboundV0
      # A list of preparation instructions and who is responsible for that preparation.
      class PrepDetailsList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| PrepDetails.parse(item) }) : new
          end
        end
      end
    end
  end
end
