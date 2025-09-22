# frozen_string_literal: true

require "peddler/types/money"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The COD (Cash On Delivery) charges that you associate with a COD fulfillment order.
      CODSettings = Structure.new do
        # @return [:boolean] When true, this fulfillment order requires a COD (Cash On Delivery) payment.
        attribute(:cod_required, :boolean, from: "isCodRequired")

        # @return [Types::Money] The amount of the COD charge to be collected from the recipient for a COD order.
        attribute(:cod_charge, Types::Money, from: "codCharge")

        # @return [Types::Money] The amount of the tax on the COD charge to be collected from the recipient for a COD
        # order.
        attribute(:cod_charge_tax, Types::Money, from: "codChargeTax")

        # @return [Types::Money] The amount of the tax on the COD charge to be collected from the recipient for a COD
        # order.
        attribute(:shipping_charge, Types::Money, from: "shippingCharge")

        # @return [Types::Money] The amount of the tax on the shipping charge to be collected from the recipient for a
        # COD order.
        attribute(:shipping_charge_tax, Types::Money, from: "shippingChargeTax")
      end
    end
  end
end
