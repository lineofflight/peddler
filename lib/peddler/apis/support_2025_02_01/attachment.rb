# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Support20250201
      # A file attachment.
      Attachment = Structure.new do
        # @return [String] The name of the attachment.
        attribute(:name, String, null: false)

        # @return [String] The download link to the attachment file. The `downloadUrl` is included in the response if
        #   available. If there is a failure to return the `downloadUrl`, this field is not included in the response.
        #   The `downloadUrl` expires after 15 minutes.
        attribute?(:download_url, String, from: "downloadUrl")
      end
    end
  end
end
