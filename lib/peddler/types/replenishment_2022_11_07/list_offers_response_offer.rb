# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/replenishment_2022_11_07/offer_program_configuration"

module Peddler
  module Types
    module Replenishment20221107
      # An object which contains details about an offer.
      ListOffersResponseOffer = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN).
        attribute?(:asin, String)

        # @return [String] The offer eligibility status.
        attribute?(:eligibility, String)

        # @return [String] The marketplace identifier. The supported marketplaces for both sellers and vendors are US,
        # CA, ES, UK, FR, IT, IN, DE and JP. The supported marketplaces for vendors only are BR, AU, MX, AE and NL.
        # Refer to [Marketplace IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids) to find the
        # identifier for the marketplace.
        attribute?(:marketplace_id, String, from: "marketplaceId")

        # @return [OfferProgramConfiguration]
        attribute?(:offer_program_configuration, OfferProgramConfiguration, from: "offerProgramConfiguration")

        # @return [String] The replenishment program for the offer.
        attribute?(:program_type, String, from: "programType")

        # @return [String] The SKU. This property is only supported for sellers and not for vendors.
        attribute?(:sku, String)

        # @return [Array<String>] A list of vendor codes associated with the offer.
        attribute?(:vendor_codes, [String], from: "vendorCodes")
      end
    end
  end
end
