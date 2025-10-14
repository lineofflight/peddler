# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
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
