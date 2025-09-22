# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module AplusContent20201101
      # The full context for an A+ Content publishing event.
      PublishRecord = Structure.new do
        # @return [String]
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String]
        attribute(:locale, String)

        # @return [String]
        attribute(:asin, String)

        # @return [String]
        attribute(:content_type, String, from: "contentType")

        # @return [String]
        attribute(:content_sub_type, String, from: "contentSubType")

        # @return [String]
        attribute(:content_reference_key, String, from: "contentReferenceKey")
      end
    end
  end
end
