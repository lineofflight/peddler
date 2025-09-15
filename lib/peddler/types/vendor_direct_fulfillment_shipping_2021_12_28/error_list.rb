# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/error"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] An array of Error objects representing individual errors encountered during the
        # request.
        attribute(:errors, [Error])
      end
    end
  end
end
