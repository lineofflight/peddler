# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/service_document_upload_destination"
require "peddler/types/services_v1/error"

module Peddler
  module Types
    module ServicesV1
      # The response schema for the `createServiceDocumentUploadDestination` operation.
      CreateServiceDocumentUploadDestination = Structure.new do
        # @return [ServiceDocumentUploadDestination]
        attribute(:payload, ServiceDocumentUploadDestination)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
