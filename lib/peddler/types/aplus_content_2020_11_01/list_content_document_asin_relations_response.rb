# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/aplus_content_2020_11_01/asin_metadata"

module Peddler
  module Types
    module AplusContent20201101
      ListContentDocumentAsinRelationsResponse = Structure.new do
        # @return [Array<AsinMetadata>]
        attribute(:asin_metadata_set, [AsinMetadata], from: "asinMetadataSet")
      end
    end
  end
end
