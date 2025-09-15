# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV2
      # AccessPointDetails object
      AccessPointDetails = Structure.new do
        # @return [String]
        attribute(:access_point_id, String, from: "accessPointId")
      end
    end
  end
end
