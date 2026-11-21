# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # A light-weight inbound plan.
      InboundPlanSummary = Structure.new do
        # The time at which the inbound plan was created. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        # `yyyy-MM-ddTHH:mm:ssZ`.
        attribute(:created_at, Time, null: false, from: "createdAt")

        # Identifier of an inbound plan.
        attribute(:inbound_plan_id, String, null: false, from: "inboundPlanId")

        # The time at which the inbound plan was last updated. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        # `yyyy-MM-ddTHH:mm:ssZ`.
        attribute(:last_updated_at, Time, null: false, from: "lastUpdatedAt")

        # A list of marketplace IDs.
        attribute(:marketplace_ids, [String], null: false, from: "marketplaceIds")

        # Human-readable name of the inbound plan.
        attribute(:name, String, null: false)

        attribute(:source_address, Address, null: false, from: "sourceAddress")

        # The current status of the inbound plan. Possible values: `ACTIVE`, `VOIDED`, `SHIPPED`, `ERRORED`.
        attribute(:status, String, null: false)
      end
    end
  end
end
