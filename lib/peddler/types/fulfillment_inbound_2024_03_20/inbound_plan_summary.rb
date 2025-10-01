# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_2024_03_20/address"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # A light-weight inbound plan.
      InboundPlanSummary = Structure.new do
        # @return [String] The time at which the inbound plan was created. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        # `yyyy-MM-ddTHH:mm:ssZ`.
        attribute(:created_at, String, from: "createdAt")

        # @return [String] Identifier of an inbound plan.
        attribute(:inbound_plan_id, String, from: "inboundPlanId")

        # @return [String] The time at which the inbound plan was last updated. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        # `yyyy-MM-ddTHH:mm:ssZ`.
        attribute(:last_updated_at, String, from: "lastUpdatedAt")

        # @return [Array<String>] A list of marketplace IDs.
        attribute(:marketplace_ids, [String], from: "marketplaceIds")

        # @return [String] Human-readable name of the inbound plan.
        attribute(:name, String)

        # @return [Address]
        attribute(:source_address, Address, from: "sourceAddress")

        # @return [String] The current status of the inbound plan. Possible values: `ACTIVE`, `VOIDED`, `SHIPPED`,
        # `ERRORED`.
        attribute(:status, String)
      end
    end
  end
end
