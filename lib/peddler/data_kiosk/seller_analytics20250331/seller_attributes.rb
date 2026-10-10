# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Seller-level attributes for the account. These are static and do not vary by metric or groupBy. A null value
      # means the attribute is not yet available.
      SellerAttributes = Structure.new do
        # Binary flag indicating whether the seller is registered as a brand owner in Amazon's Brand Registry.
        attribute?(:is_brand_owner, String, from: "isBrandOwner")

        # Binary flag indicating whether seller is registered for Amazon's FBA program.
        attribute?(:is_fba_registered, String, from: "isFBARegistered")

        # Fraud status of a merchant with default value of NormalStatus.
        attribute?(:seller_fraud_status, String, from: "sellerFraudStatus")

        # Web address of a merchant's online storefront on Amazon displaying all their listed ASINs.
        attribute?(:seller_store_url, String, from: "sellerStoreURL")

        # Length of time a seller has been active on the Amazon marketplace, typically measured in days or months.
        attribute?(:seller_tenure, IntWithBenchmarking, from: "sellerTenure")
      end
    end
  end
end
