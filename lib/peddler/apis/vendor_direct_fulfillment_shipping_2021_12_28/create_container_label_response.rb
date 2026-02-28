# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShipping20211228
      # The response schema for the `createContainerLabel` operation.
      CreateContainerLabelResponse = Structure.new do
        # @return [ContainerLabel] The label data for the container label.
        attribute(:container_label, ContainerLabel, null: false, from: "containerLabel")
      end
    end
  end
end
