# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class VendorDirectFulfillmentOrders20211228
      # Shipment details required for the shipment.
      ShipmentDetails = Structure.new do
        # @return [:boolean] When true, this is a priority shipment.
        attribute(:priority_shipment, :boolean, from: "isPriorityShipment")

        # @return [:boolean] When true, a packing slip is required to be sent to the customer.
        attribute(:pslip_required, :boolean, from: "isPslipRequired")

        # @return [String] Message to customer for order status.
        attribute(:message_to_customer, String, from: "messageToCustomer")

        # @return [String] Ship method to be used for shipping the order. Amazon defines ship method codes indicating
        #   the shipping carrier and shipment service level. To see the full list of ship methods in use, including both
        #   the code and the friendly name, search the 'Help' section on Vendor Central for 'ship methods'.
        attribute(:ship_method, String, from: "shipMethod")

        # @return [ShipmentDates]
        attribute(:shipment_dates, ShipmentDates, from: "shipmentDates")

        # @return [:boolean] When true, the order contain a gift. Include the gift message and gift wrap information.
        attribute?(:gift, :boolean, from: "isGift")

        # @return [:boolean] When true, this order is part of a scheduled delivery program.
        attribute?(:scheduled_delivery_shipment, :boolean, from: "isScheduledDeliveryShipment")
      end
    end
  end
end
