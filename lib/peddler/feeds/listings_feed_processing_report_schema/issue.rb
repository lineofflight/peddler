# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Feeds
    module ListingsFeedProcessingReportSchema
      # Issue containing message processing information corresponding to an individual listings data submission.
      Issue = Structure.new do
        # @return [String] Localized Error Message Associated with the issue encountered.
        attribute(:message, String)

        # @return [String] The severity of the issue.
        attribute(:severity, String)

        # @return [String] Name of the attribute associated with the issue, if applicable.
        attribute?(:attribute_name, String, from: "attributeName")

        # @return [String] An Optional error code that maps to documentation.
        attribute?(:code, String)

        # @return [Integer] Identifier for the message that is unique within this feed submission. Correlated to
        # Identifiers provided in the submitted feed. Not provided if the error is not related to a message (e.g. feed
        # formatting issue).
        attribute?(:message_id, Integer, from: "messageId")
      end
    end
  end
end
