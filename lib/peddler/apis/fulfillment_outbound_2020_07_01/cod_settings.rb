# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # The COD (Cash On Delivery) charges that you associate with a COD fulfillment order.
      CODSettings = Structure.new do
        # When true, this fulfillment order requires a COD (Cash On Delivery) payment.
        attribute(:cod_required, :boolean, null: false, from: "isCodRequired")

        # The amount of the COD charge to be collected from the recipient for a COD order.
        attribute?(:cod_charge, Money, from: "codCharge")

        # The amount of the tax on the COD charge to be collected from the recipient for a COD order.
        attribute?(:cod_charge_tax, Money, from: "codChargeTax")

        # The amount of the tax on the COD charge to be collected from the recipient for a COD order.
        attribute?(:shipping_charge, Money, from: "shippingCharge")

        # The amount of the tax on the shipping charge to be collected from the recipient for a COD order.
        attribute?(:shipping_charge_tax, Money, from: "shippingChargeTax")
      end
    end
  end
end
