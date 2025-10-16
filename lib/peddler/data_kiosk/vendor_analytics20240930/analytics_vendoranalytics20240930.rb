# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # Root type for Vendor Analytics queries version 2024_09_30.
      AnalyticsVendoranalytics20240930 = Structure.new do
        # @return [Array<ManufacturingView>] The manufacturing view provides metrics about products manufactured by the
        # Vendor.
        attribute?(:manufacturing_view, [ManufacturingView], from: "manufacturingView")

        # @return [Array<SourcingView>] The sourcing view provides metrics about products that are sourced directly
        # from the Vendor to Amazon (i.e., when the Vendor is a distributor).
        attribute?(:sourcing_view, [SourcingView], from: "sourcingView")
      end
    end
  end
end
