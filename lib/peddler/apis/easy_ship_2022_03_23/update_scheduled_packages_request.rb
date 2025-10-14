# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class EasyShip20220323
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
