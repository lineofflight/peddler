# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # A related item in a draft listings relationship.
      ListingsItemDraftRelatedItem = Structure.new do
        # @return [String] A selling partner-provided identifier for the related item.
        attribute(:sku, String, null: false)

        # @return [Hash] JSON object containing structured attribute data for the related item.
        attribute?(:attributes, Hash)
      end
    end
  end
end
