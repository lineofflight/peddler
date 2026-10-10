# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # A shipping label with a label document for a single package. If label generation fails, you can use the `status`
      # and `errorDetails` attributes to determine the cause of failure.
      PackageShipLabel = Structure.new do
        attribute?(:error_details, Error, from: "errorDetails")

        attribute?(:file_data, DocumentV2, from: "fileData")

        # The package ID of the package.
        attribute?(:package_id, String, from: "packageId")

        attribute?(:ship_label_metadata, ShipLabelMetadata, from: "shipLabelMetadata")

        # Whether label generation failed for the current package. If `FAILURE`, use `errorDetails` to determine details
        # of the failure.
        attribute?(:status, String)
      end
    end
  end
end
