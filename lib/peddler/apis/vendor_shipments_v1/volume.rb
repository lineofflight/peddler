# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorShipmentsV1
      # The volume of the shipment.
      Volume = Structure.new do
        # The unit of measurement. Known values: `CuFt`, `CuIn`, `CuM`, `CuY`.
        attribute(:unit_of_measure, String, null: false, from: "unitOfMeasure")

        # The measurement value.
        attribute(:value, String, null: false)
      end
    end
  end
end
