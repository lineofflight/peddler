# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # A charge on the seller's account.
      #
      # Possible values:
      #
      # * `Principal`: The selling price of the order item, which is equal to the selling price of the item multiplied
      # by the quantity ordered.
      #
      # * `Tax`: The tax on the principal that is collected by the seller.
      #
      # * `MarketplaceFacilitatorTax-Principal`: The tax that is withheld on the principal.
      #
      # * `MarketplaceFacilitatorTax-Shipping`: The tax that is withheld on the `ShippingCharge`.
      #
      # * `MarketplaceFacilitatorTax-Giftwrap`: The tax that is withheld on the Giftwrap charge.
      #
      # * `MarketplaceFacilitatorTax-Other`: The tax that is withheld on other miscellaneous charges.
      #
      # * `Discount`: The promotional discount for an order item.
      #
      # * `TaxDiscount`: The tax that is deducted for promotional rebates.
      #
      # * `CODItemCharge`: The COD charge for an order item.
      #
      # * `CODItemTaxCharge`: The tax that is collected by the seller on a `CODItemCharge`.
      #
      # * `CODOrderCharge`: The COD charge for an order.
      #
      # * `CODOrderTaxCharge`: The tax that is collected by the seller on a `CODOrderCharge`.
      #
      # * `CODShippingCharge`: Shipping charges for a COD order.
      #
      # * `CODShippingTaxCharge`: The tax that is collected by the seller on a `CODShippingCharge`.
      #
      # * `ShippingCharge`: The shipping charge.
      #
      # * `ShippingTax`: The tax that is collected by the seller on a `ShippingCharge`.
      #
      # * `Goodwill`: The amount of money that is given to a buyer as a gesture of goodwill or to compensate for pain
      # and suffering in the buying experience.
      #
      # * `Giftwrap`: The gift wrap charge.
      #
      # * `GiftwrapTax`: The tax that is collected by the seller on a gift wrap charge.
      #
      # * `RestockingFee`: The charge that is applied to the buyer when returning a product in certain categories.
      #
      # * `ReturnShipping`: The amount of money that is given to the buyer to compensate for shipping the item back if
      # we are at fault.
      #
      # * `PointsFee`: The value of Amazon Points deducted from the refund if the buyer does not have enough Amazon
      # Points to cover the deduction.
      #
      # * `GenericDeduction`: A generic bad debt deduction.
      #
      # * `FreeReplacementReturnShipping`: The compensation for return shipping when a buyer receives the wrong item,
      # requests a free replacement, and returns the incorrect item.
      #
      # * `PaymentMethodFee`: The fee that is collected for certain payment methods in certain marketplaces.
      #
      # * `ExportCharge`: The export duty that is charged when an item is shipped to an international destination as
      # part of the Amazon Global program.
      #
      # * `SAFE-TReimbursement`: The SAFE-T claim amount for the item.
      #
      # * `TCS-CGST`: Tax Collected at Source (TCS) for Central Goods and Services Tax (CGST).
      #
      # * `TCS-SGST`: Tax Collected at Source for State Goods and Services Tax (SGST).
      #
      # * `TCS-IGST`: Tax Collected at Source for Integrated Goods and Services Tax (IGST).
      #
      # * `TCS-UTGST`: Tax Collected at Source for Union Territories Goods and Services Tax (UTGST).
      #
      # * `PaidthroughEBT`: The amount of money paid with EBT for any order or shipment items.
      ChargeComponent = Structure.new do
        # @return [Money] The amount of the charge.
        attribute?(:charge_amount, Money, from: "ChargeAmount")

        # @return [String] The type of charge.
        attribute?(:charge_type, String, from: "ChargeType")
      end
    end
  end
end
