# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # The full context for an A+ Content publishing event.
      PublishRecord = Structure.new do
        attribute(:asin, String, null: false)

        attribute(:content_reference_key, String, null: false, from: "contentReferenceKey")

        attribute(:content_type, String, null: false, from: "contentType")

        attribute(:locale, String, null: false)

        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        attribute?(:content_sub_type, String, from: "contentSubType")
      end
    end
  end
end
