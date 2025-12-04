# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The response schema for the `getDeliveryOfferings` operation.
      GetDeliveryOfferingsResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getDeliveryOfferings` operation.
        attribute?(:errors, [Error])

        # @return [GetDeliveryOfferingsResult] The response payload for the `getDeliveryOfferings` operation.
        attribute?(:payload, GetDeliveryOfferingsResult)
      end
    end
  end
end
