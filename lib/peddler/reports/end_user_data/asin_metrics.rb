# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module EndUserData
      # Page view and GMS metrics of the end user.
      ASINMetrics = Structure.new do
        # ASIN for which the metrics are provided. Only ASINs with an active offer from the Seller are included.
        attribute(:asin, String, null: false)

        # End date of the aggregation window.
        attribute(:end_date, Date, null: false, from: "endDate")

        # Marketplace for which the metrics are provided.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # Start date of the aggregation window.
        attribute(:start_date, Date, null: false, from: "startDate")

        # The ISO 4217 currency code in which GMS is calculated.
        attribute?(:currency_code, String, from: "currencyCode")

        # End user's GMS for the ASIN. GMS = (Product Price * Quantity) + Shipping + Giftwrap - Returns - Promotional
        # Discounts.
        attribute?(:gms, Float)

        # End user's page views (count) for the ASIN.
        attribute?(:page_views, Integer, from: "pageViews")
      end
    end
  end
end
