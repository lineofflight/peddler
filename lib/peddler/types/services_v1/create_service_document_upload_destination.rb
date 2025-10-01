# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/services_v1/error"
require "peddler/types/services_v1/service_document_upload_destination"

module Peddler
  module Types
    module ServicesV1
      # The response schema for the `createServiceDocumentUploadDestination` operation.
      CreateServiceDocumentUploadDestination = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [ServiceDocumentUploadDestination]
        attribute?(:payload, ServiceDocumentUploadDestination)
      end
    end
  end
end
