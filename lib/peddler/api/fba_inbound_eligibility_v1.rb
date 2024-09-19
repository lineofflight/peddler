# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for FBA Inbound Eligibilty
    #
    # With the FBA Inbound Eligibility API, you can build applications that let sellers get eligibility previews for
    # items before shipping them to Amazon's fulfillment centers. With this API you can find out if an item is eligible
    # for inbound shipment to Amazon's fulfillment centers in a specific marketplace. You can also find out if an item
    # is eligible for using the manufacturer barcode for FBA inventory tracking. Sellers can use this information to
    # inform their decisions about which items to ship Amazon's fulfillment centers.
    class FBAInboundEligibilityV1 < API
      # This operation gets an eligibility preview for an item that you specify. You can specify the type of eligibility
      # preview that you want (INBOUND or COMMINGLING). For INBOUND previews, you can specify the marketplace in which
      # you want to determine the item's eligibility.
      #
      # @param [Array<String>] marketplace_ids The identifier for the marketplace in which you want to determine
      #   eligibility. Required only when program=INBOUND.
      # @param [String] asin The ASIN of the item for which you want an eligibility preview.
      # @param [String] program The program that you want to check eligibility against.
      # @return [Hash] The API response
      def get_item_eligibility_preview(asin, program, marketplace_ids: nil)
        cannot_sandbox!

        path = "/fba/inbound/v1/eligibility/itemPreview"
        params = {
          "marketplaceIds" => marketplace_ids,
          "asin" => asin,
          "program" => program,
        }.compact

        rate_limit(1.0).get(path, params:)
      end
    end
  end
end
