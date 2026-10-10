# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # Item-level information for a removal shipment item adjustment.
      RemovalShipmentItemAdjustment = Structure.new do
        # Adjusted quantity of `RemovalShipmentItemAdjustment` items.
        attribute?(:adjusted_quantity, Integer, from: "AdjustedQuantity")

        # The Amazon fulfillment network SKU for the item.
        attribute?(:fulfillment_network_sku, String, from: "FulfillmentNetworkSKU")

        # An identifier for an item in a removal shipment.
        attribute?(:removal_shipment_item_id, String, from: "RemovalShipmentItemId")

        # The total amount adjusted for disputed items.
        attribute?(:revenue_adjustment, Money, from: "RevenueAdjustment")

        # Adjustment on the tax collected amount on the adjusted revenue.
        attribute?(:tax_amount_adjustment, Money, from: "TaxAmountAdjustment")

        # The tax collection model that is applied to the item.
        #
        # Possible values:
        #
        # * `MarketplaceFacilitator`: Tax is withheld and remitted to the taxing authority by Amazon on behalf of the
        # seller.
        # * `Standard`: Tax is paid to the seller and not remitted to the taxing authority by Amazon.
        attribute?(:tax_collection_model, String, from: "TaxCollectionModel")

        # Adjustment of the tax that is withheld and remitted to the taxing authority by Amazon on behalf of the seller.
        # If `TaxCollectionModel` = `MarketplaceFacilitator`, then `TaxWithheld` = `TaxAmount` (except when the
        # `TaxWithheld` amount is a negative number). Otherwise, `TaxWithheld` = `0`.
        attribute?(:tax_withheld_adjustment, Money, from: "TaxWithheldAdjustment")
      end
    end
  end
end
