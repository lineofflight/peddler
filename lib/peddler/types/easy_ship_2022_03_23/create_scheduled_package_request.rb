# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/easy_ship_2022_03_23/package_details"

module Peddler
  module Types
    module EasyShip20220323
      # The request schema for the `createScheduledPackage` operation.
      CreateScheduledPackageRequest = Structure.new do
        # @return [String]
        attribute(:amazon_order_id, String, from: "amazonOrderId")

        # @return [String]
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [PackageDetails]
        attribute(:package_details, PackageDetails, from: "packageDetails")
      end
    end
  end
end
