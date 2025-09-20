# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/content_metadata_record"

module Peddler
  module Types
    module AplusContent20201101
      SearchContentDocumentsResponse = Structure.new do
        # @return [Array<ContentMetadataRecord>] The content metadata records.
        attribute(:content_metadata_records, [ContentMetadataRecord], from: "contentMetadataRecords")
      end
    end
  end
end
