# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV1
      # Label details including label stream, format, size.
      LabelResult = Structure.new do
        attribute?(:container_reference_id, String, from: "containerReferenceId")

        attribute?(:label, Label)

        # The tracking identifier assigned to the container.
        attribute?(:tracking_id, String, from: "trackingId")
      end
    end
  end
end
