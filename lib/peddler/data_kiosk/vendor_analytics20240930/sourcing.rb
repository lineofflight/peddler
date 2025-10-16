# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # Sourcing metric group. A null value for a given metric means that the metric is not available.
      Sourcing = Structure.new do
        # @return [String] Number of purchase order units that are confirmed to be shipped to Amazon.
        attribute?(:confirmed_units, String, from: "confirmedUnits")

        # @return [String] The number of units Amazon has ordered in the most recent purchase orders of the week.
        attribute?(:most_recent_submitted, String, from: "mostRecentSubmitted")

        # @return [UnitsWithValue] Net number of units and their cost received by Amazon after subtracting the
        # units returned to the supplier in the selected time frame.
        attribute?(:net_received, UnitsWithValue, from: "netReceived")

        # @return [String] Number of units included in the Vendor's open POs (i.e., confirmed PO quantities that are not
        # yet received).
        attribute?(:open_purchase_order_quantity, String, from: "openPurchaseOrderQuantity")

        # @return [Float] Time (in days) from when Vendor receives a PO from Amazon, to when inventory is received in a
        # FC.
        attribute?(:overall_vendor_lead_time, Float, from: "overallVendorLeadTime")

        # @return [Float] OOS (Out of Stock) rate on all products that are procurable. Retail Out of
        # Stock (ROOS) = Out of Stock Glance Views on Procurable ASINs / Total Glance
        # Views. Procurability refers to whether Amazon is able to fulfill a customer
        # delivery promise, considering the ability of known vendors to supply the ASIN
        # in the foreseeable future.
        attribute?(:procurable_product_oos, Float, from: "procurableProductOOS")

        # @return [Float] PO units received by Amazon in comparison to PO units confirmed by the vendor.
        # The fill rate here applies only to Procurable ASINs. Fill Rate = Net Received
        # Units / Confirmed Units.
        attribute?(:received_fill_rate, Float, from: "receivedFillRate")

        # @return [Float] How many units Vendors confirm out of the units Amazon asks for, accounting
        # for Procurable ASINs only. Vendor Confirmation Rate = Confirmed Units /
        # Submitted Units.
        attribute?(:vendor_confirmation_rate, Float, from: "vendorConfirmationRate")
      end
    end
  end
end
