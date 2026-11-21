# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # Fulfillment configuration for a preview offer.
      PreviewOfferFulfillmentConfiguration = Structure.new do
        attribute?(:service_level, PreviewOfferServiceLevel, from: "serviceLevel")

        # Services for the offer.
        attribute?(:services, PreviewOfferServices)
      end
    end
  end
end
