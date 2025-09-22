# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/collections_form_document"

module Peddler
  module Types
    module ShippingV2
      # The Response for the GetCollectionFormResponse operation.
      GetCollectionFormResponse = Structure.new do
        # @return [CollectionsFormDocument]
        attribute(:collections_form_document, CollectionsFormDocument, from: "collectionsFormDocument")
      end
    end
  end
end
