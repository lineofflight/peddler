# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Transport Request pickup date from Vendor Warehouse by Buyer
      CollectFreightPickupDetails = Structure.new do
        # @return [Time] Date on which the carrier is being scheduled to pickup items from vendor warehouse by Byer used
        #   for WePay/Collect vendors.
        attribute?(:carrier_assignment_date, Time, from: "carrierAssignmentDate")

        # @return [Time] Date on which the items can be picked up from vendor warehouse by Buyer used for WePay/Collect
        #   vendors.
        attribute?(:requested_pick_up, Time, from: "requestedPickUp")

        # @return [Time] Date on which the items are scheduled to be picked from vendor warehouse by Buyer used for
        #   WePay/Collect vendors.
        attribute?(:scheduled_pick_up, Time, from: "scheduledPickUp")
      end
    end
  end
end
