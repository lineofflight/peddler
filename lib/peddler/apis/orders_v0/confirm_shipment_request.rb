# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # The request schema for an shipment confirmation.
      ConfirmShipmentRequest = Structure.new do
        # @return [String]
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [PackageDetail]
        attribute(:package_detail, PackageDetail, from: "packageDetail")

        # @return [String] The COD collection method (only supported in the JP marketplace).
        attribute?(:cod_collection_method, String, from: "codCollectionMethod")
      end
    end
  end
end
