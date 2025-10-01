# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module VendorShipmentsV1
      # Transport Request pickup date from Vendor Warehouse by Buyer
      CollectFreightPickupDetails = Structure.new do
        # @return [String] Date on which the carrier is being scheduled to pickup items from vendor warehouse by Byer
        # used for WePay/Collect vendors.
        attribute?(:carrier_assignment_date, String, from: "carrierAssignmentDate")

        # @return [String] Date on which the items can be picked up from vendor warehouse by Buyer used for
        # WePay/Collect vendors.
        attribute?(:requested_pick_up, String, from: "requestedPickUp")

        # @return [String] Date on which the items are scheduled to be picked from vendor warehouse by Buyer used for
        # WePay/Collect vendors.
        attribute?(:scheduled_pick_up, String, from: "scheduledPickUp")
      end
    end
  end
end
