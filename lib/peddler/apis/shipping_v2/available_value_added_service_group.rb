# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The value-added services available for purchase with a shipping service offering.
      AvailableValueAddedServiceGroup = Structure.new do
        # @return [String] The name of the value-added service group.
        attribute(:group_description, String, from: "groupDescription")

        # @return [String] The type of the value-added service group.
        attribute(:group_id, String, from: "groupId")

        # @return [:boolean] When true, one or more of the value-added services listed must be specified.
        attribute(:required, :boolean, from: "isRequired")

        # @return [Array<ValueAddedService>] A list of optional value-added services available for purchase with a
        #   shipping service offering.
        attribute?(:value_added_services, [ValueAddedService], from: "valueAddedServices")
      end
    end
  end
end
