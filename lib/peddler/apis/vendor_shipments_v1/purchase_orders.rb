# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Transport Request pickup date
      PurchaseOrders = Structure.new do
        # @return [Array<PurchaseOrderItems>] A list of the items that are associated to the PO in this transport and
        #   their associated details.
        attribute?(:items, [PurchaseOrderItems])

        # @return [Time] Purchase order numbers involved in this shipment, list all the PO that are involved as part of
        #   this shipment.
        attribute?(:purchase_order_date, Time, from: "purchaseOrderDate")

        # @return [String] Purchase order numbers involved in this shipment, list all the PO that are involved as part
        #   of this shipment.
        attribute?(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [String] Date range in which shipment is expected for these purchase orders.
        attribute?(:ship_window, String, from: "shipWindow")
      end
    end
  end
end
