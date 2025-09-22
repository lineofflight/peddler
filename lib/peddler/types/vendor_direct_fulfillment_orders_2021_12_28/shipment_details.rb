# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/shipment_dates"

module Peddler
  module Types
    module VendorDirectFulfillmentOrders20211228
      # Shipment details required for the shipment.
      ShipmentDetails = Structure.new do
        # @return [:boolean] When true, this is a priority shipment.
        attribute(:priority_shipment, :boolean, from: "isPriorityShipment")

        # @return [:boolean] When true, this order is part of a scheduled delivery program.
        attribute(:scheduled_delivery_shipment, :boolean, from: "isScheduledDeliveryShipment")

        # @return [:boolean] When true, a packing slip is required to be sent to the customer.
        attribute(:pslip_required, :boolean, from: "isPslipRequired")

        # @return [:boolean] When true, the order contain a gift. Include the gift message and gift wrap information.
        attribute(:gift, :boolean, from: "isGift")

        # @return [String] Ship method to be used for shipping the order. Amazon defines ship method codes indicating
        # the shipping carrier and shipment service level. To see the full list of ship methods in use, including both
        # the code and the friendly name, search the 'Help' section on Vendor Central for 'ship methods'.
        attribute(:ship_method, String, from: "shipMethod")

        # @return [ShipmentDates]
        attribute(:shipment_dates, ShipmentDates, from: "shipmentDates")

        # @return [String] Message to customer for order status.
        attribute(:message_to_customer, String, from: "messageToCustomer")
      end
    end
  end
end
