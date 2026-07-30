# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # The service level for a shipment in a fulfillment order.
      ShipmentServiceLevel = Structure.new do
        # @return [String] The service tier used for this shipment. Possible values: `STANDARD`, `EXPEDITED`, `PRIORITY`
        #   (only available in Canada, India, and Mexico), `SCHEDULED` (only available in Japan).
        attribute?(:service_tier, String, from: "serviceTier")
      end
    end
  end
end
