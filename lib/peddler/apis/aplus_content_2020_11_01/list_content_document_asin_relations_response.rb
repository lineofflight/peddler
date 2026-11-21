# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      ListContentDocumentASINRelationsResponse = Structure.new do
        attribute(:asin_metadata_set, [ASINMetadata], null: false, from: "asinMetadataSet")
      end
    end
  end
end
