# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SellersV1
      # The response schema for the `getAccount` operation.
      Account = Structure.new do
        # The type of business registered for the seller account.
        attribute(:business_type, String, null: false, from: "businessType")

        attribute(:marketplace_participation_list, [MarketplaceParticipation], null: false, from: "marketplaceParticipationList")

        # The selling plan details.
        attribute(:selling_plan, String, null: false, from: "sellingPlan")

        attribute?(:business, Business)

        attribute?(:primary_contact, PrimaryContact, from: "primaryContact")
      end
    end
  end
end
