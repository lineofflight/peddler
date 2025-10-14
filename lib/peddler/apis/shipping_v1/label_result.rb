# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # Label details including label stream, format, size.
      LabelResult = Structure.new do
        # @return [String]
        attribute?(:container_reference_id, String, from: "containerReferenceId")

        # @return [Label]
        attribute?(:label, Label)

        # @return [String] The tracking identifier assigned to the container.
        attribute?(:tracking_id, String, from: "trackingId")
      end
    end
  end
end
