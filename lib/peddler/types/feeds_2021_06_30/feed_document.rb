# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module Feeds20210630
      # Information required for the feed document.
      FeedDocument = Structure.new do
        # @return [String] The identifier for the feed document. This identifier is unique only in combination with a
        # seller ID.
        attribute(:feed_document_id, String, from: "feedDocumentId")

        # @return [String] A presigned URL for the feed document. If `compressionAlgorithm` is not returned, you can
        # download the feed directly from this URL. This URL expires after 5 minutes.
        attribute(:url, String)

        # @return [String] If the feed document contents have been compressed, the compression algorithm used is
        # returned in this property and you must decompress the feed when you download. Otherwise, you can download the
        # feed directly. Refer to [Step 7. Download the feed processing
        # report](doc:feeds-api-v2021-06-30-use-case-guide#step-7-download-the-feed-processing-report) in the use case
        # guide, where sample code is provided.
        attribute(:compression_algorithm, String, from: "compressionAlgorithm")
      end
    end
  end
end
