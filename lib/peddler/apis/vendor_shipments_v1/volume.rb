# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # The volume of the shipment.
      Volume = Structure.new do
        # @return [String] The unit of measurement.
        attribute(:unit_of_measure, String, null: false, from: "unitOfMeasure")

        # @return [String] The measurement value.
        attribute(:value, String, null: false)
      end
    end
  end
end
