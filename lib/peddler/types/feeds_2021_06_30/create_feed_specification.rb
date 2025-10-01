# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module Feeds20210630
      # Information required to create the feed.
      CreateFeedSpecification = Structure.new do
        # @return [String] The feed type.
        attribute(:feed_type, String, from: "feedType")

        # @return [String] The document identifier returned by the createFeedDocument operation. Upload the feed
        # document contents before calling the createFeed operation.
        attribute(:input_feed_document_id, String, from: "inputFeedDocumentId")

        # @return [Array<String>] A list of identifiers for marketplaces that you want the feed to be applied to.
        attribute(:marketplace_ids, [String], from: "marketplaceIds")

        # @return [Hash]
        attribute?(:feed_options, Hash, from: "feedOptions")
      end
    end
  end
end
