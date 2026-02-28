# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      SearchContentDocumentsResponse = Structure.new do
        # @return [Array<ContentMetadataRecord>] The content metadata records.
        attribute(:content_metadata_records, [ContentMetadataRecord], null: false, from: "contentMetadataRecords")
      end
    end
  end
end
