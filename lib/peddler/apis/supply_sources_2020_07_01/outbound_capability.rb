# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SupplySources20200701
      # The outbound capability of a supply source.
      OutboundCapability = Structure.new do
        attribute?(:delivery_channel, DeliveryChannel, from: "deliveryChannel")

        attribute?(:supported, :boolean, from: "isSupported")

        attribute?(:operational_configuration, OperationalConfiguration, from: "operationalConfiguration")

        attribute?(:pickup_channel, PickupChannel, from: "pickupChannel")

        attribute?(:return_location, ReturnLocation, from: "returnLocation")
      end
    end
  end
end
