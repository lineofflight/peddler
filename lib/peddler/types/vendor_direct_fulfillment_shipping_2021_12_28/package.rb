# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # The package that is associated with the container.
      Package = Structure.new do
        # @return [String] The tracking number on the label of shipment package, that you can fetch from the
        # `shippingLabels` response. You can also scan the bar code on the shipping label to get the tracking number.
        attribute(:package_tracking_number, String, from: "packageTrackingNumber")
      end
    end
  end
end
