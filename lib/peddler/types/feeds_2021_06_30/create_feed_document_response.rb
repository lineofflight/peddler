# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module Feeds20210630
      # Information required to upload a feed document's contents.
      CreateFeedDocumentResponse = Structure.new do
        # @return [String] The identifier of the feed document.
        attribute(:feed_document_id, String, from: "feedDocumentId")

        # @return [String] The presigned URL for uploading the feed contents. This URL expires after 5 minutes.
        attribute(:url, String)
      end
    end
  end
end
