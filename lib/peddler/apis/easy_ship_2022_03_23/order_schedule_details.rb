# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class EasyShip20220323
      # This object allows users to specify an order to be scheduled. Only the amazonOrderId is required.
      OrderScheduleDetails = Structure.new do
        # @return [String]
        attribute(:amazon_order_id, String, from: "amazonOrderId")

        # @return [PackageDetails]
        attribute?(:package_details, PackageDetails, from: "packageDetails")
      end
    end
  end
end
