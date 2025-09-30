# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/package"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # An array of package objects in a container.
      class Packages < Array
        class << self
          def parse(array)
            new(array.map { |item| Package.parse(item) })
          end
        end
      end
    end
  end
end
