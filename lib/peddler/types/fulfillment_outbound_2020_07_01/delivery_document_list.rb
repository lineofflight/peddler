# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/delivery_document"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # A list of delivery documents for a package.
      class DeliveryDocumentList < Array
        class << self
          def parse(array)
            new(array.map { |item| DeliveryDocument.parse(item) })
          end
        end
      end
    end
  end
end
