# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module FinancesV0
      # Item-level information for a removal shipment.
      RemovalShipmentItem = Structure.new do
        # @return [String] An identifier for an item in a removal shipment.
        attribute(:removal_shipment_item_id, String, from: "RemovalShipmentItemId")

        # @return [String] The tax collection model applied to the item.
        #
        # Possible values:
        #
        # * MarketplaceFacilitator - Tax is withheld and remitted to the taxing authority by Amazon on behalf of the
        # seller.
        #
        # * Standard - Tax is paid to the seller and not remitted to the taxing authority by Amazon.
        attribute(:tax_collection_model, String, from: "TaxCollectionModel")

        # @return [String] The Amazon fulfillment network SKU for the item.
        attribute(:fulfillment_network_sku, String, from: "FulfillmentNetworkSKU")

        # @return [Integer] The quantity of the item.
        attribute(:quantity, Integer, from: "Quantity")

        # @return [Types::Money] The total amount paid to the seller for the removed item.
        attribute(:revenue, Types::Money, from: "Revenue")

        # @return [Types::Money] The fee that Amazon charged to the seller for the removal of the item. The amount is a
        # negative number.
        attribute(:fee_amount, Types::Money, from: "FeeAmount")

        # @return [Types::Money] Tax collected on the revenue.
        attribute(:tax_amount, Types::Money, from: "TaxAmount")

        # @return [Types::Money] The tax withheld and remitted to the taxing authority by Amazon on behalf of the
        # seller. If TaxCollectionModel=MarketplaceFacilitator, then TaxWithheld=TaxAmount (except the TaxWithheld
        # amount is a negative number). Otherwise TaxWithheld=0.
        attribute(:tax_withheld, Types::Money, from: "TaxWithheld")
      end
    end
  end
end
