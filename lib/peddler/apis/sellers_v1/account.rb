# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellersV1
      # The response schema for the `getAccount` operation.
      Account = Structure.new do
        # @return [String] The type of business registered for the seller account. Known values: `CHARITY`, `CRAFTSMAN`,
        #   `NATURAL_PERSON_COMPANY`, `PUBLIC_LISTED`, `PRIVATE_LIMITED`, `SOLE_PROPRIETORSHIP`, `STATE_OWNED`,
        #   `INDIVIDUAL`.
        attribute(:business_type, String, null: false, from: "businessType")

        # @return [Array<MarketplaceParticipation>]
        attribute(:marketplace_participation_list, [MarketplaceParticipation], null: false, from: "marketplaceParticipationList")

        # @return [String] The selling plan details. Known values: `PROFESSIONAL`, `INDIVIDUAL`.
        attribute(:selling_plan, String, null: false, from: "sellingPlan")

        # @return [Business]
        attribute?(:business, Business)

        # @return [PrimaryContact]
        attribute?(:primary_contact, PrimaryContact, from: "primaryContact")
      end
    end
  end
end
