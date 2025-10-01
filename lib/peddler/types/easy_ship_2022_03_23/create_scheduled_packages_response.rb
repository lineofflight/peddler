# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/easy_ship_2022_03_23/rejected_order"
require "peddler/types/easy_ship_2022_03_23/package"

module Peddler
  module Types
    module EasyShip20220323
      # The response schema for the bulk scheduling API. It returns by the bulk scheduling API containing an array of
      # the scheduled packtages, an optional list of orders we couldn't schedule with the reason, and a pre-signed URL
      # for a ZIP file containing the associated shipping labels plus the documents enabled for your marketplace.
      CreateScheduledPackagesResponse = Structure.new do
        # @return [String]
        attribute?(:printable_documents_url, String, from: "printableDocumentsUrl")

        # @return [Array<RejectedOrder>] A list of orders we couldn't scheduled on your behalf. Each element contains
        # the reason and details on the error.
        attribute?(:rejected_orders, [RejectedOrder], from: "rejectedOrders")

        # @return [Array<Package>] A list of packages. Refer to the `Package` object.
        attribute?(:scheduled_packages, [Package], from: "scheduledPackages")
      end
    end
  end
end
