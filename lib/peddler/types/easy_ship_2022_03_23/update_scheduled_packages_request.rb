# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/easy_ship_2022_03_23/update_package_details"

module Peddler
  module Types
    module EasyShip20220323
      # The request schema for the `updateScheduledPackages` operation.
      UpdateScheduledPackagesRequest = Structure.new do
        # @return [String]
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<UpdatePackageDetails>]
        attribute(:update_package_details_list, [UpdatePackageDetails], from: "updatePackageDetailsList")
      end
    end
  end
end
