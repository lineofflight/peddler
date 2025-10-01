# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/replenishment_2022_11_07/offer_program_configuration_promotions_discount_funding"

module Peddler
  module Types
    module Replenishment20221107
      # An object which represents all promotions applied to an offer.
      OfferProgramConfigurationPromotions = Structure.new do
        # @return [OfferProgramConfigurationPromotionsDiscountFunding] A base discount set by Amazon on the offer.
        attribute?(:amazon_funded_base_discount, OfferProgramConfigurationPromotionsDiscountFunding, from: "amazonFundedBaseDiscount")

        # @return [OfferProgramConfigurationPromotionsDiscountFunding] A tiered discount set by Amazon on the offer.
        attribute?(:amazon_funded_tiered_discount, OfferProgramConfigurationPromotionsDiscountFunding, from: "amazonFundedTieredDiscount")

        # @return [OfferProgramConfigurationPromotionsDiscountFunding] A base discount set by the selling partner on the
        # offer.
        attribute?(:selling_partner_funded_base_discount, OfferProgramConfigurationPromotionsDiscountFunding, from: "sellingPartnerFundedBaseDiscount")

        # @return [OfferProgramConfigurationPromotionsDiscountFunding] A tiered discount set by the selling partner on
        # the offer.
        attribute?(:selling_partner_funded_tiered_discount, OfferProgramConfigurationPromotionsDiscountFunding, from: "sellingPartnerFundedTieredDiscount")
      end
    end
  end
end
