# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # A delivery document for a package.
      DeliveryDocument = Structure.new do
        # @return [String] The delivery document type. The only possible value is `DELIVERY_IMAGE`.
        attribute(:document_type, String, null: false, from: "documentType")

        # @return [String] A URL that is valid for one hour to download the document. In case of URL expiry, call the
        #   API again to get a new url. The URL will have a Content-Type header.
        attribute?(:url, String)
      end
    end
  end
end
