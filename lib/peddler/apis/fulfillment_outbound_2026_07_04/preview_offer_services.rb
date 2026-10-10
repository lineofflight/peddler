# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # Services for a preview offer response. Includes delivery settings (for example, `paymentOnDelivery`).
      PreviewOfferServices = Structure.new do
        # Additional services for this offer.
        attribute?(:additional, Hash)

        # Delivery service settings for this offer.
        attribute?(:delivery, PreviewDeliveryService)

        # The packaging settings for this offer.
        attribute?(:packaging, PreviewPackagingService)
      end
    end
  end
end
