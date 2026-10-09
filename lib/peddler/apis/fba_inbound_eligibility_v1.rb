# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for FBA Inbound Eligibilty
    #
    # With the FBA Inbound Eligibility API, you can build applications that let sellers get eligibility previews for
    # items before shipping them to Amazon's fulfillment centers. With this API you can find out if an item is eligible
    # for inbound shipment to Amazon's fulfillment centers in a specific marketplace. You can also find out if an item
    # is eligible for using the manufacturer barcode for FBA inventory tracking. Sellers can use this information to
    # inform their decisions about which items to ship Amazon's fulfillment centers.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/fba-inbound-eligibility-api-model/fbaInbound.json
    module FBAInboundEligibilityV1
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "fba_inbound_eligibility_v1.get_item_eligibility_preview" => -> { GetItemEligibilityPreviewResponse },
      })
    end
  end
end
