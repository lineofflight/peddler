# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # AccessPointDetails object
      AccessPointDetails = Structure.new do
        # @return [String]
        attribute?(:access_point_id, String, from: "accessPointId")
      end
    end
  end
end
