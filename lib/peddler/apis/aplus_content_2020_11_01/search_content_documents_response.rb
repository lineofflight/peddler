# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      SearchContentDocumentsResponse = Structure.new do
        # The content metadata records.
        attribute(:content_metadata_records, [ContentMetadataRecord], null: false, from: "contentMetadataRecords")
      end
    end
  end
end
