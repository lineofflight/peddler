# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Fulfillment configuration for a preview offer.
      PreviewOfferFulfillmentConfiguration = Structure.new do
        # @return [PreviewOfferServiceLevel]
        attribute?(:service_level, PreviewOfferServiceLevel, from: "serviceLevel")

        # @return [PreviewOfferServices] Services for the offer.
        attribute?(:services, PreviewOfferServices)
      end
    end
  end
end
