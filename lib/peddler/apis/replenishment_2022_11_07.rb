# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Replenishment
    #
    # The Selling Partner API for Replenishment (Replenishment API) provides programmatic access to replenishment
    # program metrics and offers. These programs provide recurring delivery of any replenishable item at a frequency
    # chosen by the customer.
    #
    # The Replenishment API is available worldwide wherever Amazon Subscribe & Save is available or is supported. The
    # API is available to vendors and FBA selling partners.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/replenishment-api-model/replenishment-2022-11-07.json
    class Replenishment20221107 < API
      # Returns aggregated replenishment program metrics for a selling partner.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body for the `getSellingPartnerMetrics` operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_selling_partner_metrics(body: nil, rate_limit: 1.0)
        path = "/replenishment/2022-11-07/sellingPartners/metrics/search"
        parser = -> { GetSellingPartnerMetricsResponse }
        meter(rate_limit).post(path, body:, parser:)
      end

      # Returns aggregated replenishment program metrics for a selling partner's offers.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body for the `listOfferMetrics` operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_offer_metrics(body: nil, rate_limit: 1.0)
        path = "/replenishment/2022-11-07/offers/metrics/search"
        parser = -> { ListOfferMetricsResponse }
        meter(rate_limit).post(path, body:, parser:)
      end

      # Returns the details of a selling partner's replenishment program offers.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body for the `listOffers` operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_offers(body: nil, rate_limit: 1.0)
        path = "/replenishment/2022-11-07/offers/search"
        parser = -> { ListOffersResponse }
        meter(rate_limit).post(path, body:, parser:)
      end
    end
  end
end
