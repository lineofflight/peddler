# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module Economics20240315
      # A root type for seller economics queries version 2024_03_15.
      AnalyticsEconomics20240315 = Structure.new do
        # @return [Array<Economics>] A query to retrieve seller economics data for the seller's account aggregated
        # by date and product identifier. The seller economics data consists of
        # aggregated sales, fees, and cost for selected period. The data sets are
        # refreshed daily with the latest sales, fees, and cost data. The supported fee
        # types and advertisement charge types can be found
        # [here](https://sellercentral.amazon.com/gp/help/GZ8Y22NL2FSRY8M5).
        attribute?(:economics, [Economics])

        # @return [Array<Economics>] A query to preview seller economics data for the seller's account aggregated
        # by date range specified by startDate and endDate. The seller preview economics
        # data consists of aggregated estimated sales, fees, and cost for selected
        # period. The data sets are refreshed daily with the latest estimated sales,
        # fees, and cost data. The supported fee types and advertisement charge types can be found
        # [here](https://sellercentral.amazon.com/help/hub/reference/GQNVDV46U9JQ25HY).
        attribute?(:economics_preview, [Economics], from: "economicsPreview")
      end
    end
  end
end
