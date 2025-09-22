# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/sellers_v1/marketplace_participation"
require "peddler/types/sellers_v1/business"
require "peddler/types/sellers_v1/primary_contact"

module Peddler
  module Types
    module SellersV1
      # The response schema for the `getAccount` operation.
      Account = Structure.new do
        # @return [Array<MarketplaceParticipation>]
        attribute(:marketplace_participation_list, [MarketplaceParticipation], from: "marketplaceParticipationList")

        # @return [String] The type of business registered for the seller account.
        attribute(:business_type, String, from: "businessType")

        # @return [String] The selling plan details.
        attribute(:selling_plan, String, from: "sellingPlan")

        # @return [Business]
        attribute(:business, Business)

        # @return [PrimaryContact]
        attribute(:primary_contact, PrimaryContact, from: "primaryContact")
      end
    end
  end
end
