# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module OrdersV0
      # The request schema for an shipment confirmation.
      ConfirmShipmentRequest = Structure.new do
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        attribute(:package_detail, PackageDetail, null: false, from: "packageDetail")

        # The COD collection method (only supported in the JP marketplace).
        attribute?(:cod_collection_method, String, from: "codCollectionMethod")
      end
    end
  end
end
