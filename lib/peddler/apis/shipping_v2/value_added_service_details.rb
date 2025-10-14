# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # A collection of supported value-added services.
      ValueAddedServiceDetails = Structure.new do
        # @return [CollectOnDelivery]
        attribute?(:collect_on_delivery, CollectOnDelivery, from: "collectOnDelivery")
      end
    end
  end
end
