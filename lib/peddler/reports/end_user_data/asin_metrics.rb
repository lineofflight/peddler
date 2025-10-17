# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module EndUserData
      # Page view and GMS metrics of the end user.
      ASINMetrics = Structure.new do
        # @return [String] ASIN for which the metrics are provided. Only ASINs with an active offer from the Seller are
        #   included.
        attribute(:asin, String)

        # @return [Date] End date of the aggregation window.
        attribute(:end_date, Date, from: "endDate")

        # @return [String] Marketplace for which the metrics are provided.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Date] Start date of the aggregation window.
        attribute(:start_date, Date, from: "startDate")

        # @return [String] The ISO 4217 currency code in which GMS is calculated.
        attribute?(:currency_code, String, from: "currencyCode")

        # @return [Float] End user's GMS for the ASIN. GMS = (Product Price * Quantity) + Shipping + Giftwrap - Returns
        #   - Promotional Discounts.
        attribute?(:gms, Float)

        # @return [Integer] End user's page views (count) for the ASIN.
        attribute?(:page_views, Integer, from: "pageViews")
      end
    end
  end
end
