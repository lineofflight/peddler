# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Replenishment20221107
      # An object which contains details about an offer.
      ListOffersResponseOffer = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN).
        attribute?(:asin, String)

        # @return [Array<DeliveriesCondition>] A list of delivery conditions for the offer, indicating the health of
        #   upcoming deliveries. Each condition describes the quantity of upcoming deliveries associated with a
        #   particular delivery condition type.
        attribute?(:deliveries_conditions, [DeliveriesCondition], from: "deliveriesConditions")

        # @return [String] The offer eligibility status.
        attribute?(:eligibility, String)

        # @return [ForecastDeliveries] The projected subscriber demand for the offer over different time horizons.
        attribute?(:forecast_deliveries, ForecastDeliveries, from: "forecastDeliveries")

        # @return [String] The fulfillment network identifier type for the offer, indicating how the offer is fulfilled.
        attribute?(:fulfillment_network_id_type, String, from: "fulfillmentNetworkIDType")

        # @return [Integer] The available inventory count for the offer.
        attribute?(:inventory, Integer)

        # @return [String] The marketplace identifier. The supported marketplaces for both sellers and vendors are US,
        #   CA, ES, UK, FR, IT, IN, DE, and JP. The supported marketplaces for vendors only are BR, AU, MX, AE, and NL.
        #   Refer to [Marketplace IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids) to find the
        #   identifier for the marketplace.
        attribute?(:marketplace_id, String, from: "marketplaceId")

        # @return [OfferProgramConfiguration]
        attribute?(:offer_program_configuration, OfferProgramConfiguration, from: "offerProgramConfiguration")

        # @return [Float] The current price of the offer. This is the listed price amount for the item.
        attribute?(:price, Float)

        # @return [String] The currency code in ISO 4217 format for the price. For example, `USD` for US dollars.
        attribute?(:price_currency_code, String, from: "priceCurrencyCode")

        # @return [String] The replenishment program for the offer.
        attribute?(:program_type, String, from: "programType")

        # @return [String] The SKU. This property is only supported for sellers and not for vendors.
        attribute?(:sku, String)

        # @return [String] The stock risk level of the offer, indicating the risk of the offer going out of stock.
        attribute?(:stock_risk, String, from: "stockRisk")

        # @return [Integer] The number of active subscriptions for the offer.
        attribute?(:subscriptions, Integer)

        # @return [Array<String>] A list of vendor codes associated with the offer.
        attribute?(:vendor_codes, [String], from: "vendorCodes")
      end
    end
  end
end
