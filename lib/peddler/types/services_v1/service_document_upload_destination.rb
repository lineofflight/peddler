# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/services_v1/encryption_details"

module Peddler
  module Types
    module ServicesV1
      # Information about an upload destination.
      ServiceDocumentUploadDestination = Structure.new do
        # @return [EncryptionDetails]
        attribute(:encryption_details, EncryptionDetails, from: "encryptionDetails")

        # @return [String] The unique identifier to be used by APIs that reference the upload destination.
        attribute(:upload_destination_id, String, from: "uploadDestinationId")

        # @return [String] The URL to which to upload the file.
        attribute(:url, String)

        # @return [Hash] The headers to include in the upload request.
        attribute?(:headers, Hash)
      end
    end
  end
end
