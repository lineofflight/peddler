# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # A delivery document for a package.
      DeliveryDocument = Structure.new do
        # @return [String] The delivery document type. The only possible value is `DELIVERY_IMAGE`.
        attribute(:document_type, String, from: "documentType")

        # @return [String] A URL that you can use to download the document. This URL has a `Content-Type` header. Note
        # that the URL expires after one hour. To get a new URL, you must call the API again.
        attribute?(:url, String)
      end
    end
  end
end
