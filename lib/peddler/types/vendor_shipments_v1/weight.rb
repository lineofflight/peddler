# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module VendorShipmentsV1
      # The weight of the shipment.
      Weight = Structure.new do
        # @return [String] The unit of measurement.
        attribute(:unit_of_measure, String, from: "unitOfMeasure")

        # @return [String] The measurement value.
        attribute(:value, String)
      end
    end
  end
end
