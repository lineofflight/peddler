# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # Item-level information for a removal shipment item adjustment.
      RemovalShipmentItemAdjustment = Structure.new do
        # @return [Integer] Adjusted quantity of removal shipmentItemAdjustment items.
        attribute?(:adjusted_quantity, Integer, from: "AdjustedQuantity")

        # @return [String] The Amazon fulfillment network SKU for the item.
        attribute?(:fulfillment_network_sku, String, from: "FulfillmentNetworkSKU")

        # @return [String] An identifier for an item in a removal shipment.
        attribute?(:removal_shipment_item_id, String, from: "RemovalShipmentItemId")

        # @return [Money] The total amount adjusted for disputed items.
        attribute?(:revenue_adjustment, Money, from: "RevenueAdjustment")

        # @return [Money] Adjustment on the Tax collected amount on the adjusted revenue.
        attribute?(:tax_amount_adjustment, Money, from: "TaxAmountAdjustment")

        # @return [String] The tax collection model applied to the item.
        #
        # Possible values:
        #
        # * MarketplaceFacilitator - Tax is withheld and remitted to the taxing authority by Amazon on behalf of the
        # seller.
        #
        # * Standard - Tax is paid to the seller and not remitted to the taxing authority by Amazon.
        attribute?(:tax_collection_model, String, from: "TaxCollectionModel")

        # @return [Money] Adjustment the tax withheld and remitted to the taxing authority by Amazon on behalf of the
        # seller. If TaxCollectionModel=MarketplaceFacilitator, then TaxWithheld=TaxAmount (except the TaxWithheld
        # amount is a negative number). Otherwise TaxWithheld=0.
        attribute?(:tax_withheld_adjustment, Money, from: "TaxWithheldAdjustment")
      end
    end
  end
end
