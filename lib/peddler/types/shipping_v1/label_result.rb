# frozen_string_literal: true

require "peddler/types/shipping_v1/label"

module Peddler
  module Types
    module ShippingV1
      # Label details including label stream, format, size.
      LabelResult = Structure.new do
        # @return [String]
        attribute(:container_reference_id, String, from: "containerReferenceId")

        # @return [String] The tracking identifier assigned to the container.
        attribute(:tracking_id, String, from: "trackingId")

        # @return [Label]
        attribute(:label, Label)
      end
    end
  end
end
