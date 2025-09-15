# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/container_label"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # The response schema for the `createContainerLabel` operation.
      CreateContainerLabelResponse = Structure.new do
        # @return [ContainerLabel] The label data for the container label.
        attribute(:container_label, ContainerLabel, from: "containerLabel")
      end
    end
  end
end
