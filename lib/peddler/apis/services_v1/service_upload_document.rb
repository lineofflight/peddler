# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # Input for to be uploaded document.
      ServiceUploadDocument = Structure.new do
        # @return [Float] The content length of the to-be-uploaded file
        attribute(:content_length, Float, from: "contentLength")

        # @return [String] The content type of the to-be-uploaded file
        attribute(:content_type, String, from: "contentType")

        # @return [String] An MD5 hash of the content to be submitted to the upload destination. This value is used to
        #   determine if the data has been corrupted or tampered with during transit.
        attribute?(:content_md5, String, from: "contentMD5")
      end
    end
  end
end
