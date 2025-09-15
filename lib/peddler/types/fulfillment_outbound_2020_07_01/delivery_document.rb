# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # A delivery document for a package.
      DeliveryDocument = Structure.new do
        # @return [String] The delivery document type. Values are `SIGNATURE` and `DELIVERY_IMAGE`.
        attribute(:document_type, String, from: "documentType")

        # @return [String] A URL that you can use to download the document. This URL has a `Content-Type` header. Note
        # that the URL expires after one hour. To get a new URL, you must call the API again.
        attribute(:url, String)
      end
    end
  end
end
