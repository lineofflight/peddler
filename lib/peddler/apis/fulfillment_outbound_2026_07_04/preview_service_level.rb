# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Service level configuration for data-plane requests (`getOffers`, `getOrderPreview`). Specifies the tiers for
      # which to get offers or previews.
      PreviewServiceLevel = Structure.new do
        # @return [Array<String>] The service tiers to retrieve offers for. Available values: `STANDARD`, `EXPEDITED`,
        #   `PRIORITY` (only available in Canada, India, and Mexico), `SCHEDULED` (only available in Japan). Multiple
        #   values can be provided to receive offers across different tiers.
        attribute?(:service_tiers, [String], from: "serviceTiers")
      end
    end
  end
end
