# frozen_string_literal: true

require "peddler/types/shipping_v2/collect_on_delivery"

module Peddler
  module Types
    module ShippingV2
      # A collection of supported value-added services.
      ValueAddedServiceDetails = Structure.new do
        # @return [CollectOnDelivery]
        attribute(:collect_on_delivery, CollectOnDelivery, from: "collectOnDelivery")
      end
    end
  end
end
