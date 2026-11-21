# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module EasyShip20220323
      # The request schema for the `createScheduledPackage` operation.
      CreateScheduledPackageRequest = Structure.new do
        attribute(:amazon_order_id, String, null: false, from: "amazonOrderId")

        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        attribute(:package_details, PackageDetails, null: false, from: "packageDetails")
      end
    end
  end
end
