# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Feeds20210630
      # Specifies the content type for the createFeedDocument operation.
      CreateFeedDocumentSpecification = Structure.new do
        # @return [String] The content type of the feed.
        attribute(:content_type, String, from: "contentType")
      end
    end
  end
end
