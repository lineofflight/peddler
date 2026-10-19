# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Replenishment20221107
      # Use these parameters to filter results. Any result must match all provided parameters. For parameters that
      # accept multiple values (arrays), the API returns results that match at least one value in the array.
      ListOffersRequestFilters = Structure.new do
        # The marketplace identifier. The supported marketplaces for both sellers and vendors are US, CA, ES, UK, FR,
        # IT, IN, DE, and JP. The supported marketplaces for vendors only are BR, AU, MX, AE, and NL. Refer to
        # [Marketplace IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids) to find the identifier for
        # the marketplace.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # Known values: `SUBSCRIBE_AND_SAVE`.
        attribute(:program_types, Array, null: false, from: "programTypes")

        # A list of Amazon Standard Identification Numbers (ASINs).
        attribute?(:asins, [String])

        # A list of delivery condition types to filter the results by. Results are filtered to only include offers with
        # the specified delivery conditions. Known values: `NEXT_30_DAYS_DELIVERIES_PAUSED_PRICING`,
        # `NEXT_30_DAYS_DELIVERIES_PAUSED_NON_BUYABLE`, `NEXT_30_DAYS_DELIVERIES_AT_LOW_INVENTORY_RISK_ONLY`,
        # `NEXT_30_DAYS_DELIVERIES_AT_LOW_INVENTORY_RISK`, `NO_ISSUES_FOR_NEXT_30_DAYS_DELIVERIES`.
        attribute?(:deliveries_conditions, [String], from: "deliveriesConditions")

        # A list of eligibilities associated with an offer. Known values: `ELIGIBLE`, `INELIGIBLE`, `SUSPENDED`,
        # `REPLENISHMENT_ONLY_ORDERING`.
        attribute?(:eligibilities, Array)

        # Offer preferences to include in the result filter criteria.
        attribute?(:preferences, Preference)

        # Offer promotions to include in the result filter criteria.
        attribute?(:promotions, Promotion)

        # A list of SKUs to filter. This filter is only supported for sellers and not for vendors.
        attribute?(:skus, [String])
      end
    end
  end
end
