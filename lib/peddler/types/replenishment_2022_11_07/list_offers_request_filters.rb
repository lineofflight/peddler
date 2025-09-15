# frozen_string_literal: true

require "peddler/types/replenishment_2022_11_07/preference"
require "peddler/types/replenishment_2022_11_07/promotion"

module Peddler
  module Types
    module Replenishment20221107
      # Use these parameters to filter results. Any result must match all of the provided parameters. For any parameter
      # that is an array, the result must match at least one element in the provided array.
      ListOffersRequestFilters = Structure.new do
        # @return [String] The marketplace identifier. The supported marketplaces for both sellers and vendors are US,
        # CA, ES, UK, FR, IT, IN, DE and JP. The supported marketplaces for vendors only are BR, AU, MX, AE and NL.
        # Refer to [Marketplace IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids) to find the
        # identifier for the marketplace.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<String>] A list of SKUs to filter. This filter is only supported for sellers and not for
        # vendors.
        attribute(:skus, [String])

        # @return [Array<String>] A list of Amazon Standard Identification Numbers (ASINs).
        attribute(:asins, [String])

        # @return [Array<EligibilityStatus>] A list of eligibilities associated with an offer.
        attribute(:eligibilities, Array)

        # @return [Preference] Offer preferences to include in the result filter criteria.
        attribute(:preferences, Preference)

        # @return [Promotion] Offer promotions to include in the result filter criteria.
        attribute(:promotions, Promotion)

        # @return [Array<ProgramType>]
        attribute(:program_types, Array, from: "programTypes")
      end
    end
  end
end
