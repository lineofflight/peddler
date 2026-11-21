# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The Response for the GenerateCollectionFormResponse operation.
      GenerateCollectionFormResponse = Structure.new do
        attribute?(:collections_form_document, CollectionsFormDocument, from: "collectionsFormDocument")
      end
    end
  end
end
