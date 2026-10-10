# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # Access point details
      AccessPoint = Structure.new do
        attribute?(:access_point_id, String, from: "accessPointId")

        attribute?(:accessibility_attributes, AccessibilityAttributes, from: "accessibilityAttributes")

        attribute?(:address, Address)

        # Assistance type enum for Access point i.e. STAFF_ASSISTED or SELF_ASSISTED
        attribute?(:assistance_type, String, from: "assistanceType")

        # Exception operating hours for Access Point
        attribute?(:exception_operating_hours, [ExceptionOperatingHours], from: "exceptionOperatingHours")

        # Name of entity (store/hub etc) where this access point is located
        attribute?(:name, String)

        # The score of access point, based on proximity to postal code and sorting preference. This can be used to sort
        # access point results on shipper's end.
        attribute?(:score, String)

        attribute?(:standard_operating_hours, Hash, from: "standardOperatingHours")

        # Timezone of access point
        attribute?(:timezone, String)

        attribute?(:type, String)
      end
    end
  end
end
