# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ServicesV1
      # Document that captured during service appointment fulfillment that portrays proof of completion
      FulfillmentDocument = Structure.new do
        # @return [String] The identifier of the upload destination. Get this value by calling the
        # `createServiceDocumentUploadDestination` operation of the Services API.
        attribute(:upload_destination_id, String, from: "uploadDestinationId")

        # @return [String] Sha256 hash of the file content. This value is used to determine if the file has been
        # corrupted or tampered with during transit.
        attribute(:content_sha256, String, from: "contentSha256")
      end
    end
  end
end
