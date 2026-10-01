# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # An issue associated with a media asset or pairing.
      Issue = Structure.new do
        # @return [Array<String>] List of issue categories.
        #
        # **Possible values:**
        #
        # * `PROCESSING_ISSUE` - Media file could not be processed (codec, duration, corrupt file).
        #
        # * `CONTENT_POLICY` - Media asset is subject to content policy restrictions.
        #
        # * `METADATA_VALIDATION` - Media metadata does not meet requirements (title, descriptions).
        attribute(:categories, [String], null: false)

        # @return [String] An issue code that identifies the type of issue.
        attribute(:code, String, null: false)

        # @return [String] A message that describes the issue.
        attribute(:message, String, null: false)

        # @return [String] The severity of the issue.
        attribute(:severity, String, null: false)

        # @return [Array<String>] Names of the properties associated with the issue, if applicable.
        attribute?(:property_names, [String], from: "propertyNames")
      end
    end
  end
end
