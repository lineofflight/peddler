# frozen_string_literal: true

require "peddler/types/easy_ship_2022_03_23/package_details"

module Peddler
  module Types
    module EasyShip20220323
      # This object allows users to specify an order to be scheduled. Only the amazonOrderId is required.
      OrderScheduleDetails = Structure.new do
        # @return [String]
        attribute(:amazon_order_id, String, from: "amazonOrderId")

        # @return [PackageDetails]
        attribute(:package_details, PackageDetails, from: "packageDetails")
      end
    end
  end
end
