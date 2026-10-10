# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The post-purchase details of a package that will be shipped using a shipping service.
      PackageDocumentDetail = Structure.new do
        attribute(:package_client_reference_id, String, null: false, from: "packageClientReferenceId")

        attribute(:package_documents, [PackageDocument], null: false, from: "packageDocuments")

        attribute?(:tracking_id, String, from: "trackingId")
      end
    end
  end
end
