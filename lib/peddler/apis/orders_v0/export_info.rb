# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # Contains information that is related to the export of an order item.
      ExportInfo = Structure.new do
        # @return [Money] Holds the export/import charge for an order item.
        attribute?(:export_charge, Money, from: "ExportCharge")

        # @return [String] Holds the `ExportCharge` collection model that is associated with the specified order item.
        #
        # **Possible values**: `AMAZON_FACILITATED`: Import/export charge is withheld by Amazon and remitted to the
        #   customs authority by the carrier on behalf of the buyer/seller.
        attribute?(:export_charge_model, String, from: "ExportChargeModel")
      end
    end
  end
end
