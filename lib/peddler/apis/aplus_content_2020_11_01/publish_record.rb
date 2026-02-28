# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The full context for an A+ Content publishing event.
      PublishRecord = Structure.new do
        # @return [String]
        attribute(:asin, String, null: false)

        # @return [String]
        attribute(:content_reference_key, String, null: false, from: "contentReferenceKey")

        # @return [String]
        attribute(:content_type, String, null: false, from: "contentType")

        # @return [String]
        attribute(:locale, String, null: false)

        # @return [String]
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String]
        attribute?(:content_sub_type, String, from: "contentSubType")
      end
    end
  end
end
