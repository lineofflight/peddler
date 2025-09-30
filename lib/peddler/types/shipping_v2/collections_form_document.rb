# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Collection Form Document Details
      CollectionsFormDocument = Structure.new do
        # @return [String] Base64 document Value of Collection.
        attribute?(:base64_encoded_content, String, from: "base64EncodedContent")

        # @return [String] Collection Document format is PDF.
        attribute?(:document_format, String, from: "documentFormat")
      end
    end
  end
end
