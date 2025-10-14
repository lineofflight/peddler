# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module MarketplaceASINPageViewMetrics
      # Specifies the product type.
      ReportOptions = Structure.new do
        # @return [String] The Amazon product type of the ASINs for which the report is being requested. All ASINs with
        # the productType will be included. The value for the product type can be found by following instructions on
        # Seller Central's Help page. - https://developer-docs.amazon.com/sp-api/docs/seller-central-urls
        attribute(:product_type, String, from: "productType")
      end
    end
  end
end
