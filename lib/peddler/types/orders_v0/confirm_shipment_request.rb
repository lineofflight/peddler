# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/orders_v0/package_detail"

module Peddler
  module Types
    module OrdersV0
      # The request schema for an shipment confirmation.
      ConfirmShipmentRequest = Structure.new do
        # @return [PackageDetail]
        attribute(:package_detail, PackageDetail, from: "packageDetail")

        # @return [String] The COD collection method (only supported in the JP marketplace).
        attribute(:cod_collection_method, String, from: "codCollectionMethod")

        # @return [String]
        attribute(:marketplace_id, String, from: "marketplaceId")
      end
    end
  end
end
