# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The post-purchase details of a package that will be shipped using a shipping service.
      PackageDocumentDetail = Structure.new do
        # @return [String]
        attribute(:package_client_reference_id, String, from: "packageClientReferenceId")

        # @return [Array<PackageDocument>]
        attribute(:package_documents, [PackageDocument], from: "packageDocuments")

        # @return [String]
        attribute?(:tracking_id, String, from: "trackingId")
      end
    end
  end
end
