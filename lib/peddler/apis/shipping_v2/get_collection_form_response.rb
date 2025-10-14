# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The Response for the GetCollectionFormResponse operation.
      GetCollectionFormResponse = Structure.new do
        # @return [CollectionsFormDocument]
        attribute?(:collections_form_document, CollectionsFormDocument, from: "collectionsFormDocument")
      end
    end
  end
end
