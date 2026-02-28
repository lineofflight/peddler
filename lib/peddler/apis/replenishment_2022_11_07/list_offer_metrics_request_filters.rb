# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Replenishment20221107
      # Use these parameters to filter results. Any result must match all provided parameters. For any parameter that is
      # an array, the result must match at least one element in the provided array.
      ListOfferMetricsRequestFilters = Structure.new do
        # @return [String] The marketplace identifier. The supported marketplaces for both sellers and vendors are US,
        #   CA, ES, UK, FR, IT, IN, DE and JP. The supported marketplaces for vendors only are BR, AU, MX, AE and NL.
        #   Refer to [Marketplace IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids) to find the
        #   identifier for the marketplace.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [Array<ProgramType>]
        attribute(:program_types, Array, null: false, from: "programTypes")

        # @return [TimeInterval] A time interval used to compute metrics.
        attribute(:time_interval, TimeInterval, null: false, from: "timeInterval")

        # @return [String]
        attribute(:time_period_type, String, null: false, from: "timePeriodType")

        # @return [String]
        attribute?(:aggregation_frequency, String, from: "aggregationFrequency")

        # @return [Array<String>] A list of Amazon Standard Identification Numbers (ASINs).
        attribute?(:asins, [String])
      end
    end
  end
end
