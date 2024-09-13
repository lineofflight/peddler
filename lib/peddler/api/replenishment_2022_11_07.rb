# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Replenishment
    #
    # The Selling Partner API for Replenishment (Replenishment API) provides programmatic access to replenishment
    # program metrics and offers. These programs provide recurring delivery of any replenishable item at a frequency
    # chosen by the customer. The Replenishment API is available worldwide wherever Amazon Subscribe & Save is available
    # or is supported. The API is available to vendors and FBA selling partners.
    class Replenishment20221107 < API
      # Returns aggregated replenishment program metrics for a selling partner.
      #
      # @param [Hash] body The request body for the `getSellingPartnerMetrics` operation.
      # @return [Hash] The API response
      def get_selling_partner_metrics(body: nil)
        path = "/replenishment/2022-11-07/sellingPartners/metrics/search"

        rate_limit(1.0).post(path, body:)
      end

      # Returns aggregated replenishment program metrics for a selling partner's offers.
      #
      # @param [Hash] body The request body for the `listOfferMetrics` operation.
      # @return [Hash] The API response
      def list_offer_metrics(body: nil)
        path = "/replenishment/2022-11-07/offers/metrics/search"

        rate_limit(1.0).post(path, body:)
      end

      # Returns the details of a selling partner's replenishment program offers.
      #
      # @param [Hash] body The request body for the `listOffers` operation.
      # @return [Hash] The API response
      def list_offers(body: nil)
        path = "/replenishment/2022-11-07/offers/search"

        rate_limit(1.0).post(path, body:)
      end
    end
  end
end
