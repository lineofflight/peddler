# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SupplySources20200701
      # The outbound capability of a supply source.
      OutboundCapability = Structure.new do
        # @return [DeliveryChannel]
        attribute?(:delivery_channel, DeliveryChannel, from: "deliveryChannel")

        # @return [:boolean]
        attribute?(:supported, :boolean, from: "isSupported")

        # @return [OperationalConfiguration]
        attribute?(:operational_configuration, OperationalConfiguration, from: "operationalConfiguration")

        # @return [PickupChannel]
        attribute?(:pickup_channel, PickupChannel, from: "pickupChannel")

        # @return [ReturnLocation]
        attribute?(:return_location, ReturnLocation, from: "returnLocation")
      end
    end
  end
end
