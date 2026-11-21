# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Feeds20210630
      # Information required to upload a feed document's contents.
      CreateFeedDocumentResponse = Structure.new do
        # The identifier of the feed document.
        attribute(:feed_document_id, String, null: false, from: "feedDocumentId")

        # The presigned URL for uploading the feed contents. This URL expires after 5 minutes.
        attribute(:url, String, null: false)
      end
    end
  end
end
