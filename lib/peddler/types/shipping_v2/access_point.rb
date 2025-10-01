# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v2/accessibility_attributes"
require "peddler/types/shipping_v2/address"
require "peddler/types/shipping_v2/exception_operating_hours"

module Peddler
  module Types
    module ShippingV2
      # Access point details
      AccessPoint = Structure.new do
        # @return [String]
        attribute?(:access_point_id, String, from: "accessPointId")

        # @return [AccessibilityAttributes]
        attribute?(:accessibility_attributes, AccessibilityAttributes, from: "accessibilityAttributes")

        # @return [Address]
        attribute?(:address, Address)

        # @return [String] Assistance type enum for Access point i.e. STAFF_ASSISTED or SELF_ASSISTED
        attribute?(:assistance_type, String, from: "assistanceType")

        # @return [Array<ExceptionOperatingHours>] Exception operating hours for Access Point
        attribute?(:exception_operating_hours, [ExceptionOperatingHours], from: "exceptionOperatingHours")

        # @return [String] Name of entity (store/hub etc) where this access point is located
        attribute?(:name, String)

        # @return [String] The score of access point, based on proximity to postal code and sorting preference. This can
        # be used to sort access point results on shipper's end.
        attribute?(:score, String)

        # @return [Hash]
        attribute?(:standard_operating_hours, Hash, from: "standardOperatingHours")

        # @return [String] Timezone of access point
        attribute?(:timezone, String)

        # @return [String]
        attribute?(:type, String)
      end
    end
  end
end
