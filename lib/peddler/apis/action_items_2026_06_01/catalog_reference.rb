# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionItems20260601
      # A reference to a catalog, scoped to one or more Amazon stores.
      CatalogReference = Structure.new do
        # @return [String] The catalog identifier.
        attribute(:catalog_id, String, null: false, from: "catalogId")

        # @return [Array<String>] The Amazon store identifiers to which this catalog reference applies.
        attribute?(:marketplace_ids, [String], from: "marketplaceIds")
      end
    end
  end
end
